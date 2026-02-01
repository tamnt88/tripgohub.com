using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("tgh_slug")]
    public class Slug
    {
        [Key]
        public int SlugId { get; set; }

        [Required]
        [StringLength(10)]
        public string Lang { get; set; }

        [Required]
        [StringLength(200)]
        [Column("Slug")]
        public string SlugText { get; set; }

        [Required]
        [StringLength(50)]
        public string EntityType { get; set; }

        public int EntityId { get; set; }

        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }
    }
}

