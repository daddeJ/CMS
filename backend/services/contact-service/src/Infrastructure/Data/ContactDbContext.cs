using Microsoft.EntityFrameworkCore;
using ContactService.Domain.Entities;

namespace ContactService.Infrastructure.Data;

public class ContactDbContext : DbContext
{
    public ContactDbContext(DbContextOptions<ContactDbContext> options) : base(options)
    {
    }

    public DbSet<Contact> Contacts { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Contact>(entity =>
        {
            entity.HasKey(e => e.Id);

            entity.Property(e => e.ContactId)
                  .IsRequired()
                  .ValueGeneratedOnAdd();

            entity.Property(e => e.UserId)
                  .IsRequired();

            entity.Property(e => e.Name)
                  .IsRequired()
                  .HasMaxLength(100);

            entity.Property(e => e.Email)
                  .IsRequired()
                  .HasMaxLength(100);

            entity.Property(e => e.PhoneNumber)
                  .HasMaxLength(20);

            entity.Property(e => e.ProfilePicture)
                  .HasMaxLength(255);

            entity.Property(e => e.DateCreated)
                  .IsRequired();

            entity.Property(e => e.DateUpdated);

            entity.HasIndex(e => new { e.UserId, e.Email }).IsUnique();
        });
    }
}
