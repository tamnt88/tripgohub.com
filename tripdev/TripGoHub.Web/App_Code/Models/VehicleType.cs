using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("tgh_vehicle_type")]
    public class VehicleType
    {
        [Key]
        public int VehicleTypeId { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        public int Capacity { get; set; }

        [StringLength(500)]
        public string Description { get; set; }

        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }
    }
}
