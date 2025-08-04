using AuthService.Domain.Entities;

public interface ITokenService
{
    string GenerateAccessToken(User user);
    string GenerateRefreshToken();
    bool ValidateRefreshToken(string refreshToken);
    Guid? GetUserIdFromToken(string token);
}