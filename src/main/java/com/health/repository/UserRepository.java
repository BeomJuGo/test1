package com.health.repository;

import com.health.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

  /**
   * 사용자명으로 사용자 찾기
   */
  Optional<User> findByUsername(String username);

  /**
   * 이메일로 사용자 찾기
   */
  Optional<User> findByEmail(String email);

  /**
   * 사용자명과 비밀번호로 사용자 찾기 (로그인용)
   */
  Optional<User> findByUsernameAndPassword(String username, String password);

  /**
   * 사용자명 존재 여부 확인
   */
  boolean existsByUsername(String username);

  /**
   * 이메일 존재 여부 확인
   */
  boolean existsByEmail(String email);
}
