package com.health.repository;

import com.health.model.Trainer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TrainerRepository extends JpaRepository<Trainer, Long> {

  /**
   * 사용자명으로 트레이너 찾기
   */
  Optional<Trainer> findByUsername(String username);

  /**
   * 이메일로 트레이너 찾기
   */
  Optional<Trainer> findByEmail(String email);

  /**
   * 사용자명과 비밀번호로 트레이너 찾기 (로그인용)
   */
  Optional<Trainer> findByUsernameAndPassword(String username, String password);

  /**
   * 전문 분야로 트레이너 찾기
   */
  List<Trainer> findBySpecialization(String specialization);

  /**
   * 경력으로 트레이너 찾기 (최소 경력 이상)
   */
  List<Trainer> findByExperienceYearsGreaterThanEqual(Integer minExperience);

  /**
   * 평점으로 트레이너 찾기 (최소 평점 이상)
   */
  List<Trainer> findByRatingGreaterThanEqual(Double minRating);

  /**
   * 사용자명 존재 여부 확인
   */
  boolean existsByUsername(String username);

  /**
   * 이메일 존재 여부 확인
   */
  boolean existsByEmail(String email);
}
