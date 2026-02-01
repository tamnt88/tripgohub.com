using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("trf_route")]
    public class Route
    {
        [Key]
        public int RouteId { get; set; }

        [Required]
        [StringLength(200)]
        public string FromName { get; set; }

        [Required]
        [StringLength(200)]
        public string ToName { get; set; }

        public decimal? DistanceKm { get; set; }
        public int? DurationMin { get; set; }

        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }
    }
}
