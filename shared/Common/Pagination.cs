namespace Shared.Common;

public record PageResult<T>(
    IEnumerable<T> Items,
    int Page,
    int PageSize,
    int TotalCount,
    int TotalPages,
    bool HasNextPage,
    bool HasPreviousPage
)
{
    public static PageResult<T> Create(
        IEnumerable<T> items,
        int totalCount,
        int page,
        int pageSize
    )
    {
        var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);
        var hasNextPage = page < totalPages;
        var hasPreviousPage = page > 1;

        return new PageResult<T>(
            items,
            page,
            pageSize,
            totalCount,
            totalPages,
            hasNextPage,
            hasPreviousPage
        );
    }
}

public record PageQuery(
    int Page = 1,
    int PageSize = 10,
    string? SearchTerm = null,
    string? SortBy = null,
    bool SortDescending = false
)
{
    public int Skip => (Page - 1) * PageSize;
    public int Take => PageSize;
}