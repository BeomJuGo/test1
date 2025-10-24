package com.health;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * HealthWeb Spring Boot Application
 * 
 * @SpringBootApplication: Spring Boot 자동 설정, 컴포넌트 스캔, 설정 클래스 활성화
 */
@SpringBootApplication
public class HealthWebApplication {

  public static void main(String[] args) {
    SpringApplication.run(HealthWebApplication.class, args);
  }
}