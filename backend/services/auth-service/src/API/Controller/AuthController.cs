using AuthService.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;
using Shared.Contracts.Auth;
using Shared.Common;

namespace AuthService.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("login")]
    public async Task<ActionResult<LoginResponse>> Login([FromBody] LoginRequest request)
    {
        var result = await _authService.LoginAsync(request);
        
        return result.Match<ActionResult<LoginResponse>>(
            success => Ok(success),
            error => error.Type switch
            {
                ErrorType.NotFound => NotFound(error),
                ErrorType.Validation => BadRequest(error),
                ErrorType.Unauthorized => Unauthorized(error),
                _ => BadRequest(error)
            }
        );
    }

    [HttpPost("register")]
    public async Task<ActionResult<LoginResponse>> Register([FromBody] RegisterRequest request)
    {
        var result = await _authService.RegisterAsync(request);
        
        return result.Match<ActionResult<LoginResponse>>(
            success => Ok(success),
            error => error.Type switch
            {
                ErrorType.Conflict => Conflict(error),
                ErrorType.Validation => BadRequest(error),
                _ => BadRequest(error)
            }
        );
    }

    [HttpPost("refresh")]
    public async Task<ActionResult<LoginResponse>> RefreshToken([FromBody] RefreshTokenRequest request)
    {
        var result = await _authService.RefreshTokenAsync(request);
        
        return result.Match<ActionResult<LoginResponse>>(
            success => Ok(success),
            error => error.Type switch
            {
                ErrorType.Unauthorized => Unauthorized(error),
                _ => BadRequest(error)
            }
        );
    }

    [HttpPost("revoke-token")]
    public async Task<IActionResult> RevokeToken([FromBody] Guid userId)
    {
        var result = await _authService.RevokeTokenAsync(userId);

        return result.Match<IActionResult>(
            () => Ok(),
            error => error.Type switch
            {
                ErrorType.NotFound => NotFound(error),
                ErrorType.Unauthorized => Unauthorized(error),
                _ => BadRequest(error)
            }
        );
    }
}