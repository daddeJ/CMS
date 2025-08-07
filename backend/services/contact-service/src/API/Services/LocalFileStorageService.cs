using ContactService.Application.Interfaces;

namespace ContactService.API.Services;

public class LocalFileStorageService : IFileStorageService
{
    private readonly IWebHostEnvironment _env;
    private const string BaseUploadPath = "uploads/contacts";

    public LocalFileStorageService(IWebHostEnvironment env)
    {
        _env = env;
    }

    public async Task<string> SaveContactImageAsync(Guid contactId, IFormFile file)
    {
        ValidateImageFile(file);

        var basePath = !string.IsNullOrEmpty(_env.WebRootPath) 
            ? _env.WebRootPath 
            : Path.Combine(_env.ContentRootPath, "wwwroot");

        var uploadsDir = Path.Combine(basePath, BaseUploadPath, contactId.ToString());
        Directory.CreateDirectory(uploadsDir);

        var fileName = $"{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
        var filePath = Path.Combine(uploadsDir, fileName);

        await using (var stream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(stream);
        }

        return Path.Combine(BaseUploadPath, contactId.ToString(), fileName);
    }

    public async Task DeleteContactImageAsync(string imagePath)
    {
        var fullPath = Path.Combine(_env.WebRootPath, imagePath);
        if (File.Exists(fullPath))
        {
            File.Delete(fullPath);
        }
    }

    public string GetImageUrl(string relativePath)
    {
        return $"/{relativePath.Replace("\\", "/")}";
    }

    private void ValidateImageFile(IFormFile file)
    {
        var allowedExtensions = new[] { ".jpg", ".jpeg", ".png", ".gif" };
        var extension = Path.GetExtension(file.FileName).ToLowerInvariant();
        
        if (string.IsNullOrEmpty(extension) || !allowedExtensions.Contains(extension))
            throw new ArgumentException("Invalid image file type");

        if (file.Length > 5 * 1024 * 1024) // 5MB
            throw new ArgumentException("Image size exceeds 5MB limit");
    }
}