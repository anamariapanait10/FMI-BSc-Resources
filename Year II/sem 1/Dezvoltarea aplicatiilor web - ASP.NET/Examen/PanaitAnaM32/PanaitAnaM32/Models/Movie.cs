using System.ComponentModel.DataAnnotations;

namespace PanaitAnaM32.Models
{
    public class Movie
    {
        [Key]
        public int Id { set; get; }

        [Required(ErrorMessage = "Denumirea filmului este obligatorie")]
        public string? DenFilm { get; set; }
        public virtual ICollection<Ticket>? Tickets { get; set; }

    }
}
