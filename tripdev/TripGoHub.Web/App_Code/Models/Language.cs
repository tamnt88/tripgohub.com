using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("tgh_language")]
    public class Language
    {
        [Key]
        public int LangId { get; set; }

        [Required]
        [StringLength(10)]
        public string LangCode { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }

        [StringLength(100)]
        public string NativeName { get; set; }

        [StringLength(300)]
        public string FlagUrl { get; set; }

        public bool IsDefault { get; set; }

        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }
    }
}
