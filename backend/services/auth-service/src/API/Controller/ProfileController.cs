using AuthService.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Shared.Contracts.Auth;
using AuthService.API.Extensions;

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
    public async Task<ActionResult<UserDto>> GetProfile(Guid userId)
    {
        var result = await _profileService.GetProfileAsync(userId);
        return this.FromResult(result);
    }

    [HttpPut("{userId:guid}")]
    public async Task<ActionResult<UserDto>> UpdateProfile(Guid userId, UpdateProfileRequest request)
    {
        var result = await _profileService.UpdateProfileAsync(userId, request);
        return this.FromResult(result);
    }

    [HttpPut("{userId:guid}/change-password")]
    public async Task<IActionResult> ChangePassword(Guid userId, ChangePasswordRequest request)
    {
        var result = await _profileService.ChangePasswordAsync(userId, request);
        return this.FromResult(result);
    }
}