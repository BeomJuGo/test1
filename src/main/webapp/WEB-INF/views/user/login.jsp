<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>유저 로그인 - HealthWeb</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        .login-container {
            max-width: 450px;
            margin: 50px auto;
        }
        .login-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            padding: 40px;
        }
        .logo-section {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo-section i {
            font-size: 60px;
            color: #667eea;
        }
        .logo-section h2 {
            color: #333;
            font-weight: bold;
            margin-top: 15px;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: bold;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 20px rgba(102, 126, 234, 0.4);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="login-container">
            <div class="login-card">
                <div class="logo-section">
                    <i class="bi bi-person-circle"></i>
                    <h2>유저 로그인</h2>
                    <p class="text-muted">건강한 삶의 시작, HealthWeb</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/user/login" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">
                            <i class="bi bi-person"></i> 아이디
                        </label>
                        <input type="text" class="form-control" id="username" name="username" 
                               placeholder="아이디를 입력하세요" required>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="bi bi-lock"></i> 비밀번호
                        </label>
                        <input type="password" class="form-control" id="password" name="password" 
                               placeholder="비밀번호를 입력하세요" required>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="rememberMe" name="rememberMe">
                        <label class="form-check-label" for="rememberMe">
                            로그인 상태 유지
                        </label>
                    </div>

                    <button type="submit" class="btn btn-primary btn-login w-100 mb-3">
                        <i class="bi bi-box-arrow-in-right"></i> 로그인
                    </button>
                </form>

                <div class="text-center mt-3">
                    <p class="mb-2">
                        <a href="${pageContext.request.contextPath}/user/find-password" class="text-decoration-none">
                            비밀번호 찾기
                        </a>
                    </p>
                    <p>
                        계정이 없으신가요? 
                        <a href="${pageContext.request.contextPath}/user/register" class="fw-bold text-decoration-none">
                            회원가입
                        </a>
                    </p>
                    <hr>
                    <p>
                        <a href="${pageContext.request.contextPath}/trainer/login" class="text-muted text-decoration-none">
                            <i class="bi bi-arrow-left-circle"></i> 트레이너 로그인
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
