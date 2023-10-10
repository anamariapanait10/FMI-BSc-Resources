using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;


namespace Model_Examen.Models
{
    public class GiftCard
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Denumirea este obligatorie")]
        [StringLength(100, ErrorMessage = "Denumirea nu poate avea mai mult de 100 de caractere")]
        [MinLength(5, ErrorMessage = "Denumirea trebuie sa aiba mai mult de 5 caractere")]
        public string Denumire { get; set; }

        [Required(ErrorMessage = "Descrierea cardului este obligatorie")]
        public string Descriere { get; set; }
        [Required(ErrorMessage = "Data de expirare a cardului este obligatorie")]
        public DateTime? DataExp { get; set; }
        [Required(ErrorMessage = "Procentul cardului este obigatoriu")]
        [Range(1, 100, ErrorMessage = "Procentul cardului trebuie sa fie un numar intre 1 si 100")]
        public int Procent { get; set; }
        [Required(ErrorMessage = "Brandul este obligatoriu")]
        public int? BrandId { get; set; }
        public virtual Brand? Brand { get; set; }

        [NotMapped]
        public IEnumerable<SelectListItem>? Brands { get; set; }

    }
}
