using System.Reflection;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Routing;
using Autofac;
using Autofac.Integration.Mvc;
using EssentialTools.Controllers;
using EssentialTools.Infrastructure;
using EssentialTools.Models;
using Ninject.Web.Mvc;

namespace EssentialTools
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            
            // Autofac
            var builder = new ContainerBuilder();
            builder.RegisterType<LinqValueCalculator>().As<IValueCalculator>().InstancePerLifetimeScope();
            builder.RegisterControllers(Assembly.GetExecutingAssembly());

            var container = builder.Build();
            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));

            ControllerBuilder.Current.SetControllerFactory(new AutofacControllerFactory(container));

            // Ninject
            // DependencyResolver.SetResolver(new NinjectDependencyResolver());

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
        }
    }
}