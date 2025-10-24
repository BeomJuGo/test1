package com.health;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

/**
 * HealthWeb Spring Boot Application
 * 
 * @SpringBootApplication: Spring Boot 자동 설정, 컴포넌트 스캔, 설정 클래스 활성화
 * @MapperScan: MyBatis 매퍼 인터페이스 스캔
 * @EnableConfigurationProperties: 설정 프로퍼티 클래스 활성화
 */
@SpringBootApplication
@MapperScan("com.health.dao")
@EnableConfigurationProperties
public class HealthWebApplication {

  public static void main(String[] args) {
    SpringApplication.run(HealthWebApplication.class, args);
  }
}
