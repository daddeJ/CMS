using ContactService.Application.Interfaces;
using Microsoft.AspNetCore.Http;
using Shared.Common;

namespace ContactService.Application.Services;

public class ContactImageService : IContactImageService
{
    private readonly IFileStorageService _fileStorage;
    private readonly IContactService _contactService;

    public ContactImageService(
        IFileStorageService fileStorage,
        IContactService contactService)
    {
        _fileStorage = fileStorage;
        _contactService = contactService;
    }

public async Task<Result<string>> UploadContactImageAsync(Guid contactId, Guid userId, IFormFile file)
{
    try
    {
        var imagePath = await _fileStorage.SaveContactImageAsync(contactId, file);

        var imageUrl = _fileStorage.GetImageUrl(imagePath); 
        
        var updateResult = await _contactService.UpdateContactProfilePictureAsync(contactId, imageUrl, userId);
        if (updateResult.IsFailure)
        {
            await _fileStorage.DeleteContactImageAsync(imagePath);
            return Result<string>.Failure(updateResult.Error);
        }

        return Result<string>.Success(imageUrl);
    }
    catch (Exception ex)
    {
        return Result<string>.Failure(Error.Failure("Image.UploadFailed", ex.Message));
    }
}

    public async Task<Result> DeleteContactImageAsync(Guid contactId, Guid userId, string currentImagePath)
    {
        if (string.IsNullOrEmpty(currentImagePath))
            return Result.Failure(Error.Validation("Image.InvalidPath", "No image to delete"));

        try
        {
            await _fileStorage.DeleteContactImageAsync(currentImagePath);
            
            var updateResult = await _contactService.UpdateContactProfilePictureAsync(contactId, null, userId);
            if (updateResult.IsFailure)
            {
                return Result.Failure(updateResult.Error);
            }

            return Result.Success();
        }
        catch (Exception ex)
        {
            return Result.Failure(Error.Failure("Image.DeleteFailed", ex.Message));
        }
    }
}