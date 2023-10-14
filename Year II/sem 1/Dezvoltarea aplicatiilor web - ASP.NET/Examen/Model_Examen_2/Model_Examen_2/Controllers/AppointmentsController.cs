using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Model_Examen_2.Models;

namespace Model_Examen_2.Controllers
{
    public class AppointmentsController : Controller
    {
        private readonly AppDBContext db = new AppDBContext();


        public IActionResult Index()
        {
            var appointments = db.Appointments.Include("Doctor");
            ViewBag.Appointments = appointments;

            if (TempData.ContainsKey("message"))
            {
                ViewBag.Message = TempData["message"];
            }

            return View();
        }


        public IActionResult Show(int id)
        {
            Appointment appointment = db.Appointments.Include("Doctor")
                               .Where(c => c.Id == id)
                               .First();

            return View(appointment);
        }

        public IActionResult New()
        {
            Appointment appointment = new Appointment();

            appointment.Doctori = GetAllDoctors();

            return View(appointment);
        }

        [HttpPost]
        public IActionResult New(Appointment appointment)
        {
            appointment.Doctori = GetAllDoctors();

            if (ModelState.IsValid)
            {
                if (appointment.Data < DateTime.Now)
                {
                    TempData["message"] = "Data programarii nu poate fi mai veche decat ziua curenta";
                    ViewBag.message = TempData["message"].ToString();
                    return View(appointment);
                }
                else if(appointment.Pret < 100)
                {
                    TempData["message"] = "Pretul programarii nu poate fi mmic de 100";
                    ViewBag.message = TempData["message"].ToString();
                    return View(appointment);
                } 
                else
                {
                    db.Appointments.Add(appointment);
                    db.SaveChanges();
                    TempData["message"] = "Programarea a fost adaugata cu succes";
                    return RedirectToAction("Index");
                }

            }
            else
            {
                ViewBag.message = null;
                return View(appointment);
            }

        }


        public IActionResult Edit(int id)
        {

            Appointment appointment = db.Appointments.Include("Doctor")
                                        .Where(c => c.Id == id)
                                        .First();

            appointment.Doctori = GetAllDoctors();

            return View(appointment);

        }


        [HttpPost]
        public IActionResult Edit(int id, Appointment requestAppointment)
        {
            Appointment appointment = db.Appointments.Find(id);
            requestAppointment.Doctori = GetAllDoctors();

            if (ModelState.IsValid)
            {
                if (requestAppointment.Data < DateTime.Now)
                {
                    TempData["message"] = "Data programarii nu poate fi mai veche decat ziua curenta";
                    ViewBag.message = TempData["message"].ToString();
                    return View(requestAppointment);
                }
                else if (requestAppointment.Pret < 100)
                {
                    TempData["message"] = "Pretul programarii nu poate fi mic de 100";
                    ViewBag.message = TempData["message"].ToString();
 
                    return View(requestAppointment);
                }
                else
                {
                    appointment.Info = requestAppointment.Info;
                    appointment.Data = requestAppointment.Data;
                    appointment.Pret = requestAppointment.Pret;
                    appointment.DoctorId = requestAppointment.DoctorId;
                    TempData["message"] = "Programarea a fost modificat";
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
            }
            else
            {
                ViewBag.message = null;
                return View(requestAppointment);
            }
        }


        [HttpPost]
        public ActionResult Delete(int id)
        {
            Appointment appointment = db.Appointments.Find(id);
            db.Appointments.Remove(appointment);
            db.SaveChanges();
            TempData["message"] = "Programarea a fost anulata";
            return RedirectToRoute(new { controller = "Appointments", action = "Index" });
        }

        public IActionResult Dates()
        {
            var date = from d in db.Appointments.Distinct()
                       select d.Data;

            ViewBag.Date = date;

            return View();
        }

        public IActionResult AppsDate(String d)
        {
            var appointments = db.Appointments.Include("Doctor").Where(m => m.Data.ToString().Replace("/", "_") == d).OrderBy(m => m.Pret);
                        
            ViewBag.Appointments = appointments;

            return View();
        }

        /*
        public IActionResult Search()
        {
            /* Nr 1
            var appointments = db.Appointments.Include("Doctor").OrderByDescending(a => a.DataExp).Where(c => c.DataExp > DateTime.Now && c.DataExp <= DateTime.Now.AddDays(5) && c.Procent >= 30);

            var search = "";

            if (Convert.ToString(HttpContext.Request.Query["search"]) != null)
            {
                search = Convert.ToString(HttpContext.Request.Query["search"]).Trim();

                List<int> cardIds = db.Appointments.Where
                                        (
                                         c => c.Denumire.Contains(search)
                                        ).Select(c => c.Id).ToList();

                appointments = db.Appointments.Where(appointment => cardIds.Contains(appointment.Id))
                                      .Include("Doctor")
                                      .OrderByDescending(a => a.DataExp).Where(c => c.DataExp > DateTime.Now && c.DataExp <= DateTime.Now.AddDays(5) && c.Procent >= 30);

            }

            ViewBag.SearchString = search;
            ViewBag.Appointments = appointments;

            if (TempData.ContainsKey("message"))
            {
                ViewBag.message = TempData["message"].ToString();
            }


            return View();
            
            var appointments = db.Appointments.Include("Doctor");

            var search = "";

            if (Convert.ToString(HttpContext.Request.Query["search"]) != null)
            {
                search = Convert.ToString(HttpContext.Request.Query["search"]).Trim();

                List<int> cardIds = db.Appointments.Where
                                        (
                                         c => c.Procent.ToString().Contains(search)
                                        ).Select(c => c.Id).ToList();

                List<int> brandIds = db.Doctori.Where
                                    (
                                        b => b.Nume.Contains(search)
                                    ).Select(b => b.Id).ToList();

                List<int> mergedIds = cardIds.Union(brandIds).ToList();

                appointments = db.Appointments.Where(appointment => mergedIds.Contains(appointment.Id))
                                      .Include("Doctor");

            }

            ViewBag.SearchString = search;
            ViewBag.Appointments = appointments;

            if (TempData.ContainsKey("message"))
            {
                ViewBag.message = TempData["message"].ToString();
            }


            return View();
        }*/

        [NonAction]
        public IEnumerable<SelectListItem> GetAllDoctors()
        {
            var selectList = new List<SelectListItem>();

            var doctors = from b in db.Doctors
                         select b;

            foreach (var d in doctors)
            {
                selectList.Add(new SelectListItem
                {
                    Value = d.Id.ToString(),
                    Text = d.Nume
                });
            }

            return selectList;
        }
    }
}
