using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web.Mvc;
using System.Web.Routing;
using Autofac;
using Autofac.Integration.Mvc;
using Moq;
using SportsStore.Domain.Abstract;
using SportsStore.Domain.Concrete;
using SportsStore.Domain.Entities;

namespace SportsStore.WebUI.Infrastructure
{
    public class AutofacControllerFactory : DefaultControllerFactory
    {
        private readonly IContainer _container;

        public AutofacControllerFactory()
        {
            var builder = new ContainerBuilder();
            AddBindings(builder);
            _container = builder.Build();
        }

        protected override IController GetControllerInstance(RequestContext requestContext, Type controllerType)
        {
            return (controllerType == null) ? null : (IController) _container.Resolve(controllerType);
        }

        private void AddBindings(ContainerBuilder builder)
        {
            //var mock = new Mock<IProductRepository>();
            //mock.Setup(m => m.Products).Returns(new List<Product>
            //{
            //    new Product {Name = "Football", Price = 25},
            //    new Product {Name = "Surf board", Price = 179},
            //    new Product {Name = "Running shoes", Price = 95}
            //}.AsQueryable());

            //builder.RegisterInstance(mock.Object).As<IProductRepository>();
            builder.RegisterType<EFProductRepository>().As<IProductRepository>();

            // register controllers
            builder.RegisterControllers(Assembly.GetExecutingAssembly());
        }

    }
}