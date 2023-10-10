using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Model_Examen.Models
{
    public class Brand
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage = "Numele este obligatoriu")]
        [StringLength(100, ErrorMessage = "Numelel nu poate avea mai mult de 50 de caractere")]
        [MinLength(5, ErrorMessage = "Numele trebuie sa aiba mai mult de 5 caractere")]
        public string Nume { get; set; }


    }
}
