namespace Shared.Contracts.Contact;

public record ContactDto(
    int Id,
    Guid ContactId,
    Guid UserId,
    string Name,
    string Email,
    string? PhoneNumber,
    string? ProfilePicture,
    DateTime DateCreated,
    DateTime? DateUpdated
);

public record CreateContactRequest(
    string Name,
    string Email,
    string? PhoneNumber,
    string? ProfilePicture
);

public record UpdateContactRequest(
    string Name,
    string Email,
    string? PhoneNumber,
    string? ProfilePicture
);

public record ContactListResponse(
    IEnumerable<ContactDto> Contacts,
    int TotalCount,
    int Page,
    int PageSize
);

public record ContactSearchResponse(
    string? SearchTerm,
    int Page = 1,
    int PageSize = 10
);