package com.health.config;

import com.health.service.UserService;
import com.health.service.TrainerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * 애플리케이션 시작 시 데이터베이스 초기화
 */
@Component
public class DatabaseInitializer implements CommandLineRunner {

  @Autowired
  private UserService userService;

  @Autowired
  private TrainerService trainerService;

  @Override
  public void run(String... args) throws Exception {
    System.out.println("=== Database Initializer Started ===");

    // 모든 사용자 비밀번호를 BCrypt로 업데이트
    try {
      int userCount = userService.fixAllPasswordsWithBCrypt();
      System.out.println("Updated " + userCount + " user passwords to BCrypt hashes");

      int trainerCount = trainerService.fixAllPasswordsWithBCrypt();
      System.out.println("Updated " + trainerCount + " trainer passwords to BCrypt hashes");
    } catch (Exception e) {
      System.out.println("Error updating passwords: " + e.getMessage());
      e.printStackTrace();
    }

    System.out.println("=== Database Initializer Completed ===");
  }
}
