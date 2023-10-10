using Lab4.Models;
using Microsoft.AspNetCore.Mvc;

namespace Lab4.Controllers
{
    public class ArticlesController : Controller
    {
        [NonAction] // nu o sa mai fie accesata prin root
        public Article[] GetArticles()
        {
            // Se instantiaza un array de articole
            Article[] articles = new Article[3];
            // Se creeaza articolele
            for (int i = 0; i < 3; i++)
            {
                Article article = new Article();
                article.Id = i;
                article.Title = "Articol " + (i + 1).ToString();
                article.Content = "Continut articol " + (i + 1).ToString();
                article.Date = DateTime.Now;
                // Se adauga articolul in array
                articles[i] = article;
            }
            return articles;
        }

        //avem HttpGet implicit
        public IActionResult Index()
        {   // afisam toate articolele
            Article[] articole = GetArticles();

            ViewBag.Art = articole;
            return View();
        }

        public IActionResult Show(int? id)
        {
            Article[] articole = GetArticles();
            try
            {
                ViewBag.Article = articole[(int)id];
                return View();
            } catch(Exception e)
            {   
                ViewBag.Msg = e.Message;
                return View("Error");
            }

            
        }

        // afisarea formularului prin care se adauga noul articol in baza de date
        // HttpGet implicit
        public IActionResult New()
        {

            return View();
        }

        // vrem sa il adaugam in db sau sa il editam (insert/update)
        [HttpPost]
        public IActionResult New(Article art)
        {
            // cod adaugare in db

            return View("NewMethodPost");
        }

        // afisarea formularului care o sa contina datele unui articol existent in baza de date
        [HttpGet]
        public IActionResult Edit()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Edit(Article art)
        {
            return View();
        }
    }
}
