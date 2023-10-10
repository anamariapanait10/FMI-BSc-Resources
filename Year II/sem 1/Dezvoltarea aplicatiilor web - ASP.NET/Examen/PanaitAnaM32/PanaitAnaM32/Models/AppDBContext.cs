using Microsoft.EntityFrameworkCore;

namespace PanaitAnaM32.Models
{
    public class AppDBContext : DbContext
    {
        public AppDBContext() : base()
        {
        }
        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            options.UseSqlServer(
            @"Data Source=(localdb)\mssqllocaldb;Initial Catalog=ExamenDb;Integrated Security=True;MultipleActiveResultSets=True");

        }
        public DbSet<Ticket> Tickets { get; set; }

        public DbSet<Movie> Movies { get; set; }
    }
}
