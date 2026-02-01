using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("pub_menu_lang")]
    public class PublicMenuLang
    {
        [Key]
        public int MenuLangId { get; set; }

        public int MenuId { get; set; }

        [Required]
        [StringLength(10)]
        public string Lang { get; set; }

        [Required]
        [StringLength(150)]
        public string Title { get; set; }

        [StringLength(300)]
        public string Url { get; set; }

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
