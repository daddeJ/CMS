using AuthService.Application.Interfaces;
using AuthService.Domain.Interfaces;
using AutoMapper;
using Shared.Common;
using Shared.Contracts.Auth;
using AuthService.Domain.Entities;
using Microsoft.AspNetCore.Identity;

namespace AuthService.Application.Services;

public class UserProfileService : IUserProfileService
{
    private readonly IUserRepository _userRepository;
    private readonly IPasswordHasher<User> _passwordHasher;
    private readonly IMapper _mapper;

    public UserProfileService(
        IUserRepository userRepository,
        IPasswordHasher<User> passwordHasher,
        IMapper mapper
    )
    {
        _userRepository = userRepository;
        _passwordHasher = passwordHasher;
        _mapper = mapper;
    }

    public async Task<Result<UserDto>> GetProfileAsync(Guid userId)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
            return Error.NotFound("Profile.NotFound", "User not found");

        return _mapper.Map<UserDto>(user);
    }

    public async Task<Result<UserDto>> UpdateProfileAsync(Guid userId, UpdateProfileRequest request)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
            return Error.NotFound("Profile.NotFound", "User not found");

        user.FirstName = request.FirstName;
        user.LastName = request.LastName;

        await _userRepository.UpdateAsync(user);

        return _mapper.Map<UserDto>(user);
    }

    public async Task<Result> ChangePasswordAsync(Guid userId, ChangePasswordRequest request)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
            return Error.NotFound("Profile.NotFound", "User not found");

        var result = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, request.CurrentPassword);
        if (result == PasswordVerificationResult.Failed)
            return Error.Unauthorized("Profile.InvalidPassword", "Current password is incorrect");

        user.PasswordHash = _passwordHasher.HashPassword(user, request.NewPassword);
        await _userRepository.UpdateAsync(user);

        return Result.Success();
    }
}
