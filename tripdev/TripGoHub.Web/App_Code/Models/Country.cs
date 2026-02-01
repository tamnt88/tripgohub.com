using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("tgh_country")]
    public class Country
    {
        [Key]
        [Column("CountryId")]
        public int Id { get; set; }

        [Required]
        [StringLength(2)]
        public string Iso2 { get; set; }

        [StringLength(3)]
        public string Iso3 { get; set; }

        [StringLength(10)]
        public string PhoneCode { get; set; }

        public bool IsDefault { get; set; }
        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }
    }
}
