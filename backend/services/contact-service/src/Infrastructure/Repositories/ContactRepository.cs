using ContactService.Domain.Entities;
using ContactService.Domain.Interfaces;
using ContactService.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Shared.Common;

namespace ContactService.Infrastructure.Repositories;

public class ContactRepository : IContactRepository
{
    private readonly ContactDbContext _context;

    public ContactRepository(ContactDbContext context)
    {
        _context = context;
    }

    public async Task<PageResult<Contact>> GetAllAsync(Guid userId, PageQuery query)
    {
        var source = _context.Contacts
        .Where(c => c.UserId == userId);

        var totalCount = await source.CountAsync();

        var items = await source
            .Skip(query.Skip)
            .Take(query.Take)
            .ToListAsync();

        return PageResult<Contact>.Create(
            items,
            totalCount,
            query.Page,
            query.PageSize
        );
    }

    public async Task<Contact?> GetByIdAsync(int id, Guid userId)
    {
        return await _context.Contacts
            .FirstOrDefaultAsync(c => c.Id == id && c.UserId == userId);
    }

    public async Task<Contact?> GetByContactIdAsync(Guid contactId, Guid userId)
    {
        return await _context.Contacts
            .FirstOrDefaultAsync(c => c.ContactId == contactId && c.UserId == userId);
    }

    public async Task<Contact> CreateAsync(Contact contact)
    {
        _context.Contacts.Add(contact);
        await _context.SaveChangesAsync();
        return contact;
    }

    public async Task<Contact> UpdateAsync(Contact contact)
    {
        _context.Contacts.Update(contact);
        await _context.SaveChangesAsync();
        return contact;
    }

    public async Task<bool> DeleteAsync(int id, Guid userId)
    {
        var contact = await GetByIdAsync(id, userId);
        if (contact == null) return false;

        _context.Contacts.Remove(contact);
        return await _context.SaveChangesAsync() > 0;
    }

    public async Task<bool> ExistsAsync(int id, Guid userId)
    {
        return await _context.Contacts
            .AnyAsync(c => c.Id == id && c.UserId == userId);
    }

    public async Task<bool> EmailExistsAsync(string email, Guid userId, int? excludeId = null)
    {
        return await _context.Contacts
            .AnyAsync(c => c.UserId == userId &&
                           c.Email == email &&
                           (!excludeId.HasValue || c.Id != excludeId));
    }

    public async Task<IEnumerable<Contact>> SearchAsync(Guid userId, string searchTerm, int limit = 10)
    {
        return await _context.Contacts
            .Where(c => c.UserId == userId &&
                        (c.Name.Contains(searchTerm) || c.Email.Contains(searchTerm)))
            .OrderByDescending(c => c.DateCreated)
            .Take(limit)
            .ToListAsync();
    }
}
