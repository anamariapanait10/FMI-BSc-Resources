using Microsoft.EntityFrameworkCore;

namespace Model_Examen_2.Models
{
    public class AppDBContext : DbContext
    {
        public AppDBContext() : base()
        {
        }
        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            options.UseSqlServer(
            @"Data Source=(localdb)\mssqllocaldb;Initial Catalog=aspnet-ModeExamen2;Integrated Security=True;MultipleActiveResultSets=True");

        }
        public DbSet<Appointment> Appointments { get; set; }

        public DbSet<Doctor> Doctors { get; set; }
    }
}
