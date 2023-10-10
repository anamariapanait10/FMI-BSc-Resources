using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Model_Examen_2.Models
{
    public class Appointment
    {
        [Key]
        public int Id { get; set; }

        [Required(ErrorMessage ="Informatiile despre programare sunt obligatorii")]
        [MinLength(5, ErrorMessage ="Informatiile nu pot avea mai putin de 5 caractere")]
        public string? Info { get; set; }

        [Required(ErrorMessage ="Data programarii este obligatorie")]
        // [DataType(DataType.DateTime)]
        public DateTime? Data { get; set; }

        [Required(ErrorMessage ="Pretul programarii este obligatoriu")]
        //[Range(100, Int32.MaxValue, ErrorMessage = "Pretul nu poate fi mai mic decat 100")]
        public int? Pret { get; set; }

        [Required(ErrorMessage ="Numele medicului la care s-a facut programarea este obligatoriu")]
        public int? DoctorId { get; set; }
        public virtual Doctor? Doctor { get; set; }

        [NotMapped]
        public IEnumerable<SelectListItem>? Doctori { get; set;}


    }
}
