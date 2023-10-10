using Lab6.Models;
using Microsoft.AspNetCore.Mvc;

namespace Lab6.Controllers
{
    public class ArticlesController : Controller
    {   
        private AppDbContext db = new AppDbContext();
        public IActionResult Index()
        {
            var articles = from article in db.Articles
                           select article;
            ViewBag.Articole = articles;
            return View();
        }
    }
}
