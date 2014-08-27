using System.Web.Mvc;
using System.Web.UI.WebControls;
using EssentialTools.Models;
using Ninject;

namespace EssentialTools.Controllers
{
    public class HomeController : Controller
    {
        private readonly Product[] _products = { 
new Product {Name = "Kayak", Category = "Watersports", Price = 275M}, 
new Product {Name = "Lifejacket", Category = "Watersports", Price = 48.95M}, 
new Product {Name = "Soccer ball", Category = "Soccer", Price = 19.50M}, 
new Product {Name = "Corner flag", Category = "Soccer", Price = 34.95M} 
};

        private IValueCalculator _calc;

        public HomeController(IValueCalculator calc)
        {
            _calc = calc;
        }

        public ActionResult Index()
        {
            var cart = new ShoppingCart(_calc) { Products = _products };
            var totalValue = cart.CalculateProductTotal();
            return View(totalValue);
        }
    }
}
