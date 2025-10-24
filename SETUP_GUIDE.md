# HealthWeb 프로젝트 설정 가이드

## 📋 프로젝트 개요
유저와 트레이너 매칭을 통한 건강 관리 웹 애플리케이션

## 🛠️ 기술 스택
- **Backend**: Spring Framework 5.3.9, Java 11
- **Database**: MySQL 8.0
- **View**: JSP, Tailwind CSS
- **Build Tool**: Maven
- **Server**: Apache Tomcat 9.0

## 📦 1단계: pom.xml에 의존성 추가

기존 pom.xml의 `</dependencies>` 태그 위에 다음 의존성들을 추가하세요:

```xml
<!-- MySQL Connector -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>

<!-- Spring JDBC -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>${org.springframework-version}</version>
</dependency>

<!-- Commons FileUpload (파일 업로드) -->
<dependency>
    <groupId>commons-fileupload</groupId>
    <artifactId>commons-fileupload</artifactId>
    <version>1.5</version>
</dependency>

<dependency>
    <groupId>commons-io</groupId>
    <artifactId>commons-io</artifactId>
    <version>2.11.0</version>
</dependency>

<!-- JSON 처리 -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.15.2</version>
</dependency>

<!-- BCrypt (비밀번호 암호화) -->
<dependency>
    <groupId>org.mindrot</groupId>
    <artifactId>jbcrypt</artifactId>
    <version>0.4</version>
</dependency>
```

## 🗄️ 2단계: MySQL 데이터베이스 설정

### 2.1 MySQL 설치 확인
```bash
mysql --version
```

### 2.2 데이터베이스 생성 및 스키마 적용
```bash
# MySQL 접속
mysql -u root -p

# 프로젝트 루트의 database_schema.sql 실행
source database_schema.sql;
```

또는 MySQL Workbench에서:
1. File > Run SQL Script
2. `database_schema.sql` 선택
3. 실행

### 2.3 application.properties 설정
`src/main/resources/application.properties` 파일에서 다음 부분을 수정하세요:

```properties
spring.datasource.username=root
spring.datasource.password=YOUR_MYSQL_PASSWORD  # 실제 MySQL 비밀번호로 변경
```

## ⚙️ 3단계: 프로젝트 빌드

### 3.1 Maven 의존성 다운로드
```bash
mvn clean install
```

### 3.2 Eclipse/STS에서
1. 프로젝트 우클릭
2. Maven > Update Project
3. Force Update of Snapshots/Releases 체크
4. OK

## 🚀 4단계: 서버 실행

### 4.1 Tomcat 서버 설정
1. Eclipse Servers 탭에서 Tomcat 9.0 추가
2. 프로젝트를 서버에 Add
3. 서버 시작

### 4.2 접속 확인
