<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>트레이너 등록 - HealthWeb</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            padding: 30px 0;
        }
        .register-container {
            max-width: 700px;
            margin: 0 auto;
        }
        .register-card {
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
            font-size: 50px;
            color: #f5576c;
        }
        .btn-register {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border: none;
            padding: 12px;
            font-weight: bold;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="register-container">
            <div class="register-card">
                <div class="logo-section">
                    <i class="bi bi-award-fill"></i>
                    <h2>트레이너 등록</h2>
                    <p class="text-muted">전문 트레이너로 시작하세요</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/trainer/register" method="post" id="registerForm">
                    <!-- 기본 정보 -->
                    <h5 class="mb-3"><i class="bi bi-person-lines-fill"></i> 기본 정보</h5>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="username" class="form-label">
                                아이디 <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="username" name="username" 
                                   placeholder="아이디" required>
                            <small class="text-muted">4-20자의 영문, 숫자</small>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="name" class="form-label">
                                이름 <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="name" name="name" 
                                   placeholder="이름" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="password" class="form-label">
                                비밀번호 <span class="text-danger">*</span>
                            </label>
                            <input type="password" class="form-control" id="password" name="password" 
                                   placeholder="비밀번호" required>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="passwordConfirm" class="form-label">
                                비밀번호 확인 <span class="text-danger">*</span>
                            </label>
                            <input type="password" class="form-control" id="passwordConfirm" 
                                   placeholder="비밀번호 확인" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">
                                이메일 <span class="text-danger">*</span>
                            </label>
                            <input type="email" class="form-control" id="email" name="email" 
                                   placeholder="example@email.com" required>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label">
                                전화번호 <span class="text-danger">*</span>
                            </label>
                            <input type="tel" class="form-control" id="phone" name="phone" 
                                   placeholder="010-0000-0000" required>
                        </div>
                    </div>

                    <hr class="my-4">

                    <!-- 전문 정보 -->
                    <h5 class="mb-3"><i class="bi bi-trophy-fill"></i> 전문 정보</h5>
                    <div class="mb-3">
                        <label for="specialization" class="form-label">
                            전문 분야 <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control" id="specialization" name="specialization" 
                               placeholder="예: 근력운동, 체중감량, 요가, 필라테스" required>
                        <small class="text-muted">쉼표(,)로 구분하여 여러 분야 입력 가능</small>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="experienceYears" class="form-label">
                                경력 (년) <span class="text-danger">*</span>
                            </label>
                            <input type="number" class="form-control" id="experienceYears" name="experienceYears" 
                                   placeholder="5" required min="0">
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="certification" class="form-label">
                                자격증 <span class="text-danger">*</span>
                            </label>
                            <input type="text" class="form-control" id="certification" name="certification" 
                                   placeholder="생활스포츠지도사 2급" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="introduction" class="form-label">
                            자기소개 <span class="text-danger">*</span>
                        </label>
                        <textarea class="form-control" id="introduction" name="introduction" rows="4"
                                  placeholder="자신을 소개하고 트레이닝 철학을 알려주세요" required></textarea>
                        <small class="text-muted">최소 50자 이상 작성해주세요</small>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="agreeTerms" required>
                        <label class="form-check-label" for="agreeTerms">
                            <a href="#" class="text-decoration-none">트레이너 이용약관</a> 및 
                            <a href="#" class="text-decoration-none">개인정보처리방침</a>에 동의합니다 
                            <span class="text-danger">*</span>
                        </label>
                    </div>

                    <button type="submit" class="btn btn-register w-100 mb-3">
                        <i class="bi bi-check-circle"></i> 트레이너 등록
                    </button>
                </form>

                <div class="text-center mt-3">
                    <p>
                        이미 계정이 있으신가요? 
                        <a href="${pageContext.request.contextPath}/trainer/login" class="fw-bold text-decoration-none">
                            로그인
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const passwordConfirm = document.getElementById('passwordConfirm').value;
            const introduction = document.getElementById('introduction').value;
            
            if (password !== passwordConfirm) {
                e.preventDefault();
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }
            
            if (introduction.length < 50) {
                e.preventDefault();
                alert('자기소개는 최소 50자 이상 작성해주세요.');
                return false;
            }
        });
    </script>
</body>
</html>
