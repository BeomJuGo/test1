package com.health.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Spring Boot Home Controller
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	/**
	 * 메인 페이지
	 */
	@GetMapping("/")
	public String home(Model model) {
		logger.info("Welcome to HealthWeb!");

		LocalDateTime now = LocalDateTime.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월 dd일 HH:mm:ss");
		String formattedDate = now.format(formatter);

		model.addAttribute("serverTime", formattedDate);
		model.addAttribute("appName", "HealthWeb");

		return "index";
	}

	/**
	 * 메인 대시보드
	 */
	@GetMapping("/main")
	public String main() {
		return "main";
	}
}
