using Microsoft.AspNetCore.Mvc;

namespace Lab3.Controllers
{
    public class ExamplesController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public string Concatenare(string? str1, string? str2)
        {
            return str1 +" "+ str2;
        }
    }
}
