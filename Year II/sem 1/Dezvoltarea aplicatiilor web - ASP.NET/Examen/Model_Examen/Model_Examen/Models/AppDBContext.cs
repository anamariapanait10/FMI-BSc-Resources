using Microsoft.EntityFrameworkCore;

namespace Model_Examen.Models
{
    public class AppDBContext: DbContext
    {
        public AppDBContext() : base()
        {
        }
        protected override void OnConfiguring(DbContextOptionsBuilder options)
        {
            options.UseSqlServer(
            @"Data Source=(localdb)\mssqllocaldb;Initial Catalog=aspnet-53bc9b9d-9d6a-45d4-8429-2a2761773502;Integrated Security=True;MultipleActiveResultSets=True");
            
        }
        public DbSet<GiftCard> GiftCards { get; set; }

        public DbSet<Brand> Brands { get; set; }
    }
}
