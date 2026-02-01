using System.Data.Entity;

namespace TripGoHub.Web
{
    public class TripGoHubDbContext : DbContext
    {
        public TripGoHubDbContext() : base("name=TripGoHubDB")
        {
        }

        public DbSet<Language> Languages { get; set; }
        public DbSet<Slug> Slugs { get; set; }
        public DbSet<SiteSetting> SiteSettings { get; set; }
        public DbSet<Country> Countries { get; set; }
        public DbSet<CountryLang> CountryLang { get; set; }
        public DbSet<AdminUnit> AdminUnits { get; set; }
        public DbSet<AdminUnitLang> AdminUnitLang { get; set; }

        public DbSet<AdminUser> AdminUsers { get; set; }
        public DbSet<AdminMenu> AdminMenus { get; set; }
        public DbSet<AdminMenuLang> AdminMenuLang { get; set; }

        public DbSet<PublicMenu> PublicMenus { get; set; }
        public DbSet<PublicMenuLang> PublicMenuLang { get; set; }

        public DbSet<Route> Routes { get; set; }
        public DbSet<RouteLang> RouteLang { get; set; }
        public DbSet<RoutePrice> RoutePrices { get; set; }
        public DbSet<VehicleType> VehicleTypes { get; set; }
        public DbSet<VehicleTypeLang> VehicleTypeLang { get; set; }
        public DbSet<VehicleBrand> VehicleBrands { get; set; }
        public DbSet<VehicleBrandLang> VehicleBrandLang { get; set; }
        public DbSet<VehicleModelLang> VehicleModelLang { get; set; }
        public DbSet<TransferBooking> TransferBookings { get; set; }
    }
}
