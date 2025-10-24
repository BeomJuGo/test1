# HealthWeb - Spring Boot Application

건강 관리 웹 애플리케이션 (Spring Boot 버전)

## 🚀 주요 변경사항

### Spring Boot로 전환
- **기존**: Spring MVC + XML 설정
- **현재**: Spring Boot + 자동 설정

### 주요 개선사항
- ✅ 자동 설정으로 복잡한 XML 설정 제거
- ✅ 내장 Tomcat 서버 사용
- ✅ Thymeleaf 템플릿 엔진 적용
- ✅ Spring Security 통합
- ✅ MyBatis Spring Boot Starter 사용
- ✅ 개발 도구 (DevTools) 포함

## 🛠️ 기술 스택

- **Backend**: Spring Boot 2.7.18
- **Database**: MySQL 8.0
- **ORM**: MyBatis
- **Template**: Thymeleaf
- **Security**: Spring Security
- **Build Tool**: Maven
- **Java Version**: 11

## 📋 실행 방법

### 1. 데이터베이스 설정
```sql
-- MySQL에서 데이터베이스 생성
CREATE DATABASE healthdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- database_schema.sql 파일 실행
source database_schema.sql;
```

### 2. 환경변수 설정 (선택사항)
```bash
# Windows
set DB_USERNAME=your_username
set DB_PASSWORD=your_password
set UPLOAD_DIR=uploads

# Linux/Mac
export DB_USERNAME=your_username
export DB_PASSWORD=your_password
export UPLOAD_DIR=uploads
```

### 3. 애플리케이션 실행

#### 방법 1: IDE에서 실행
1. `HealthWebApplication.java` 파일 열기
2. `main` 메서드 실행

#### 방법 2: Maven으로 실행
```bash
mvn spring-boot:run
```

#### 방법 3: JAR 파일로 실행
```bash
mvn clean package
java -jar target/health-web-1.0.0.jar
```

### 4. 접속
- **URL**: http://localhost:8080
- **기본 관리자**: admin / admin123

## 📁 프로젝트 구조

```
src/
├── main/
│   ├── java/
│   │   └── com/health/
│   │       ├── HealthWebApplication.java    # 메인 애플리케이션
│   │       ├── config/                      # 설정 클래스들
│   │       ├── controller/                  # 컨트롤러
│   │       ├── service/                     # 서비스
│   │       ├── dao/                         # 데이터 접근 객체
│   │       ├── model/                       # 엔티티 모델
│   │       ├── util/                        # 유틸리티
│   │       ├── exception/                   # 예외 처리
│   │       └── interceptor/                 # 인터셉터
│   └── resources/
│       ├── application.yml                  # Spring Boot 설정
│       ├── templates/                       # Thymeleaf 템플릿
│       └── static/                          # 정적 리소스
└── test/                                    # 테스트 코드
```

## 🔧 설정 파일

### application.yml
- 데이터베이스 연결 설정
- 파일 업로드 설정
- 로깅 설정
- 보안 설정

### 주요 설정값
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/healthdb
    username: ${DB_USERNAME:root}
    password: ${DB_PASSWORD:password123}
  
file:
  upload:
    directory: ${UPLOAD_DIR:uploads}
    max-size: 10485760
    allowed-types: jpg,jpeg,png,gif,pdf
```

## 🎯 주요 기능

1. **사용자 관리**
   - 회원가입/로그인
   - 프로필 관리

2. **트레이너 관리**
   - 트레이너 등록/로그인
   - 전문 분야 관리

3. **매칭 시스템**
   - 사용자-트레이너 매칭
   - 매칭 상태 관리

4. **운동/식단 계획**
   - 개인별 맞춤 계획
   - 캘린더 기반 관리

5. **인증 시스템**
   - 운동/식단 인증
   - 피드백 시스템

## 🔒 보안

- Spring Security 적용
- BCrypt 패스워드 암호화
- 세션 기반 인증
- CSRF 보호 (개발 단계에서는 비활성화)

## 📝 개발 가이드

### 새로운 컨트롤러 추가
```java
@Controller
@RequestMapping("/api")
public class ApiController {
    
    @Autowired
    private SomeService someService;
    
    @GetMapping("/data")
    public ResponseEntity<Map<String, Object>> getData() {
        // 구현
    }
}
```

### 새로운 서비스 추가
```java
@Service
@Transactional
public class SomeService {
    
    @Autowired
    private SomeDao someDao;
    
    public void doSomething() {
        // 구현
    }
}
```

## 🐛 문제 해결

### 포트 충돌
```yaml
server:
  port: 8081  # 다른 포트 사용
```

### 데이터베이스 연결 오류
1. MySQL 서비스 실행 확인
2. 데이터베이스 생성 확인
3. 사용자 권한 확인

### 파일 업로드 오류
1. uploads 디렉토리 권한 확인
2. 파일 크기 제한 확인

## 📞 지원

문제가 발생하면 다음을 확인하세요:
1. 로그 파일 확인
2. 데이터베이스 연결 상태
3. 포트 사용 상태
4. 파일 권한

---

**HealthWeb** - 건강한 삶을 위한 파트너 🏃‍♂️💪