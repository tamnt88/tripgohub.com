using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TripGoHub.Web
{
    [Table("tgh_Ward")]
    public class Ward
    {
        [Key]
        public int Id { get; set; }

        public int ProvinceId { get; set; }

        [Required]
        [StringLength(200)]
        public string Name { get; set; }

        public byte Status { get; set; }
        public int SortOrder { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string UpdatedBy { get; set; }

        [ForeignKey("ProvinceId")]
        public virtual Province Province { get; set; }
    }
}
