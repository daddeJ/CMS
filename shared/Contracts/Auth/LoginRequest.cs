namespace Shared.Contracts.Auth;

public record LoginRequest(
    string Email,
    string Password
);

public record LoginResponse(
    string Token,
    string RefreshToken,
    DateTime ExpiresAt,
    UserDto User
);

public record UserDto(
    Guid Id,
    string Email,
    string FirstName,
    string LastName,
    DateTime DateCreated
);

public record RegisterRequest(
    string Email,
    string Password,
    string FirstName,
    string LastName
);

public record RefreshTokenRequest(
    string RefreshToken
);

public record ChangePasswordRequest(
    string CurrentPassword,
    string NewPassword
);

public record UpdateProfileRequest(
    string FirstName,
    string LastName
);