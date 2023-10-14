using ArticlesApp.Data;
using ArticlesApp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;

namespace ArticlesApp.Controllers
{
    public class ArticlesController : Controller
    {
        private readonly ApplicationDbContext db;
        public ArticlesController(ApplicationDbContext context)
        {
            db = context;
        }

        // Se afiseaza lista tuturor articolelor impreuna cu categoria 
        // din care fac parte
        // HttpGet implicit
        public IActionResult Index()
        {
            var articles = db.Articles.Include("Category");
            // ViewBag.OriceDenumireSugestiva
            ViewBag.Articles = articles;

            if (TempData.ContainsKey("message"))
            {
                ViewBag.Message = TempData["message"];
            }

            return View();
        }

        // Se afiseaza un singur articol in functie de id-ul sau 
        // impreuna cu categoria din care face parte
        // In plus sunt preluate si toate comentariile asociate unui articol
        // HttpGet implicit
        public IActionResult Show(int id)
        {
            Article article = db.Articles.Include("Category").Include("Comments")
                               .Where(art => art.Id == id)
                               .First();

            return View(article);
        }


        // Adaugarea unui comentariu asociat unui articol in baza de date
        [HttpPost]
        public IActionResult Show([FromForm] Comment comment)
        {
            comment.Date = DateTime.Now;

            if (ModelState.IsValid)
            {
                db.Comments.Add(comment);
                db.SaveChanges();
                return Redirect("/Articles/Show/" + comment.ArticleId);
            }

            else
            {
                Article art = db.Articles.Include("Category").Include("Comments")
                               .Where(art => art.Id == comment.ArticleId)
                               .First();

                //return Redirect("/Articles/Show/" + comm.ArticleId);

                return View(art);
            }
        }



        // Se afiseaza formularul in care se vor completa datele unui articol
        // impreuna cu selectarea categoriei din care face parte
        // HttpGet implicit

        public IActionResult New()
        {
            Article article = new Article();

            article.Categ = GetAllCategories();

            return View(article);
        }

        // Se adauga articolul in baza de date
        [HttpPost]
        public IActionResult New(Article article)
        {
            article.Date = DateTime.Now;
            article.Categ = GetAllCategories();

            if (ModelState.IsValid)
            {
                db.Articles.Add(article);
                db.SaveChanges();
                TempData["message"] = "Articolul a fost adaugat";
                return RedirectToAction("Index");
            }
            else
            {
                return View(article);
            }

            /*
             try
             {
                 db.Articles.Add(article);
                 db.SaveChanges();
                 TempData["message"] = "Articolul a fost adaugat";
                 return RedirectToAction("Index");
             }

             catch (Exception)
             {
                 return View(article);
             }
             */
        }

        // Se editeaza un articol existent in baza de date impreuna cu categoria din care face parte
        // Categoria se selecteaza dintr-un dropdown
        // HttpGet implicit
        // Se afiseaza formularul impreuna cu datele aferente articolului din baza de date
        public IActionResult Edit(int id)
        {
            
                Article article = db.Articles.Include("Category")
                                            .Where(art => art.Id == id)
                                            .First();

                article.Categ = GetAllCategories();

                return View(article);

        }

        // Se adauga articolul modificat in baza de date
        [HttpPost]
        public IActionResult Edit(int id, Article requestArticle)
        {
            Article article = db.Articles.Find(id);
            requestArticle.Categ = GetAllCategories();

            if(ModelState.IsValid)
            {     
                article.Title = requestArticle.Title;
                article.Content = requestArticle.Content;
                article.CategoryId = requestArticle.CategoryId;
                TempData["message"] = "Articolul a fost modificat";
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            else
            {
                return View(requestArticle);
            }
        }


        // Se sterge un articol din baza de date 
        [HttpPost]
        public ActionResult Delete(int id)
        {
            Article article = db.Articles.Find(id);
            db.Articles.Remove(article);
            db.SaveChanges();
            TempData["message"] = "Articolul a fost sters";
            return RedirectToAction("Index");
        }

        [NonAction]
        public IEnumerable<SelectListItem> GetAllCategories()
        {
            // generam o lista de tipul SelectListItem fara elemente
            var selectList = new List<SelectListItem>();

            // extragem toate categoriile din baza de date
            var categories = from cat in db.Categories
                             select cat;

            // iteram prin categorii
            foreach (var category in categories)
            {
                // adaugam in lista elementele necesare pentru dropdown
                // id-ul categoriei si denumirea acesteia
                selectList.Add(new SelectListItem
                {
                    Value = category.Id.ToString(),
                    Text = category.CategoryName.ToString()
                });
            }
                /* Sau se poate implementa astfel: 
                 * 
                foreach (var category in categories)
                {
                    var listItem = new SelectListItem();
                    listItem.Value = category.Id.ToString();
                    listItem.Text = category.CategoryName.ToString();

                    selectList.Add(listItem);
                 }*/
            

            // returnam lista de categorii
            return selectList;
        }

        public IActionResult IndexNou()
        {
            return View();
        }
    }
}

