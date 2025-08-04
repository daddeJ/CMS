using AuthService.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Shared.Contracts.Auth;

namespace AuthService.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProfileController : ControllerBase
{
    private readonly IUserProfileService _profileService;

    public ProfileController(IUserProfileService profileService)
    {
        _profileService = profileService;
    }

    [HttpGet("{userId:guid}")]
    public async Task<IActionResult> GetProfile(Guid userId)
    {
        var result = await _profileService.GetProfileAsync(userId);
        return result.IsSuccess ? Ok(result.Value) : NotFound(result.Error);
    }

    [HttpPut("{userId:guid}")]
    public async Task<IActionResult> UpdateProfile(Guid userId, UpdateProfileRequest request)
    {
        var result = await _profileService.UpdateProfileAsync(userId, request);
        return result.IsSuccess ? Ok(result.Value) : BadRequest(result.Error);
    }

    [HttpPut("{userId:guid}/change-password")]
    public async Task<IActionResult> ChangePassword(Guid userId, ChangePasswordRequest request)
    {
        var result = await _profileService.ChangePasswordAsync(userId, request);
        return result.IsSuccess ? Ok() : BadRequest(result.Error);
    }
}
