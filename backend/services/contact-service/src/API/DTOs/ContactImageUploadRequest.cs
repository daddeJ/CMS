using Microsoft.AspNetCore.Mvc;

public class ContactImageUploadRequest
{
    [FromForm]
    public IFormFile File { get; set; }

    [FromForm]
    public Guid ContactId { get; set; }
}