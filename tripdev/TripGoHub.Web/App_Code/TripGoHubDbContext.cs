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
        public DbSet<VehicleBrand> VehicleBrands { get; set; }
        public DbSet<Route> Routes { get; set; }
        public DbSet<RoutePrice> RoutePrices { get; set; }
        public DbSet<VehicleType> VehicleTypes { get; set; }
        public DbSet<TransferBooking> TransferBookings { get; set; }
    }
}
