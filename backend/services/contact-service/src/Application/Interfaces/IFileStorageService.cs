using Microsoft.AspNetCore.Http;

namespace ContactService.Application.Interfaces;

public interface IFileStorageService
{
    Task<string> SaveContactImageAsync(Guid contactId, IFormFile file);
    Task DeleteContactImageAsync(string imagePath);
    string GetImageUrl(string relativePath);
}