using AutoMapper;
using ContactService.Domain.Entities;
using Shared.Contracts.Contact;

namespace ContactService.Application.Profiles;

public class ContactProfile : Profile
{
    public ContactProfile()
    {
        CreateMap<Contact, ContactDto>();
        CreateMap<CreateContactRequest, Contact>();
        CreateMap<UpdateContactRequest, Contact>();
    }
}
