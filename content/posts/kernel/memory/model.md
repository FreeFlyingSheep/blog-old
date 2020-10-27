---
title: "内存模型"
date: 2020-10-27
lastmod: 2020-10-27
tags: [Linux 内核, 内存管理, 内存模型]
categories: [Kernel]
draft: false
---

[Linux 内核学习笔记系列](/posts/kernel/kernel)，内存管理部分，简单介绍内存模型。

<!--more-->

## 内存模型简介

简单概括，内存被划分为若干个节点，每个节点又被划分为若干个区，而每个区又包含若干页框。

## 节点 (Node)

### 节点简介

我们习惯上认为计算机内存是一种均匀、共享的资源，即在忽略硬件高速缓存作用的情况下，任意 CPU 对任意内存单元的访问都需要相同时间。这种模型被称为**一致访问内存 (UMA)** 模型。IBM 兼容 PC 一般都采用这种模型。

但对于某些体系结构，如 ALpha 或 MIPS，这种假设不成立。它们使用**非一致访问内存 (NUMA)** 模型。

Linux 支持 NUMA 模型，它通过把物理内存划分为多个节点，来保证对于每个节点，给定的 CPU 访问页面需要的时间相同。这样对于每个 CPU，内核可以试图把耗时节点的访问次数减到最小。

在配置不使用 NUMA 的情况下，Linux 还是会使用一个单独的节点，包括所有的物理内存。

### 节点数据结构

`include/linux/mm_types.h`：

```c
typedef struct pglist_data {
    struct zone node_zones[MAX_NR_ZONES];
    struct zonelist node_zonelists[MAX_ZONELISTS];
    int nr_zones;
    ...
    struct page *node_mem_map;
    ...
    struct bootmem_data *bdata;
    ...
    unsigned long node_start_pfn;
    unsigned long node_present_pages; /* total number of physical pages */
    unsigned long node_spanned_pages; /* total size of physical page
                                         range, including holes */
    int node_id;
    wait_queue_head_t kswapd_wait;
    struct task_struct *kswapd;
    int kswapd_max_order;
} pg_data_t;
```

- `node_zones`：包含节点中区数据结构的数组。若区没有那么多，其余项用 `0` 填充。
- `node_zonelists`：备用节点及内存区域列表，以便在当前节点没有可用空间时，在备用节点分配内存。
- `nr_zones`：不同区的数目。
- `node_mem_map`：指向页实例的指针，包含了当前节点所有区的页。
- `bdata`：指向自举内存分配器实例的指针，见[内存管理初始化](/posts/kernel/memory/init)。
- `node_start_pfn`：当前节点第一个页帧的逻辑编号，系统中所有页帧是依次编号的，因此每个页帧的号码都是全局唯一的。特别地，在 UMA 系统中，因为只有一个节点，所以该值总为 `0`。
- `node_present_pages`：当前节点中页帧的数目。
- `node_spanned_pages`：以页帧为单位计算的长度。
- `node_id`：全局节点编号，从 `0` 开始。
- `kswapd_wait`、`kswapd` 和 `kswapd_max_order`：交换守护进程 (swap daemon) 相关的内容，见 [TODO](/posts/kernel/old/todo)。

### 节点状态管理

`include/linux/nodemask.h`：

```c
enum node_states {
    N_POSSIBLE,         /* The node could become online at some point */
    N_ONLINE,           /* The node is online */
    N_NORMAL_MEMORY,    /* The node has regular memory */
#ifdef CONFIG_HIGHMEM
    N_HIGH_MEMORY,      /* The node has regular or high memory */
#else
    N_HIGH_MEMORY = N_NORMAL_MEMORY,
#endif
    N_CPU,              /* The node has one or more cpus */
    NR_NODE_STATES
};
```

`N_POSSIBLE`、`N_ONLINE` 和 `N_NORMAL_MEMORY` 用于内存热插拔，这部分内容不属于该系列学习笔记的范畴。

设置和清除节点的特定位使用 `void node_set_state(int node, enum node_states state)` 和 `void node_clear_state(int node, enum node_states state)` 函数。

## 区 (内存域，Zone)

### 区简介

理想模型中，所有的页框都是相同的，可以对其执行任何操作。现实中，硬件是有限制的：

- 一些硬件只能用某些特定的内存地址来执行 DMA。
- 一些体系结构的内存的物理地址范围比虚拟地址范围大得多，线性地址空间太小导致 CPU 不能直接访问所有的物理内存。

对内存的每个节点，Linux 分了 3 个区来解决这些限制：

- `ZONE_DMA`：执行 DMA 操作的页框。
- `ZONE_NORMAL`：能正常映射的页框。
- `ZONE_HIGHMEM`：动态映射的页框。

此处两本书的描述略有不同，《Linux 内核设计与实现》基于 2.6.34 版本，这时候已经新加了 `ZONE_DMA32` 区，该区和 `ZONE_DMA` 的区别在于这个区能被 32 位的设备访问。在 32 位系统上，该区长度为 `0`，而在 64 位系统上，该区长度可能为 `0-4G`。该区是 2.6.14 版本添加的，参考社区新闻 [ZONE_DMA32](https://lwn.net/Articles/152462/)。

`ZONE_HIGHMEM` 区的内存被称为**高端内存**，其余部分则被称为**低端内存**。

举个例子，在 x86 上，`ZONE_DMA` 包含了物理内存 `0-16MB`，`ZONE_NORMAL` 包含了 `16-896MB`，`ZONE_HIGHMEM` 包含了剩下的部分。

但**不是所有体系结构都定义了全部区**，如 x86-64 可以映射处理 64 位的内存空间，就不需要 `ZONE_HIGHMEM` 区了。

### 区的类型

`include/linux/mmzone.h`：

```c
enum zone_type {
#ifdef CONFIG_ZONE_DMA
    ZONE_DMA,
#endif
#ifdef CONFIG_ZONE_DMA32
    ZONE_DMA32,
#endif
    ZONE_NORMAL,
#ifdef CONFIG_HIGHMEM
    ZONE_HIGHMEM,
#endif
    ZONE_MOVABLE,
    __MAX_NR_ZONES
};
```

其中，`ZONE_MOVABLE` 是伪内存区域，用于防止内存碎片的机制，见 [TODO](/posts/kernel/old/todo)。`__MAX_NR_ZONES` 在构建过程中会生成 `include/generated/bounds.h` 中的 `MAX_NR_ZONES` 宏 (具体生成过程涉及 Kbuild，已经不属于本系列学习笔记的范畴)，充当结束标记。

### 区数据结构

区相关的枚举和结构体大部分位于 `include/linux/mmzone.h`：

```c
struct zone {
    /* Fields commonly accessed by the page allocator */

    unsigned long watermark[NR_WMARK];

    unsigned long           lowmem_reserve[MAX_NR_ZONES];

    struct per_cpu_pageset __percpu *pageset;

    /*
     * free areas of different sizes
     */
    spinlock_t              lock;
    ...
    struct free_area        free_area[MAX_ORDER];
    ...
    ZONE_PADDING(_pad1_)

    /* Fields commonly accessed by the page reclaim scanner */
    spinlock_t              lru_lock;
    struct zone_lru {
        struct list_head list;
    } lru[NR_LRU_LISTS];

    ...

    unsigned long            pages_scanned; /* since last reclaim */
    unsigned long            flags;         /* zone flags, see below */

    /* Zone statistics */
    atomic_long_t            vm_stat[NR_VM_ZONE_STAT_ITEMS];

    int prev_priority;

    ...

    ZONE_PADDING(_pad2_)
    /* Rarely used or read-mostly fields */

    wait_queue_head_t       * wait_table;
    unsigned long           wait_table_hash_nr_entries;
    unsigned long           wait_table_bits;

    /*
     * Discontig memory support fields.
     */
    struct pglist_data      *zone_pgdat;
    /* zone_start_pfn == zone_start_paddr >> PAGE_SHIFT */
    unsigned long           zone_start_pfn;

    unsigned long           spanned_pages;  /* total size, including holes */
    unsigned long           present_pages;  /* amount of memory (excluding holes) */

    /*
     * rarely used fields:
     */
    const char              *name;
} ____cacheline_internodealigned_in_smp;
```

该结构体被 `ZONE_PADDING` 分割为多个部分：

```c
/*
 * zone->lock and zone->lru_lock are two of the hottest locks in the kernel.
 * So add a wild amount of padding here to ensure that they fall into separate
 * cachelines.  There are very few zone structures in the machine, so space
 * consumption is not a concern here.
 */
#if defined(CONFIG_SMP)
struct zone_padding {
    char x[0];
} ____cacheline_internodealigned_in_smp;
#define ZONE_PADDING(name) struct zone_padding name;
#else
#define ZONE_PADDING(name)
#endif
```

因为对该结构体的访问非常频繁，在多处理系统上，通常会有不同的 CPU 试图访问结构体成员。使用 `ZONE_PADDING` 宏填充结构体，以确保每个自旋锁都处于自己的缓存行中。使用 `____cacheline_internodealigned_in_smp`，实现最优的告诉缓存对齐方式。

#### 第一部分

先来看该结构体的第一部分，通常由页分配器访问的字段。

`watermark` 是页换出时使用的“水位标志”：

```c
enum zone_watermarks {
    WMARK_MIN,
    WMARK_LOW,
    WMARK_HIGH,
    NR_WMARK
};
```

在较早版本的内核中，“水位标志”由三个 `unsigned long` 变量 `pages_min`、`pages_low` 和 `pages_high` 构成，现在它们被合并到了 `watermark` 数组。下面为了方便讨论该数组的三个元素，依然使用它们的旧变量名。

这三个元素会影响交换守护程序的行为，这里只做简单介绍：

- `pages_high`：若空闲页多于该值，则区的状态是理想的。
- `pages_low`：若空闲页低于该值，则内核开始讲页换出到硬盘。
- `pages_min`：若空闲页低于该值，那么页回收工作的压力较大，内存急需空闲页。

`lowmem_reserve` 数组代表每个区必须保留的页框数目，见 [TODO](/posts/kernel/old/todo)。

`pageset` 用于实现每个 CPU 的冷/热页帧列表，见 [TODO](/posts/kernel/old/todo)。

`free_area` 用于实现伙伴系统，见 [TODO](/posts/kernel/old/todo)。

#### 第二部分

再来看该结构体的第二部分，通常由页面回收扫描程序访问的字段。

根据 `lru` 数组的名字，可以推测现在内核使用了 LRU 算法来管理页，该数组包含了若干个链表：

```c
#define LRU_BASE 0
#define LRU_ACTIVE 1
#define LRU_FILE 2

enum lru_list {
    LRU_INACTIVE_ANON = LRU_BASE,
    LRU_ACTIVE_ANON = LRU_BASE + LRU_ACTIVE,
    LRU_INACTIVE_FILE = LRU_BASE + LRU_FILE,
    LRU_ACTIVE_FILE = LRU_BASE + LRU_FILE + LRU_ACTIVE,
    LRU_UNEVICTABLE,
    NR_LRU_LISTS
};
```

这里先定义宏，再用宏的值定义枚举成员的值，目的是方便后续计算时使用这些宏的值，同时又可以用枚举成员作为与之对应的数组下标。

较早的版本没有使用 `lru` 数组，而是用 `struct list_head active_list` 表示活动页的集合，`struct list_head inactive_list` 表示不活动页的集合，`unsigned long nr_scan_active` 和 `unsigned long nr_scan_inactive` 指定在回收内存时需要扫描的活动页和不活动页的数目，后面的内容针对的是较新的版本。

`pages_scanned` 指定了上次换出一页以来，有多少页未能成功扫描，见 [TODO](/posts/kernel/old/todo)。

`flags` 描述当前区的状态：

```c
typedef enum {
    ZONE_RECLAIM_LOCKED,    /* prevents concurrent reclaim */
    ZONE_OOM_LOCKED,        /* zone is in OOM killer zonelist */
} zone_flags_t;
```

同样的，内核提供了相应的辅助函数来设置状态：

```c
void zone_set_flag(struct zone *zone, zone_flags_t flag);
int zone_test_and_set_flag(struct zone *zone, zone_flags_t flag);
void zone_clear_flag(struct zone *zone, zone_flags_t flag);
```

`vm_stat` 维护了当前区的统计信息。可以使用辅助函数 `unsigned long zone_page_state(struct zone *zone, enum zone_stat_item item)` 来读取其中的信息，该函数定义于 `include/linux/vmstat.h`。

`prev_priority` 存储了上一次扫描操作扫描当前区的优先级，见 [TODO](/posts/kernel/old/todo)。

#### 第三部分

最后来看该结构体的第三部分，很少使用或大多数情况下只读的字段。

`wait_table`、`wait_table_hash_nr_entries` 和 `wait_table_bits` 实现了一个等待队列，可用于等待某一页变为可用进程。可以简单理解为进程排成一一个队列，等待某些条件，在条件变为真时，内核会通知进程恢复工作。具体原理见 [TODO](/posts/kernel/old/todo)。

`zone_pgdat` 指向对应的 `pg_list_data` 实例，建立了区和父结点之间的关联。

`zone_start_pfn` 是内存域第一个页帧的索引。

`spanned_pages` 指定区中页的总数，但并非所有都是可用的，内存中可能存在一些小的空洞。

`present_pages` 则给出了实际可用的页的总数。

`name` 是一个字符串，保存当前区的惯用名称。

## 页 (Page)

### 页和页框简介

页框是系统内存的最小单位，对内存中的每个页，内核都会创建一个 `struct page` 实例。

注意区分术语“页”和“页框”。操作系统为了方便管理存储器，把数据分成固定大小的区块，这些区块被称为页 (页面，page)。处理器的分页单元会根据页的大小把物理内存划分为若干个物理块，这些物理块就是页框 (页帧，page frame)。页存放于页框中，而 `struct page` 是页对应的描述符。

### 页数据结构

TODO
