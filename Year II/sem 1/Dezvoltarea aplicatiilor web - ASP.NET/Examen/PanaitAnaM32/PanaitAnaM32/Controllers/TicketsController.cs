using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using PanaitAnaM32.Models;
using System.Net.Sockets;

namespace PanaitAnaM32.Controllers
{
    public class TicketsController : Controller
    {
        private readonly AppDBContext db = new AppDBContext();
        private static Ticket _tichet;

        public IActionResult Index()
        {
            var tickets = db.Tickets.Include("Movie");
            ViewBag.Tickets = tickets;

            if (TempData.ContainsKey("message"))
            {
                ViewBag.Message = TempData["message"];
            }

            return View();
        }

        public IActionResult afisareBilete()
        {
            return RedirectToRoute(new { controller = "Tickets", action = "Index" });
        }


        public IActionResult Show(int id)
        {
            Ticket ticket = db.Tickets.Include("Movie")
                               .Where(c => c.Id == id)
                               .First();

            return View(ticket);
        }

        public IActionResult New()
        {
            Ticket ticket = new Ticket();

            ticket.Movies = GetAllMovies();

            return View(ticket);
        }

        [HttpPost]
        public IActionResult New(Ticket ticket)
        {
            ticket.Movies = GetAllMovies();

            if (ModelState.IsValid)
            {
                if (ticket.Data < DateTime.Now)
                {
                    TempData["message"] = "Data biletului nu poate fi mai veche decat ziua curenta";
                    ViewBag.message = TempData["message"].ToString();
                    return View(ticket);
                }
                else if (ticket.Pret < 0)
                {
                    TempData["message"] = "Pretul biletului trebuie sa fie intreg si pozitiv";
                    ViewBag.message = TempData["message"].ToString();
                    return View(ticket);
                }
                else
                {
                    db.Tickets.Add(ticket);
                    db.SaveChanges();
                    TempData["message"] = "Biletul a fost adaugata cu succes";
                    return RedirectToAction("Index");
                }

            }
            else
            {
                ViewBag.message = null;
                return View(ticket);
            }

        }


        public IActionResult Edit(int id)
        {

            Ticket ticket = db.Tickets.Include("Movie")
                                        .Where(c => c.Id == id)
                                        .First();

            ticket.Movies = GetAllMovies();

            return View(ticket);

        }


        [HttpPost]
        public IActionResult Edit(int id, Ticket requestTicket)
        {
            Ticket ticket = db.Tickets.Find(id);
            requestTicket.Movies = GetAllMovies();

            if (ModelState.IsValid)
            {
                if (requestTicket.Data < DateTime.Now)
                {
                    TempData["message"] = "Data biletului nu poate fi mai veche decat ziua curenta";
                    ViewBag.message = TempData["message"].ToString();
                    return View(requestTicket);
                }
                else if (requestTicket.Pret <  0)
                {
                    TempData["message"] = "Pretul biletului trebuie sa fie intreg si pozitiv";
                    ViewBag.message = TempData["message"].ToString();

                    return View(requestTicket);
                }
                else
                {
                    ticket.TitluBilet = requestTicket.TitluBilet;
                    ticket.Data = requestTicket.Data;
                    ticket.Pret = requestTicket.Pret;
                    ticket.MovieId = requestTicket.MovieId;
                    TempData["message"] = "Biletul a fost modificat cu succes";
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }
            else
            {
                ViewBag.message = null;
                return View(requestTicket);
            }
        }


        [HttpPost]
        public ActionResult Delete(int id)
        {
            Ticket ticket = db.Tickets.Find(id);
            db.Tickets.Remove(ticket);
            db.SaveChanges();
            TempData["message"] = "Biletul a fost sters";
            return RedirectToAction("Index");
        }

        public IActionResult CautareBilete()
        {
            return View();
        }
       [HttpPost]
        public IActionResult CautareBilete([FromForm] Ticket ticket)
        {

            _tichet = ticket;
            return RedirectToAction("AfisareBileteDupaCautare");

        }

        public IActionResult AfisareBileteDupaCautare()
        {
            var tickets = db.Tickets.Include("Movie").Where(c => c.Data < _tichet.Data && c.Pret <= _tichet.Pret).OrderByDescending(a => a.Pret).ToList();
            ViewBag.Tickets = tickets;

            if (_tichet.Data == null && _tichet.Pret == null)
            {
                TempData["message"] = "Nu ati specificat data si pretul dupa care se doreste cautarea!";
                ViewBag.Message = TempData["message"];
            }
            else if (_tichet.Data == null)
            {
                TempData["message"] = "Nu ati specificat data dupa care se doreste cautarea!";
                ViewBag.Message = TempData["message"];
            }
            else if (_tichet.Pret == null)
            {
                TempData["message"] = "Nu ati specificat pretul dupa care se doreste cautarea!";
                ViewBag.Message = TempData["message"];
            }
            else if (tickets.Count == 0){
                TempData["message"] = "Nu exista bilete!";
                ViewBag.Message = TempData["message"];
            }
           

            return View();
        }


        [NonAction]
        public IEnumerable<SelectListItem> GetAllMovies()
        {
            var selectList = new List<SelectListItem>();

            var movies = from t in db.Movies
                          select t;

            foreach (var d in movies)
            {
                selectList.Add(new SelectListItem
                {
                    Value = d.Id.ToString(),
                    Text = d.DenFilm
                });
            }

            return selectList;
        }
    }
}
