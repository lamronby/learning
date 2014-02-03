package com.lamronby.oo.tinyweb.example;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import com.lamronby.oo.tinyweb.HttpRequest;
import com.lamronby.oo.tinyweb.TemplateController;
import com.lamronby.oo.tinyweb.View;

public class GreetingController extends TemplateController {
	private Random random;

	public GreetingController(View view) {
		super(view);
		random = new Random();
	}

	@Override
	public Map<String, List<String>> doRequest(HttpRequest request) {
		Map<String, List<String>> helloModel = new HashMap<String, List<String>>();

		helloModel.put("greetings", generateGreetings(request.getBody()));
		return helloModel;
	}

	private List<String> generateGreetings(String namesCommaSeparated) {
		String[] names = namesCommaSeparated.split(",");
		List<String> greetings = new ArrayList<String>();

		for (String name : names) {
			greetings.add(makeGreeting(name));
		}
		return greetings;
	}

	private String makeGreeting(String name) {
		String[] greetings = { "Hello", "Greetings", "Salutations", "Hola", "Aloha", "Ciao" };
		String greetingPrefix = greetings[random.nextInt(6)];
		return String.format("%s, %s", greetingPrefix, name);
	}
	
}