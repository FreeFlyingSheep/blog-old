---
title: "Linux 内存管理 (伙伴系统)"
date: 2020-07-21
lastmod: 2020-07-22
tags: [Linux 内核, 内存管理, 伙伴系统]
categories: [Kernel]
draft: false
---

根据《深入理解 Linux 内核》(第三版) 和《Linux 内核设计与实现》(原书第 3 版) 内存管理部分的整理和补充，具体介绍伙伴系统。代码部分基于 Linux kernel release 2.6.11.12。

<!--more-->

## 伙伴系统简介

伙伴 (Buddy) 系统是为了解决外碎片问题而设计的。

伙伴系统算法把所有的空闲页框分为 11 个块链表，每个块链表分别包含 1、2、4、8、16、32、64、128、256、512 和 1024 个连续的页框。每个块的第一个页框的物理地址是该块大小的整数倍。由于内核页大小是 4 KB，所以最大请求为 4 MB 大小连续的 RAM 块。

在请求块时，算法会先在请求页框大小块的链表中检查是否有一个空闲块，如果没有，就查找下一个更大的块，把这个块分裂为两个小块。如果还是没有找到，就继续查找更大块，直到最大的 1024 个页框的块。如果 1024 个页框的链表还是空的，算法就放弃并发出错误信号。

在释放块时，算法会试图把一对空闲伙伴合并为一个单独的块，且算法是迭代的，即算法会再次试图合成的生成的块。满足以下条件的两个块被称为伙伴：

- 两个块具有相同的大小，记作 $b$。
- 它们的物理地址连续。
- 第一个块的第一个页框的物理地址是 $2 \times b \times 2^{12}$。

由于块的大小都是 2 的幂，所以被称为伙伴的块只有一位二进制位不同。对于一个块，只需要与掩码 (`1 << order`) 进行异或操作，就能找到它的伙伴。

## 伙伴系统的实现

### 分配块

`mm/page_alloc.c`：

``` C
static inline struct page *
expand(struct zone *zone, struct page *page,
    int low, int high, struct free_area *area)
{
    unsigned long size = 1 << high;

    while (high > low) { // current_order > order
        area--;
        high--;
        size >>= 1;
        BUG_ON(bad_range(zone, &page[size]));
        list_add(&page[size].lru, &area->free_list); // 添加到空闲链表
        area->nr_free++;
        set_page_order(&page[size], high); // 设置 private
    }
    return page;
}

/*
 * Do the hard work of removing an element from the buddy allocator.
 * Call me with the zone->lock already held.
 */
static struct page *__rmqueue(struct zone *zone, unsigned int order)
{
    struct free_area * area;
    unsigned int current_order;
    struct page *page;

    for (current_order = order; current_order < MAX_ORDER; ++current_order) {
        area = zone->free_area + current_order;
        if (list_empty(&area->free_list))
            continue;

        page = list_entry(area->free_list.next, struct page, lru);
        list_del(&page->lru); // 从空闲链表中删除
        rmv_page_order(page); // 清除 private
        area->nr_free--;
        zone->free_pages -= 1UL << order;
        return expand(zone, page, order, current_order, area);
    }

    return NULL;
}
```

### 释放块

`mm/page_alloc.c`：

``` C
static inline void __free_pages_bulk (struct page *page, struct page *base,
        struct zone *zone, unsigned int order)
{
    unsigned long page_idx;
    struct page *coalesced;
    int order_size = 1 << order;

    if (unlikely(order))
        destroy_compound_page(page, order);

    page_idx = page - base;

    BUG_ON(page_idx & (order_size - 1));
    BUG_ON(bad_range(zone, page));

    zone->free_pages += order_size;
    while (order < MAX_ORDER-1) {
        struct free_area *area;
        struct page *buddy;
        int buddy_idx;

        buddy_idx = (page_idx ^ (1 << order));
        buddy = base + buddy_idx;
        if (bad_range(zone, buddy))
            break;
        if (!page_is_buddy(buddy, order))
            break;
        /* Move the buddy up one level. */
        list_del(&buddy->lru);
        area = zone->free_area + order;
        area->nr_free--;
        rmv_page_order(buddy);
        page_idx &= buddy_idx;
        order++;
    }
    coalesced = base + page_idx;
    set_page_order(coalesced, order);
    list_add(&coalesced->lru, &zone->free_area[order].free_list);
    zone->free_area[order].nr_free++;
}
```
