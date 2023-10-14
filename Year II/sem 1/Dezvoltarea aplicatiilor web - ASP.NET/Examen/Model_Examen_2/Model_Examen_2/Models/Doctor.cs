using System.ComponentModel.DataAnnotations;

namespace Model_Examen_2.Models
{
    public class Doctor
    {
        [Key]
        public int Id { set; get; }

        [Required(ErrorMessage ="Numele medicului este obligatoriu")]
        public string? Nume { get; set; }
        public virtual ICollection<Appointment>? Appointments { get; set; }

    }
}
