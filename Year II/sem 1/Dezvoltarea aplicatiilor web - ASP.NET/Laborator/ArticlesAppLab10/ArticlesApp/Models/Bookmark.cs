using System.ComponentModel.DataAnnotations;
using System.Drawing;

namespace ArticlesApp.Models
{
    public class Bookmark
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Numele colectiei este obligatoriu")]
        public string Name { get; set; }
        public string? UserId { get; set; }
        public virtual ApplicationUser? User { get; set; }
        public virtual ICollection<ArticleBookmark>? ArticleBookmarks { get; set; }

    }
}
