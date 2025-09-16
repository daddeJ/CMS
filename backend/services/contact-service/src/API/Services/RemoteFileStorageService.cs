using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.S3.Transfer;
using ContactService.Application.Interfaces;

namespace API.Services
{
    public class RemoteFileStorageService : IFileStorageService
    {
        private readonly string _bucketName;
        private readonly IAmazonS3 _s3Client;

        public RemoteFileStorageService(IAmazonS3 s3Client, string bucketName)
        {
            _s3Client = s3Client;
            _bucketName = bucketName ?? throw new ArgumentNullException(nameof(bucketName));
        }
        public async Task<string> SaveContactImageAsync(Guid contactId, IFormFile file)
        {
            if (file == null) throw new ArgumentNullException(nameof(file));

            ValidateImageFile(file);

            // Use a unique key for S3: e.g., "contacts/{contactId}/{guid}.ext"
            var fileExtension = Path.GetExtension(file.FileName).ToLowerInvariant();
            var key = $"contacts/{contactId}/{Guid.NewGuid()}{fileExtension}";

            using var stream = file.OpenReadStream();

            var uploadRequest = new TransferUtilityUploadRequest
            {
                InputStream = stream,
                Key = key,
                BucketName = _bucketName,
                CannedACL = S3CannedACL.PublicRead // optional: public URL
            };

            var transferUtility = new TransferUtility(_s3Client);
            await transferUtility.UploadAsync(uploadRequest);

            return GetImageUrl(key);
        }

        public async Task DeleteContactImageAsync(string imagePath)
        {
            if (string.IsNullOrWhiteSpace(imagePath)) return;

            // Extract key from URL if full URL is provided
            var key = imagePath.Contains(_bucketName) 
                      ? imagePath.Substring(imagePath.IndexOf(_bucketName) + _bucketName.Length + 1)
                      : imagePath;

            var deleteRequest = new DeleteObjectRequest
            {
                BucketName = _bucketName,
                Key = key
            };

            await _s3Client.DeleteObjectAsync(deleteRequest);
        }
        
        public string GetImageUrl(string key)
        {
            if (string.IsNullOrWhiteSpace(key)) return null;

            return $"https://{_bucketName}.s3.amazonaws.com/{key}";
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
}