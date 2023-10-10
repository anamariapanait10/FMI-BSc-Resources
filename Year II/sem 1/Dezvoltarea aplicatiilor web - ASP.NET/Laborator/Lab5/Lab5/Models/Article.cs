using System.ComponentModel.DataAnnotations;

namespace Lab5.Models
{
    public class Article
    {
        [Key]
        public int ArticleID { get; set; }
        public string Title { get; set; }
        public string Content { get; set; }
        public DateTime Date { get; set; }
    }
}
