using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ContactService.Application.Interfaces;
using Shared.Common;
using Shared.Contracts.Contact;
using ContactService.API.Extensions;
using System.Security.Claims;

namespace ContactService.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ContactsController : ControllerBase
{
    private readonly IContactService _contactService;

    public ContactsController(IContactService contactService)
    {
        _contactService = contactService;
    }

    [HttpGet]
    public async Task<IActionResult> GetContacts([FromQuery] PageQuery query)
    {
        var userId = GetUserId();
        if (userId is null)
            return Unauthorized("Invalid user token.");

        var result = await _contactService.GetContactsAsync(userId.Value, query);

        return result.Match<IActionResult>(
            pageResult =>
            {
                var response = new ContactListResponse(
                    Contacts: pageResult.Items,
                    TotalCount: pageResult.TotalCount,
                    Page: pageResult.Page,
                    PageSize: pageResult.PageSize
                );
                return Ok(response);
            },
            error => this.FromResult(Result.Failure(error))
        );
    }

    [HttpGet("{contactId:guid}")]
    public async Task<IActionResult> GetContactById(Guid contactId)
    {
        var userId = GetUserId();
        if (userId is null)
            return Unauthorized("Invalid user token.");

        var result = await _contactService.GetContactByIdAsync(contactId, userId.Value);

        return result.Match<IActionResult>(
            contact =>
            {
                var response = new ContactListResponse(
                    Contacts: new[] { contact },
                    TotalCount: 1,
                    Page: 1,
                    PageSize: 1
                );
                return Ok(response);
            },
            error => this.FromResult(Result<ContactDto>.Failure(error))
        );
    }

    [HttpPost]
    public async Task<IActionResult> CreateContact([FromBody] CreateContactRequest request)
    {
        var userId = GetUserId();
        if (userId is null)
            return Unauthorized("Invalid user token.");

        var result = await _contactService.CreateContactAsync(request, userId.Value);

        return result.Match<IActionResult>(
            contact =>
            {
                var response = new ContactListResponse(
                    Contacts: new[] { contact },
                    TotalCount: 1,
                    Page: 1,
                    PageSize: 1
                );
                return CreatedAtAction(nameof(GetContactById), new { contactId = contact.ContactId }, response);
            },
            error => this.FromResult(Result<ContactDto>.Failure(error))
        );
    }

    [HttpPut("{contactId:guid}")]
    public async Task<IActionResult> UpdateContact(Guid contactId, [FromBody] UpdateContactRequest request)
    {
        var userId = GetUserId();
        if (userId is null)
            return Unauthorized("Invalid user token.");

        var result = await _contactService.UpdateContactAsync(contactId, request, userId.Value);

        return result.Match<IActionResult>(
            contact =>
            {
                var response = new ContactListResponse(
                    Contacts: new[] { contact },
                    TotalCount: 1,
                    Page: 1,
                    PageSize: 1
                );
                return Ok(response);
            },
            error => this.FromResult(Result<ContactDto>.Failure(error))
        );
    }

    [HttpDelete("{contactId:guid}")]
    public async Task<IActionResult> DeleteContact(Guid contactId)
    {
        var userId = GetUserId();
        if (userId is null)
            return Unauthorized("Invalid user token.");

        var result = await _contactService.DeleteContactAsync(contactId, userId.Value);
        return this.FromResult(result);
    }

    private Guid? GetUserId()
    {
        var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        return Guid.TryParse(userIdClaim, out var userId) ? userId : null;
    }
}
