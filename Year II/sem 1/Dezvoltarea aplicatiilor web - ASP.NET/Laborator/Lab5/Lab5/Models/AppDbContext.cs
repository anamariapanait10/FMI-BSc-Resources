using Microsoft.EntityFrameworkCore;

namespace Lab5.Models
{
    public class AppDBContext : DbContext
    {
        public AppDBContext() : base()
        {
        }
        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            options.UseSqlServer(
            @"Data Source=(localdb)\mssqllocaldb;Initial Catalog=ArticleDB;Integrated Security=True;MultipleActiveResultSets=True");
        }
        public DbSet<Article> Articles { get; set; }

        public DbSet<Category> Categories { get; set; }
    }
}
