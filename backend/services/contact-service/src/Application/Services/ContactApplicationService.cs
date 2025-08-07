using AutoMapper;
using ContactService.Application.Interfaces;
using ContactService.Domain.Entities;
using ContactService.Domain.Interfaces;
using Shared.Common;
using Shared.Contracts.Contact;

namespace ContactService.Application.Services;

public class ContactApplicationService : IContactService
{
    private readonly IContactRepository _repository;
    private readonly IMapper _mapper;

    public ContactApplicationService(IContactRepository repository, IMapper mapper)
    {
        _repository = repository;
        _mapper = mapper;
    }

    public async Task<Result<ContactDto>> CreateContactAsync(CreateContactRequest request, Guid userId)
    {
        if (await _repository.EmailExistsAsync(request.Email, userId))
            return Result<ContactDto>.Failure(Error.Conflict("Contact.EmailExists", "Email already exists"));

        var contact = _mapper.Map<Contact>(request);
        contact.UserId = userId;
        contact.DateCreated = DateTime.UtcNow;

        var created = await _repository.CreateAsync(contact);
        var dto = _mapper.Map<ContactDto>(created);

        return Result<ContactDto>.Success(dto);
    }

    public async Task<Result> DeleteContactAsync(Guid contactId, Guid userId)
    {
        var contact = await _repository.GetByContactIdAsync(contactId, userId);
        if (contact is null)
            return Result.Failure(Error.NotFound("Contact.NotFound", "Contact Not Found"));

        var success = await _repository.DeleteAsync(contact.Id, userId);
        return success ? Result.Success() : Result.Failure(Error.NotFound("Contact.NotFound", "Contact Not Found"));
    }

    public async Task<Result<ContactDto>> GetContactByIdAsync(Guid contactId, Guid userId)
    {
        var contact = await _repository.GetByContactIdAsync(contactId, userId);
        if (contact is null)
            return Result<ContactDto>.Failure(Error.NotFound("Contact.NotFound", "Contact Not Found"));

        var dto = _mapper.Map<ContactDto>(contact);
        return Result<ContactDto>.Success(dto);
    }

    public async Task<Result<PageResult<ContactDto>>> GetContactsAsync(Guid userId, PageQuery query)
    {
        try
        {
            var contactsPage = await _repository.GetAllAsync(userId, query);
            var contactDtos = _mapper.Map<IEnumerable<ContactDto>>(contactsPage.Items);

            var pageResult = PageResult<ContactDto>.Create(contactDtos, contactsPage.TotalCount, query.Page, query.PageSize);
            return Result<PageResult<ContactDto>>.Success(pageResult);
        }
        catch (Exception ex)
        {
            return Result<PageResult<ContactDto>>.Failure(Error.Failure("Contact.Failure", ex.Message));
        }
    }

    public async Task<Result<ContactDto>> UpdateContactAsync(Guid contactId, UpdateContactRequest request, Guid userId)
    {
        var contact = await _repository.GetByContactIdAsync(contactId, userId);
        if (contact is null)
            return Result<ContactDto>.Failure(Error.NotFound("Contact.NotFound", "Contact Not Found"));

        if (await _repository.EmailExistsAsync(request.Email, userId, contact.Id))
            return Result<ContactDto>.Failure(Error.NotFound("Contact.NotFound", "Contact Not Found"));

        contact.Name = request.Name;
        contact.Email = request.Email;
        contact.PhoneNumber = request.PhoneNumber;
        contact.ProfilePicture = request.ProfilePicture;

        var updated = await _repository.UpdateAsync(contact);
        var dto = _mapper.Map<ContactDto>(updated);

        return Result<ContactDto>.Success(dto);
    }

    public async Task<Result> UpdateContactProfilePictureAsync(Guid contactId, string imageUrl, Guid userId)
{
    var contact = await _repository.GetByContactIdAsync(contactId, userId);
    if (contact is null)
        return Result.Failure(Error.NotFound("Contact.NotFound", "Contact not found"));

    // Validate the image URL (optional)
    if (string.IsNullOrWhiteSpace(imageUrl))
        return Result.Failure(Error.Validation("Contact.InvalidImageUrl", "Image URL cannot be empty"));

    // Update only the profile picture
    contact.ProfilePicture = imageUrl;
    contact.DateUpdated = DateTime.UtcNow;

    var updated = await _repository.UpdateAsync(contact);
    if (updated == null)
        return Result.Failure(Error.Failure("Contact.UpdateFailed", "Failed to update contact profile picture"));

    return Result.Success();
}
}
