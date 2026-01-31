using System.Data.Entity;

namespace TripGoHub.Web
{
    public class TripGoHubDbContext : DbContext
    {
        public TripGoHubDbContext() : base("name=TripGoHubDB")
        {
        }

        public DbSet<Province> Provinces { get; set; }
        public DbSet<Ward> Wards { get; set; }
        public DbSet<AdminUser> AdminUsers { get; set; }
    }
}
