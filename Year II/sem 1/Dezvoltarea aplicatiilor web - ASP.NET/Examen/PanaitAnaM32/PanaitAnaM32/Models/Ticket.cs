using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace PanaitAnaM32.Models
{
    public class Ticket
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Titlul biletului este obligatoriu")]
        [StringLength(10, ErrorMessage = "Titlul biletului nu pot avea mai mult de 10 caractere" )]
        public string? TitluBilet { get; set; }


        [Required(ErrorMessage = "Pretul biletului este obligatoriu")]
        [Range(1, Int32.MaxValue, ErrorMessage = "Pretul biletului trebuie sa fie un numar intreg pozitiv")]
        public int? Pret { get; set; }

        [Required(ErrorMessage = "Data biletului este obligatorie")]
        public DateTime? Data { get; set; }

        [Required(ErrorMessage = "Numele filmului este obligatoriu")]
        public int? MovieId { get; set; }
        public virtual Movie? Movie { get; set; }

        [NotMapped]
        public IEnumerable<SelectListItem>? Movies { get; set; }

    }
}
