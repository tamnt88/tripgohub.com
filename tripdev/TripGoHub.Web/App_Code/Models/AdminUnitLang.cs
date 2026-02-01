using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("tgh_admin_unit_lang")]
    public class AdminUnitLang
    {
        [Key]
        [Column("AdminUnitLangId")]
        public int Id { get; set; }

        public int AdminUnitId { get; set; }

        [Required]
        [StringLength(10)]
        public string Lang { get; set; }

        [Required]
        [StringLength(200)]
        public string Name { get; set; }

        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }
    }
}
