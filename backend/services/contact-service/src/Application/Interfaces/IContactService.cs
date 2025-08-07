using Shared.Contracts.Contact;
using Shared.Common;

namespace ContactService.Application.Interfaces;

public interface IContactService
{
    Task<Result<PageResult<ContactDto>>> GetContactsAsync(Guid userId, PageQuery query);
    Task<Result<ContactDto>> GetContactByIdAsync(Guid contactId, Guid userId);
    Task<Result<ContactDto>> CreateContactAsync(CreateContactRequest request, Guid userId);
    Task<Result<ContactDto>> UpdateContactAsync(Guid contactId, UpdateContactRequest request, Guid userId);
    Task<Result> DeleteContactAsync(Guid contactId, Guid userId);
    Task<Result> UpdateContactProfilePictureAsync(Guid contactId, string imageUrl, Guid userId);
}
