using Microsoft.AspNetCore.Http;
using Shared.Common;

namespace ContactService.Application.Interfaces;

public interface IContactImageService
{
    Task<Result<string>> UploadContactImageAsync(Guid contactId, Guid userId, IFormFile file);
    Task<Result> DeleteContactImageAsync(Guid contactId, Guid userId, string currentImagePath);
}