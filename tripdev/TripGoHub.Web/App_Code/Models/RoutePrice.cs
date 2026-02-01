using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("trf_route_price")]
    public class RoutePrice
    {
        [Key]
        public int RoutePriceId { get; set; }

        public int RouteId { get; set; }
        public int VehicleTypeId { get; set; }

        public decimal PriceOneWay { get; set; }
        public decimal PriceRoundTrip { get; set; }

        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }
    }
}
