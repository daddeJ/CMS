using Shared.Contracts.Auth;
using Shared.Common;

namespace AuthService.Application.Interfaces;

public interface IAuthService
{
    Task<Result<LoginResponse>> LoginAsync(LoginRequest request);
    Task<Result<LoginResponse>> RegisterAsync(RegisterRequest request);
    Task<Result<LoginResponse>> RefreshTokenAsync(RefreshTokenRequest request);
    Task<Result> RevokeTokenAsync(Guid userId);
}
