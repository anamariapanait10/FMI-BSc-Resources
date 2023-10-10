using Microsoft.EntityFrameworkCore;

namespace Lab6.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext() : base()
        {
        }
        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            options.UseSqlServer(
            @"Data Source=(localdb)\mssqllocaldb;Initial Catalog=Lab6DB;Integrated Security=True;MultipleActiveResultSets=True");
        }
        public DbSet<Article> Articles { get; set; }
    }
}
