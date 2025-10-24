-- HealthWeb Database Schema
-- MySQL 5.7 이상 버전 사용

-- 데이터베이스 생성
CREATE DATABASE IF NOT EXISTS healthdb 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE healthdb;

-- 사용자 테이블 (유저)
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    weight DECIMAL(5,2),
    height DECIMAL(5,2),
    birth_date DATE,
    gender ENUM('M', 'F'),
    profile_image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 트레이너 테이블
CREATE TABLE trainers (
    trainer_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    specialization VARCHAR(255),
    experience_years INT,
    certification VARCHAR(255),
    profile_image VARCHAR(255),
    introduction TEXT,
    rating DECIMAL(3,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 매칭 테이블
CREATE TABLE matchings (
    matching_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    trainer_id BIGINT NOT NULL,
    status ENUM('PENDING', 'ACCEPTED', 'REJECTED', 'COMPLETED') DEFAULT 'PENDING',
    start_date DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_trainer_id (trainer_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 운동 계획 테이블
CREATE TABLE exercise_plans (
    plan_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    matching_id BIGINT NOT NULL,
    plan_date DATE NOT NULL,
    exercise_name VARCHAR(255) NOT NULL,
    sets INT,
    reps INT,
    duration INT,
    calories INT,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (matching_id) REFERENCES matchings(matching_id) ON DELETE CASCADE,
    INDEX idx_matching_id (matching_id),
    INDEX idx_plan_date (plan_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 식단 계획 테이블
CREATE TABLE diet_plans (
    diet_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    matching_id BIGINT NOT NULL,
    plan_date DATE NOT NULL,
    meal_type ENUM('BREAKFAST', 'LUNCH', 'DINNER', 'SNACK'),
    meal_name VARCHAR(255) NOT NULL,
    calories INT,
    protein DECIMAL(5,2),
    carbs DECIMAL(5,2),
    fat DECIMAL(5,2),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (matching_id) REFERENCES matchings(matching_id) ON DELETE CASCADE,
    INDEX idx_matching_id (matching_id),
    INDEX idx_plan_date (plan_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 운동 인증 테이블
CREATE TABLE exercise_certifications (
    cert_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    plan_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    comment TEXT,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    trainer_feedback TEXT,
    feedback_at TIMESTAMP,
    FOREIGN KEY (plan_id) REFERENCES exercise_plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_plan_id (plan_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 식단 인증 테이블
CREATE TABLE diet_certifications (
    cert_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    diet_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    comment TEXT,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    trainer_feedback TEXT,
    feedback_at TIMESTAMP,
    FOREIGN KEY (diet_id) REFERENCES diet_plans(diet_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_diet_id (diet_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 샘플 데이터 삽입 (테스트용)
-- 비밀번호는 모두 'password123'을 BCrypt로 해싱한 값입니다.

-- 샘플 유저
INSERT INTO users (username, password, name, email, phone, weight, height, birth_date, gender) VALUES
('user1', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '김철수', 'user1@example.com', '010-1234-5678', 75.5, 175.0, '1990-01-15', 'M'),
('user2', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '이영희', 'user2@example.com', '010-2345-6789', 62.3, 165.0, '1992-03-20', 'F');

-- 샘플 트레이너
INSERT INTO trainers (username, password, name, email, phone, specialization, experience_years, certification, introduction, rating) VALUES
('trainer1', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '박트레이너', 'trainer1@example.com', '010-3456-7890', '근력운동, 체중감량', 5, '생활스포츠지도사 2급', '안녕하세요! 5년 경력의 트레이너입니다.', 4.8),
('trainer2', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '최코치', 'trainer2@example.com', '010-4567-8901', '요가, 필라테스', 3, '요가지도자 자격증', '건강한 삶을 위해 함께 노력하겠습니다!', 4.9);
