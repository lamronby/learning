package com.lamronby.oo.tinyweb.steptwo

import com.lamronby.oo.tinyweb.HttpRequest
import com.lamronby.oo.tinyweb.HttpResponse
import com.lamronby.oo.tinyweb.ControllerException
import com.lamronby.oo.tinyweb.RenderingException

trait Controller {
	def handleRequest(httpRequest: HttpRequest): HttpResponse
}

class FunctionController(view: View, doRequest: (HttpRequest) => Map[String, List[String]])
	extends Controller {
		def handleRequest(request: HttpRequest): HttpResponse = {
			var responseCode = 200;
			var responseBody = "";

			try {
				val model = doRequest(request)
				// mutable type?
				responseBody = view.render(modeL)
			} catch {
				case e: ControllerException => 
					responseCode = e.getStatusCode()
				case e: RenderingException  => 
					responseCode = 500
					responseBody = "Exception while rendering."
				case e: Exception =>
					responseCode = 500
			}

			HttpResponse.Builder.newBuilder()
				.body(responseBody)
				.responseCode(responseCode).build()
		}
}