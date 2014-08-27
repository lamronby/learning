using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Autofac;
using Autofac.Integration.Mvc;

namespace EssentialTools.Infrastructure
{
    public class AutofacControllerFactory : DefaultControllerFactory
    {
        private readonly IContainer _container;

        public AutofacControllerFactory(IContainer container)
        {
            _container = container;
        }

        protected override IController GetControllerInstance(RequestContext requestContext, Type controllerType)
        {
            return (controllerType == null) ? null : (IController) _container.Resolve(controllerType);
        }
    }
}