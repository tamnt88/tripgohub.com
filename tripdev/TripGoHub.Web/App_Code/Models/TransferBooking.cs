using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("trf_transfer_booking")]
    public class TransferBooking
    {
        [Key]
        public int BookingId { get; set; }

        [Required]
        [StringLength(30)]
        public string BookingCode { get; set; }

        [Required]
        [StringLength(200)]
        public string CustomerName { get; set; }

        [Required]
        [StringLength(30)]
        public string CustomerPhone { get; set; }

        [StringLength(200)]
        public string CustomerEmail { get; set; }

        public int RouteId { get; set; }
        public int VehicleTypeId { get; set; }
        public DateTime PickupTime { get; set; }
        public DateTime? ReturnTime { get; set; }
        public byte TripType { get; set; }
        public byte PaymentType { get; set; }
        public byte PaymentStatus { get; set; }
        public decimal TotalAmount { get; set; }

        public string Note { get; set; }

        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }

        [ForeignKey("RouteId")]
        public virtual Route Route { get; set; }

        [ForeignKey("VehicleTypeId")]
        public virtual VehicleType VehicleType { get; set; }
    }
}
