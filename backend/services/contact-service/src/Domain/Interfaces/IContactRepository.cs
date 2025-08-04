using ContactService.Domain.Entities;
using Shared.Common;

namespace ContactService.Domain.Interfaces;

public interface IContactRepository
{
    Task<PageResult<Contact>> GetAllAsync(Guid userId, PageQuery query);
    Task<Contact?> GetByIdAsync(int id, Guid userId);
    Task<Contact?> GetByContactIdAsync(Guid contactId, Guid userId);
    Task<Contact> CreateAsync(Contact contact);
    Task<Contact> UpdateAsync(Contact contact);
    Task<bool> DeleteAsync(int id, Guid userId);
    Task<bool> ExistsAsync(int id, Guid userId);
    Task<bool> EmailExistsAsync(string email, Guid userId, int? excludeId = null);
    Task<IEnumerable<Contact>> SearchAsync(Guid userId, string searchTerm, int limit = 10);
}