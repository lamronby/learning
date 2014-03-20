package com.lamronby.oo.tinyweb.stepone
import com.lamronby.oo.tinyweb.RenderingException

trait View {
	def render(model: Map[String, List[String]]): String
}

// viewRenderer is a function parameter with a Map argument and a String return
class FunctionView(viewRenderer: (Map[String, List[String]]) => String) extends View {
		def render(model: Map[String, List[String]]) =
		  try
		    viewRenderer(model)
		  catch {
		  	case e: Exception => throw new RenderingException(e)
		  	// Could return a default value by doing this:
		  	// case e: Exception => ""
		  }
	}
}