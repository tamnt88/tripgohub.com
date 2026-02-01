using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("trf_vehicle_brand_lang")]
    public class VehicleBrandLang
    {
        [Key]
        public int BrandLangId { get; set; }

        public int BrandId { get; set; }

        [Required]
        [StringLength(10)]
        public string Lang { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        public string Summary { get; set; }

        [StringLength(200)]
        public string SeoTitle { get; set; }

        public string SeoDescription { get; set; }

        [StringLength(500)]
        public string SeoKeywords { get; set; }

        public int? SlugId { get; set; }

        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }
    }
}
