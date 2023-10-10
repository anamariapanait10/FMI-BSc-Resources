using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Model_Examen.Models;

namespace Model_Examen.Controllers
{
    public class GiftCardsController : Controller
    {
        private readonly AppDBContext db = new AppDBContext();


        public IActionResult Index()
        {
            var cards = db.GiftCards.Include("Brand");
            ViewBag.Cards = cards;

            if (TempData.ContainsKey("message"))
            {
                ViewBag.Message = TempData["message"];
            }

            return View();
        }

 
        public IActionResult Show(int id)
        {
            GiftCard card = db.GiftCards.Include("Brand")
                               .Where(c => c.Id == id)
                               .First();

            return View(card);
        }

        public IActionResult New()
        {
            GiftCard card = new GiftCard();

            card.Brands = GetAllBrands();

            return View(card);
        }

        [HttpPost]
        public IActionResult New(GiftCard card)
        {

            if (ModelState.IsValid)
            {   
                if(card.DataExp < DateTime.Now)
                {
                    TempData["message"] = "Data de expirare nu poate fi mai veche decat ziua curenta";
                    ViewBag.message = TempData["message"].ToString();
                    card.Brands = GetAllBrands();
                    return View(card);
                } else {
                    db.GiftCards.Add(card);
                    db.SaveChanges();
                    TempData["message"] = "Cardul a fost adaugat cu succes";
                    return RedirectToAction("Index");
                }
               
            }
            else
            {
                ViewBag.message = null;
                card.Brands = GetAllBrands();
                return View(card);
            }

        }

  
        public IActionResult Edit(int id)
        {

            GiftCard card = db.GiftCards.Include("Brand")
                                        .Where(c => c.Id == id)
                                        .First();

            card.Brands = GetAllBrands();

            return View(card);

        }

      
        [HttpPost]
        public IActionResult Edit(int id, GiftCard requestGiftCard)
        {
            GiftCard card = db.GiftCards.Find(id);
            requestGiftCard.Brands = GetAllBrands();

            if (ModelState.IsValid)
            {
                if (requestGiftCard.DataExp < DateTime.Now)
                {
                    TempData["message"] = "Data de expirare nu poate fi mai veche decat ziua curenta";
                    ViewBag.message = TempData["message"].ToString();
                    card.Brands = GetAllBrands();
                    return View(card);
                }
                else
                {
                    card.Denumire = requestGiftCard.Denumire;
                    card.Descriere = requestGiftCard.Descriere;
                    card.Denumire = requestGiftCard.Denumire;
                    card.DataExp = requestGiftCard.DataExp;
                    card.Procent = requestGiftCard.Procent;
                    card.BrandId = requestGiftCard.BrandId;
                    TempData["message"] = "Cardul a fost modificat";
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }
            else
            {
                ViewBag.message = null;
                return View(requestGiftCard);
            }
        }


        [HttpPost]
        public ActionResult Delete(int id)
        {
            GiftCard card = db.GiftCards.Find(id);
            db.GiftCards.Remove(card);
            db.SaveChanges();
            TempData["message"] = "Cardul a fost sters";
            return RedirectToAction("Index");
        }

        public IActionResult Search()
        {
            /* Nr 1
            var cards = db.GiftCards.Include("Brand").OrderByDescending(a => a.DataExp).Where(c => c.DataExp > DateTime.Now && c.DataExp <= DateTime.Now.AddDays(5) && c.Procent >= 30);

            var search = "";

            if (Convert.ToString(HttpContext.Request.Query["search"]) != null)
            {
                search = Convert.ToString(HttpContext.Request.Query["search"]).Trim();

                List<int> cardIds = db.GiftCards.Where
                                        (
                                         c => c.Denumire.Contains(search)
                                        ).Select(c => c.Id).ToList();

                cards = db.GiftCards.Where(card => cardIds.Contains(card.Id))
                                      .Include("Brand")
                                      .OrderByDescending(a => a.DataExp).Where(c => c.DataExp > DateTime.Now && c.DataExp <= DateTime.Now.AddDays(5) && c.Procent >= 30);

            }

            ViewBag.SearchString = search;
            ViewBag.Cards = cards;

            if (TempData.ContainsKey("message"))
            {
                ViewBag.message = TempData["message"].ToString();
            }


            return View();
            */
            var cards = db.GiftCards.Include("Brand");

            var search = "";

            if (Convert.ToString(HttpContext.Request.Query["search"]) != null)
            {
                search = Convert.ToString(HttpContext.Request.Query["search"]).Trim();

                List<int> cardIds = db.GiftCards.Where
                                        (
                                         c => c.Procent.ToString().Contains(search)
                                        ).Select(c => c.Id).ToList();

                List<int> brandIds = db.Brands.Where
                                    (
                                        b => b.Nume.Contains(search)
                                    ).Select(b => b.Id).ToList();

                List<int> mergedIds = cardIds.Union(brandIds).ToList();

                cards = db.GiftCards.Where(card => mergedIds.Contains(card.Id))
                                      .Include("Brand");

            }

            ViewBag.SearchString = search;
            ViewBag.Cards = cards;

            if (TempData.ContainsKey("message"))
            {
                ViewBag.message = TempData["message"].ToString();
            }


            return View();
        }

        [NonAction]
        public IEnumerable<SelectListItem> GetAllBrands()
        { 
            var selectList = new List<SelectListItem>();

            var brands = from b in db.Brands
                             select b;

            foreach (var brand in brands)
            { 
                selectList.Add(new SelectListItem
                {
                    Value = brand.Id.ToString(),
                    Text = brand.Nume
                });
            }

            return selectList;
        }
    }
}
