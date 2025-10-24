-- 기존 사용자들의 비밀번호를 BCrypt 해시로 업데이트
-- 이 스크립트는 MySQL에서 직접 실행해야 합니다.

USE healthdb;

-- 모든 사용자의 비밀번호를 'password123'의 BCrypt 해시로 업데이트
-- BCrypt 해시: $2a$10$xxxxx...

-- user1: password123
UPDATE users SET password = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy' WHERE username = 'user1';

-- user2: password123  
UPDATE users SET password = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy' WHERE username = 'user2';

-- user3: password123
UPDATE users SET password = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy' WHERE username = 'user3';

-- lom0097: password123 (이미 리셋했을 수도 있음)
UPDATE users SET password = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy' WHERE username = 'lom0097';

-- 트레이너 비밀번호도 업데이트
UPDATE trainers SET password = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy' WHERE username = 'trainer1';
UPDATE trainers SET password = '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy' WHERE username = 'trainer2';

-- 업데이트 확인
SELECT username, LEFT(password, 20) as password_prefix FROM users;
SELECT username, LEFT(password, 20) as password_prefix FROM trainers;

