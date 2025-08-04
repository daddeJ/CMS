using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AuthService.Application.Interfaces;
using AuthService.Domain.Entities;
using AuthService.Domain.Interfaces;
using AutoMapper;
using Microsoft.AspNetCore.Identity;
using Shared.Common;
using Shared.Contracts.Auth;

namespace AuthService.Application.Services;

public class AuthenticationService : IAuthService
{
    private readonly IUserRepository _userRepository;
    private readonly ITokenService _tokenService;
    private readonly IPasswordHasher<User> _passwordHasher;
    private readonly IMapper _mapper;
    public AuthenticationService(
        IUserRepository userRepository,
        ITokenService tokenService,
        IPasswordHasher<User> passwordHasher,
        IMapper mapper
    )
    {
        _userRepository = userRepository;
        _tokenService = tokenService;
        _passwordHasher = passwordHasher;
        _mapper = mapper;
    }
    public async Task<Result<LoginResponse>> LoginAsync(LoginRequest request)
    {
        var user = await _userRepository.GetByEmailAsync(request.Email);
        if (user == null)
        {
            return Error.NotFound("Auth.UserNotFound", "User not found");
        }

        var verificationResult = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, request.Password);
        if (verificationResult == PasswordVerificationResult.Failed)
        {
            return Error.Unauthorized("Auth.InvalidCredentials", "Invalid credentials");
        }

        var accessToken = _tokenService.GenerateAccessToken(user);
        var refreshToken = _tokenService.GenerateRefreshToken();

        user.RefreshToken = refreshToken;
        user.RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7);

        await _userRepository.UpdateAsync(user);

        var userDto = _mapper.Map<UserDto>(user);

        return new LoginResponse(
            accessToken,
            refreshToken,
            DateTime.UtcNow.AddHours(1),
            userDto
        );
    }

    public async Task<Result<LoginResponse>> RefreshTokenAsync(RefreshTokenRequest request)
    {
        if (!_tokenService.ValidateRefreshToken(request.RefreshToken))
        {
            return Error.Unauthorized("Auth.InvalidRefreshToken", "Invalid refresh token");
        }

        var user = await _userRepository.GetByRefreshTokenAsync(request.RefreshToken);
        if (user == null || user.RefreshTokenExpiryTime <= DateTime.UtcNow)
        {
            return Error.Unauthorized("Auth.ExpiredRefreshToken", "Refresh token expired");
        }

        var newAccessToken = _tokenService.GenerateAccessToken(user);
        var newRefreshToken = _tokenService.GenerateRefreshToken();

        user.RefreshToken = newRefreshToken;
        user.RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7);

        await _userRepository.UpdateAsync(user);

        var userDto = _mapper.Map<UserDto>(user);

        return new LoginResponse(
            newAccessToken,
            newRefreshToken,
            DateTime.UtcNow.AddHours(1),
            userDto
        );
    }

    public async Task<Result<LoginResponse>> RegisterAsync(RegisterRequest request)
    {
        if (await _userRepository.ExistsAsync(request.Email))
        {
            return Error.Conflict("Auth.EmailExists", "Email already exists");
        }

        var user = new User
        {
            Email = request.Email,
            FirstName = request.FirstName,
            LastName = request.LastName,
            DateCreated = DateTime.UtcNow
        };

        user.PasswordHash = _passwordHasher.HashPassword(user, request.Password);

        await _userRepository.CreateAsync(user);

        var accessToken = _tokenService.GenerateAccessToken(user);
        var refreshToken = _tokenService.GenerateRefreshToken();

        user.RefreshToken = refreshToken;
        user.RefreshTokenExpiryTime = DateTime.UtcNow.AddDays(7);

        await _userRepository.UpdateAsync(user);

        var userDto = _mapper.Map<UserDto>(user);

        return new LoginResponse(
            accessToken,
            refreshToken,
            DateTime.UtcNow.AddHours(1),
            userDto
        );
    }

    public async Task<Result> RevokeTokenAsync(Guid userId)
    {
        var user = await _userRepository.GetByIdAsync(userId);
        if (user == null)
        {
            return Error.NotFound("Auth.UserNotFound", "User not found");
        }

        user.RefreshToken = null;
        user.RefreshTokenExpiryTime = null;

        await _userRepository.UpdateAsync(user);

        return Result.Success();
    }
}