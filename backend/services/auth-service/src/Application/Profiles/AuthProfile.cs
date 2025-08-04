using AutoMapper;
using AuthService.Domain.Entities;
using Shared.Contracts.Auth;

namespace AuthService.Application.Profiles;

public class AuthProfile : Profile
{
    public AuthProfile()
    {
        CreateMap<User, UserDto>();
    }
}