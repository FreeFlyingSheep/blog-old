---
title: "Linux 内存管理 (基础部分)"
date: 2020-07-20
lastmod: 2020-07-30
tags: [Linux 内核, 内存管理]
categories: [Kernel]
draft: false
---

根据《深入理解 Linux 内核》(第三版) 和《Linux 内核设计与实现》(原书第 3 版) 内存管理部分的整理和补充，具体介绍内存模型和页框分配。代码部分基于 Linux kernel release 2.6.11.12。

<!--more-->

## 内存模型

简单概括，内存被划分为若干个节点，每个节点又被划分为若干个区，而每个区又包含若干页框。

页框 (page frame) 是存储单元 (从内存角度来看)，页 (page) 是存储的内容 (从程序角度来看)，一个页框能存放一个页的内容，在某些地方，我对“页”和“页框”的使用可能不恰当。

注意区分 (内核的) 高速缓存和硬件高速缓存，前者是指内核为了管理内存而提出的诸多数据结构，后者是指一个计算机硬件。

### 页 (Page)

`include/linux/mm.h`：

```c
/*
 * Each physical page in the system has a struct page associated with
 * it to keep track of whatever it is we are using the page for at the
 * moment. Note that we have no way to track which tasks are using
 * a page.
 */
struct page {
    page_flags_t flags; /* Atomic flags, some possibly
                     * updated asynchronously */
    atomic_t _count; /* Usage count, see below. */
    atomic_t _mapcount; /* Count of ptes mapped in mms,
                     * to show when page is mapped
                     * & limit reverse map searches.
                     */
    unsigned long private; /* Mapping-private opaque data:
                     * usually used for buffer_heads
                     * if PagePrivate set; used for
                     * swp_entry_t if PageSwapCache
                     * When page is free, this indicates
                     * order in the buddy system.
                     */
    struct address_space *mapping; /* If low bit clear, points to
                     * inode address_space, or NULL.
                     * If page mapped as anonymous
                     * memory, low bit is set, and
                     * it points to anon_vma object:
                     * see PAGE_MAPPING_ANON below.
                     */
    pgoff_t index; /* Our offset within mapping. */
    struct list_head lru; /* Pageout list, eg. active_list
                     * protected by zone->lru_lock !
                     */
    /*
     * On machines where all RAM is mapped into kernel address space,
     * we can simply calculate the virtual address. On machines with
     * highmem some memory is mapped into kernel virtual memory
     * dynamically, so we need a place to store that address.
     * Note that this field could be 16 bits on x86 ... ;)
     *
     * Architectures with slow multiplication can define
     * WANT_PAGE_VIRTUAL in asm/page.h
     */
#if defined(WANT_PAGE_VIRTUAL)
    void *virtual; /* Kernel virtual address (NULL if
                       not kmapped, ie. highmem) */
#endif /* WANT_PAGE_VIRTUAL */
};
```

`mm/memory.c`：

```c
struct page *mem_map;
```

`flags` 的标志含义位于 `include/linux/page-flags.h`。

页框的状态信息保存在页描述符 `page` 中，所有的页描述符存放在 `mem_map` 数组中。

**从虚拟内存的角度看，页就是最小单位。**

### 节点 (Node)

我们习惯上认为计算机内存是一种均匀、共享的资源，即在忽略硬件高速缓存作用的情况下，任意 CPU 对任意内存单元的访问都需要相同时间。这种模型被称为**一致访问内存 (UMA)** 模型。IBM 兼容 PC 一般都采用这种模型。

但对于某些体系结构，如 ALpha 或 MIPS，这种假设不成立。它们使用**非一致访问内存 (NUMA)** 模型。

Linux 支持 NUMA 模型，它通过把物理内存划分为多个节点，来保证对于每个节点，给定的 CPU 访问页面需要的时间相同。这样对于每个 CPU，内核可以试图把耗时节点的访问次数减到最小。

在配置不使用 NUMA 的情况下，Linux 还是会使用一个单独的节点，包括所有的物理内存。

### 区 (Zone)

理想模型中，所有的页框都是相同的，可以对其执行任何操作。现实中，硬件是有限制的：

- 一些硬件只能用某些特定的内存地址来执行 DMA。
- 一些体系结构的内存的物理地址范围比虚拟地址范围大得多，线性地址空间太小导致 CPU 不能直接访问所有的物理内存。

对内存的每个节点，Linux 分了 3 个区来解决这些限制：

- `ZONE_DMA`：执行 DMA 操作的页框。
- `ZONE_NORMAL`：能正常映射的页框。
- `ZONE_HIGHMEM`：动态映射的页框。

此处两本书的描述略有不同，《Linux 内核设计与实现》基于 2.6.34 版本，这时候已经新加了 `ZONE_DMA32` 区，该区和 `ZONE_DMA` 的区别在于这个区只能被 32 位的设备访问。该区具体是 2.6.14 版本添加的，参考社区新闻 *[ZONE_DMA32](https://lwn.net/Articles/152462/)*。

这些定义位于 `include/linux/mmzone.h`。

`ZONE_HIGHMEM` 区的内存被称为**高端内存**，其余部分则被称为**低端内存**。

举个例子，在 x86 上，`ZONE_DMA` 包含了物理内存 0-16 MB，`ZONE_NORMAL` 包含了 16-896 MB，`ZONE_HIGHMEM` 包含了剩下的部分。

但**不是所有体系结构都定义了全部区**，如 x86-64 可以映射处理 64 位的内存空间，就不需要 `ZONE_HIGHMEM` 区了。

## 分区页框分配器

### 请求页框的标志

`include/linux/gfp.h`：

```c
/*
 * GFP bitmasks..
 */
/* Zone modifiers in GFP_ZONEMASK (see linux/mmzone.h - low two bits) */
#define __GFP_DMA 0x01
#define __GFP_HIGHMEM 0x02

/*
 * Action modifiers - doesn't change the zoning
 *
 * __GFP_REPEAT: Try hard to allocate the memory, but the allocation attempt
 * _might_ fail.  This depends upon the particular VM implementation.
 *
 * __GFP_NOFAIL: The VM implementation _must_ retry infinitely: the caller
 * cannot handle allocation failures.
 *
 * __GFP_NORETRY: The VM implementation must not retry indefinitely.
 */
#define __GFP_WAIT 0x10 /* Can wait and reschedule? */
#define __GFP_HIGH 0x20 /* Should access emergency pools? */
#define __GFP_IO 0x40 /* Can start physical IO? */
#define __GFP_FS 0x80 /* Can call down to low-level FS? */
#define __GFP_COLD 0x100 /* Cache-cold page required */
#define __GFP_NOWARN 0x200 /* Suppress page allocation failure warning */
#define __GFP_REPEAT 0x400 /* Retry the allocation.  Might fail */
#define __GFP_NOFAIL 0x800 /* Retry for ever.  Cannot fail */
#define __GFP_NORETRY 0x1000 /* Do not retry.  Might fail */
#define __GFP_NO_GROW 0x2000 /* Slab internal usage */
#define __GFP_COMP 0x4000 /* Add compound page metadata */
#define __GFP_ZERO 0x8000 /* Return zeroed page on success */

#define __GFP_BITS_SHIFT 16 /* Room for 16 __GFP_FOO bits */
#define __GFP_BITS_MASK ((1 << __GFP_BITS_SHIFT) - 1)

/* if you forget to add the bitmask here kernel will crash, period */
#define GFP_LEVEL_MASK (__GFP_WAIT|__GFP_HIGH|__GFP_IO|__GFP_FS| \
            __GFP_COLD|__GFP_NOWARN|__GFP_REPEAT| \
            __GFP_NOFAIL|__GFP_NORETRY|__GFP_NO_GROW|__GFP_COMP)

#define GFP_ATOMIC (__GFP_HIGH)
#define GFP_NOIO (__GFP_WAIT)
#define GFP_NOFS (__GFP_WAIT | __GFP_IO)
#define GFP_KERNEL (__GFP_WAIT | __GFP_IO | __GFP_FS)
#define GFP_USER (__GFP_WAIT | __GFP_IO | __GFP_FS)
#define GFP_HIGHUSER (__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HIGHMEM)

/* Flag - indicates that the buffer will be suitable for DMA.  Ignored on some
   platforms, used as appropriate on others */

#define GFP_DMA __GFP_DMA
```

### 请求页框

| 函数 | 功能 |
| --- | --- |
| `alloc_pages(gfp_mask, order)` | 请求 $2^{order}$ 个连续的页框，成功则返回分配的第一个页框描述符的地址，失败则返回 `NULL`。 |
| `alloc_page(gfp_mask)` | 请求一个单独的页框，成功则返回分配的第一个页框描述符的地址，失败则返回 `NULL`。 |
| `__get_free_pages(gfp_mask, order)` | 请求 $2^{order}$ 个连续的页框，成功则返回分配的第一个页框的线性地址，失败则返回 `0`。 |
| `__get_free_page(gfp_mask)` | 请求一个单独的页框，成功则返回分配的第一个页框的线性地址，失败则返回 `0`。 |
| `get_zeroed_page(gfp_mask)` | 请求一个填满 `0` 的单独的页框，成功则返回分配的第一个页框的线性地址，失败则返回 `0`。 |
| `__get_dma_pages(gfp_mask, order)` | 请求 $2^{order}$ 个适用于 DMA 的页框，成功则返回分配的第一个页框的线性地址，失败则返回 `0`。 |

`include/linux/gfp.h`：

```c
static inline struct page *alloc_pages_node(int nid, unsigned int gfp_mask,
                        unsigned int order)
{
    if (unlikely(order >= MAX_ORDER))
        return NULL;

    return __alloc_pages(gfp_mask, order,
        NODE_DATA(nid)->node_zonelists + (gfp_mask & GFP_ZONEMASK));
}

#ifdef CONFIG_NUMA
extern struct page *alloc_pages_current(unsigned gfp_mask, unsigned order);

static inline struct page *
alloc_pages(unsigned int gfp_mask, unsigned int order)
{
    if (unlikely(order >= MAX_ORDER))
        return NULL;

    return alloc_pages_current(gfp_mask, order);
}
#else
#define alloc_pages(gfp_mask, order) \
        alloc_pages_node(numa_node_id(), gfp_mask, order)
#endif
#define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)

extern unsigned long FASTCALL(__get_free_pages(unsigned int gfp_mask, unsigned int order));
extern unsigned long FASTCALL(get_zeroed_page(unsigned int gfp_mask));

#define __get_free_page(gfp_mask) \
        __get_free_pages((gfp_mask),0)

#define __get_dma_pages(gfp_mask, order) \
        __get_free_pages((gfp_mask) | GFP_DMA,(order))
```

`mm/page_alloc.c`：

```c
/*
 * Common helper functions.
 */
fastcall unsigned long __get_free_pages(unsigned int gfp_mask, unsigned int order)
{
    struct page * page;
    page = alloc_pages(gfp_mask, order);
    if (!page)
        return 0;
    return (unsigned long) page_address(page);
}

EXPORT_SYMBOL(__get_free_pages);

fastcall unsigned long get_zeroed_page(unsigned int gfp_mask)
{
    struct page * page;

    /*
     * get_zeroed_page() returns a 32-bit address, which cannot represent
     * a highmem page
     */
    BUG_ON(gfp_mask & __GFP_HIGHMEM);

    page = alloc_pages(gfp_mask | __GFP_ZERO, 0);
    if (page)
        return (unsigned long) page_address(page);
    return 0;
}

EXPORT_SYMBOL(get_zeroed_page);
```

`mm/mempolicy.c`：

```c
/**
 *  alloc_pages_current - Allocate pages.
 *
 *  @gfp:
 *      %GFP_USER   user allocation,
 *          %GFP_KERNEL kernel allocation,
 *          %GFP_HIGHMEM highmem allocation,
 *          %GFP_FS     don't call back into a file system.
 *          %GFP_ATOMIC don't sleep.
 *  @order: Power of two of allocation size in pages. 0 is a single page.
 *
 *  Allocate a page from the kernel page pool.  When not in
 *  interrupt context and apply the current process NUMA policy.
 *  Returns NULL when no page can be allocated.
 */
struct page *alloc_pages_current(unsigned gfp, unsigned order)
{
    struct mempolicy *pol = current->mempolicy;

    if (!pol || in_interrupt())
        pol = &default_policy;
    if (pol->policy == MPOL_INTERLEAVE)
        return alloc_page_interleave(gfp, order, interleave_nodes(pol));
    return __alloc_pages(gfp, order, zonelist_policy(gfp, pol));
}
EXPORT_SYMBOL(alloc_pages_current);
```

`__alloc_pages()` 函数见[管理区分配器](/posts/kernel/memory/zone_allocator)。

### 释放页框

| 函数 | 功能 |
| --- | --- |
| `__free_pages(page, order)` | 检查 `page` 指向的页描述符，若该页框未被保留 (`PG_reserved` 标志为 `0`)，就把 `count` 减一。如果 `count` 为 `0`，就释放页框。 |
| `free_pages(addr, order)` | 接受页框的线性地址而不是页描述符，其余和 `__free_pages(page, order)` 相同 |
| `__free_page(page)` | `__free_pages(page, 0)` |
| `free_page(addr)` | `free_pages(addr, 0)` |

`include/linux/gfp.h`：

```c
extern void FASTCALL(__free_pages(struct page *page, unsigned int order));
extern void FASTCALL(free_pages(unsigned long addr, unsigned int order));
extern void FASTCALL(free_hot_page(struct page *page));
extern void FASTCALL(free_cold_page(struct page *page));

#define __free_page(page) __free_pages((page), 0)
#define free_page(addr) free_pages((addr),0)
```

`mm/page_alloc.c`：

```c
fastcall void free_pages(unsigned long addr, unsigned int order)
{
    if (addr != 0) {
        BUG_ON(!virt_addr_valid((void *)addr));
        __free_pages(virt_to_page((void *)addr), order);
    }
}

EXPORT_SYMBOL(free_pages);
```

`__free_pages()` 函数见[管理区分配器](/posts/kernel/memory/zone_allocator)。

很多函数涉及[伙伴系统](/posts/kernel/memory/buddy_system)和 [per-CPU 页框高速缓存](/posts/kernel/memory/per_cpu)，这里就不展开了。
