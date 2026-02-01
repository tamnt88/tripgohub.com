using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("adm_menu")]
    public class AdminMenu
    {
        [Key]
        public int MenuId { get; set; }

        public int? ParentId { get; set; }

        [Required]
        [StringLength(60)]
        public string Code { get; set; }

        [StringLength(100)]
        public string IconClass { get; set; }

        public bool IsGroup { get; set; }

        [StringLength(20)]
        public string Target { get; set; }

        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }
    }
}
