package com.example.webclient;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class WebClientApplication {

	public static void main(String[] args) throws InterruptedException {
		SpringApplication application = new SpringApplication(WebClientApplication.class);
		application.setWebApplicationType(WebApplicationType.NONE);
		application.run(args);
		Thread.currentThread().join(); // To be able to measure memory consumption
	}

}
