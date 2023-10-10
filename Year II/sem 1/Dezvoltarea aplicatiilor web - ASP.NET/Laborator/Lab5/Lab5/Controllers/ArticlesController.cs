using Lab5.Models;
using Microsoft.AspNetCore.Mvc;

namespace Lab5.Controllers
{
    public class ArticlesController : Controller
    {   
        private AppDBContext db = new AppDBContext();
        public IActionResult Index()
        {
            var art = from article in db.Articles
                      select article;
            ViewBag.Articles = art;
            return View();
        }
    }
}
