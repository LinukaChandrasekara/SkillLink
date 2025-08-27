package com.skilllink.dao.dto;

import java.util.List;

public class PagedResult<T> {
    private final List<T> items;
    private final int page;
    private final int pageSize;
    private final int totalPages;
    private final long totalItems;

    public PagedResult(List<T> items, int page, int pageSize, int totalPages, long totalItems) {
        this.items = items;
        this.page = page;
        this.pageSize = pageSize;
        this.totalPages = totalPages;
        this.totalItems = totalItems;
    }
    public List<T> getItems() { return items; }
    public int getPage() { return page; }
    public int getPageSize() { return pageSize; }
    public int getTotalPages() { return totalPages; }
    public long getTotalItems() { return totalItems; }
}
