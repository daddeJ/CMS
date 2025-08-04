using Shared.Common;
using Shared.Contracts.Auth;

namespace AuthService.Application.Interfaces;

public interface IUserProfileService
{
    Task<Result<UserDto>> GetProfileAsync(Guid userId);
    Task<Result<UserDto>> UpdateProfileAsync(Guid userId, UpdateProfileRequest request);
    Task<Result> ChangePasswordAsync(Guid userId, ChangePasswordRequest request);
}
