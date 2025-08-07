using System.Security.Claims;
using ContactService.API.Extensions;
using ContactService.Application.Interfaces;
using ContactService.Application.Services;
using Microsoft.AspNetCore.Mvc;
using Shared.Common;
using Shared.Contracts.Contact;

namespace ContactService.API.Controllers;

[ApiController]
[Route("api/contacts/{contactId}/images")]
public class ContactImagesController : ControllerBase
{
    private readonly IContactImageService _contactImageService;

    public ContactImagesController(
        IContactImageService contactImageService)
    {
        _contactImageService = contactImageService;
    }

    [HttpPost]
    [DisableRequestSizeLimit]
    [RequestFormLimits(ValueLengthLimit = int.MaxValue, MultipartBodyLengthLimit = int.MaxValue)]
    public async Task<IActionResult> UploadImage(
        [FromRoute] Guid contactId,
        [FromForm] ContactImageUploadRequest request)
    {
        var userId = GetCurrentUserId();
        if (!userId.HasValue)
        {
            return Unauthorized("User ID claim is missing or invalid.");
        }
        var result = await _contactImageService.UploadContactImageAsync(contactId, userId.Value, request.File);

        return result.Match(
            imageUrl => Ok(new { ImageUrl = imageUrl }),
            error => this.FromResult(Result<ContactDto>.Failure(error))
        );
    }

    [HttpDelete]
    public async Task<IActionResult> DeleteImage(
        Guid contactId,
        [FromQuery] string imagePath)
    {
        var userId = GetCurrentUserId();
        var result = await _contactImageService.DeleteContactImageAsync(contactId, userId.Value, imagePath);

         return this.FromResult(result);
    }

    private Guid? GetCurrentUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return Guid.TryParse(userIdClaim, out var userId) ? userId : null;
    }
}