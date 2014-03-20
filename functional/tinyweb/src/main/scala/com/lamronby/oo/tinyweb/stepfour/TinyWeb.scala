package com.lamronby.oo.tinyweb.stepfour

class TinyWeb(controllers: Map[String, Controller],
	filters: List[(HttpRequest) => HttpRequest]) {


	def handleRequest(request: HttpRequest): Option[HttpResponse] = {
		val composedFilter = filters.reverse.reduceLeft(
			(composed, next) => composed compose next)
		val filteredRequest = composedFilter(httpRequest)
		val controllerOption = controllers.get(filteredReuqest.path)
		controllerOption amp { controller => controller.handleRequest(filteredRequest) }
	}
}