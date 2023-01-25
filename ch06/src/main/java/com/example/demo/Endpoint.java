package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;

import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;


@RestController
public class Endpoint {
	@GetMapping(path ={"/greeting"} ) 
	public String demo() {
		List<String> streamSample= new ArrayList<>();
		streamSample.add("alpha");
		streamSample.add("beta");
		streamSample.parallelStream().forEach( unit -> {
			System.out.println(unit);
		});
		IntStream.iterate(1, n -> n + 1)
				.skip(50)
				.limit(50)
				.filter(PrimeMain::isPrime)
				.forEach(System.out::println);
		return "test";
	}
}
