using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("tgh_admin_unit")]
    public class AdminUnit
    {
        [Key]
        [Column("AdminUnitId")]
        public int Id { get; set; }

        public int CountryId { get; set; }
        public int? ParentId { get; set; }

        [Required]
        [StringLength(30)]
        public string LevelType { get; set; }

        [StringLength(50)]
        public string Code { get; set; }

        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }
    }
}
