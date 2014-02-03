package com.lamronby.oo.tinyweb;

import java.util.List;
import java.util.Map;

public class TinyWeb {
	private Map<String, Controller> controllers;
	private List<Filter> filters;

	public TinyWeb(Map<String, Controller> controllers, List<Filter> filters) {
		this.controllers = controllers;
		this.filters = filters;
	}

	public HttpResponse handleRequest(HttpRequest request) {

		HttpRequest currentRequest = request;
		for (Filter filter : filters) {
			currentRequest = filter.doFilter(request);
		}

		Controller controller = controllers.get(request.getPath());

		if (null == controller)
			return null;

		return controller.handleRequest(request);
	}
}
