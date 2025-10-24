<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 프로필 - HealthWeb</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        .profile-image {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 5px solid white;
            object-fit: cover;
        }
        .info-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .stat-box {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
            margin: 10px 0;
        }
        .stat-box h3 { color: #667eea; margin: 10px 0; }
        .bmi-indicator {
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            font-weight: bold;
        }
        .bmi-normal { background-color: #d4edda; color: #155724; }
        .bmi-overweight { background-color: #fff3cd; color: #856404; }
        .bmi-obese { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <!-- 네비게이션 -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-heart-pulse"></i> HealthWeb
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/dashboard">
                            <i class="bi bi-speedometer2"></i> 대시보드
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/profile">
                            <i class="bi bi-person"></i> 내 프로필
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/logout">
                            <i class="bi bi-box-arrow-right"></i> 로그아웃
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 프로필 헤더 -->
    <div class="profile-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/uploads/${user.profileImage}" 
                                 class="profile-image" alt="프로필 사진">
                        </c:when>
                        <c:otherwise>
                            <img src="https://via.placeholder.com/150" class="profile-image" alt="기본 프로필">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="col-md-9">
                    <h2><i class="bi bi-person-circle"></i> ${user.name}님의 프로필</h2>
                    <p class="mb-1"><i class="bi bi-at"></i> ${user.username}</p>
                    <p class="mb-1"><i class="bi bi-envelope"></i> ${user.email}</p>
                    <p><i class="bi bi-telephone"></i> ${user.phone}</p>
                </div>
            </div>
        </div>
    </div>

    <div class="container mb-5">
        <div class="row">
            <!-- 왼쪽: 기본 정보 -->
            <div class="col-md-6">
                <div class="info-card">
                    <h4 class="mb-4"><i class="bi bi-info-circle"></i> 기본 정보</h4>
                    
                    <div class="mb-3">
                        <strong><i class="bi bi-calendar"></i> 생년월일:</strong>
                        <span class="float-end">
                            <fmt:formatDate value="${user.birthDate}" pattern="yyyy년 MM월 dd일"/>
                        </span>
                    </div>
                    
                    <div class="mb-3">
                        <strong><i class="bi bi-gender-ambiguous"></i> 성별:</strong>
                        <span class="float-end">
                            ${user.gender == 'M' ? '남성' : '여성'}
                        </span>
                    </div>
                    
                    <div class="mb-3">
                        <strong><i class="bi bi-clock"></i> 가입일:</strong>
                        <span class="float-end">
                            <fmt:formatDate value="${user.createdAt}" pattern="yyyy.MM.dd"/>
                        </span>
                    </div>
                    
                    <hr>
                    <button class="btn btn-outline-primary w-100" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                        <i class="bi bi-pencil"></i> 프로필 수정
                    </button>
                </div>
            </div>

            <!-- 오른쪽: 신체 정보 -->
            <div class="col-md-6">
                <div class="info-card">
                    <h4 class="mb-4"><i class="bi bi-activity"></i> 신체 정보</h4>
                    
                    <div class="row">
                        <div class="col-6">
                            <div class="stat-box">
                                <i class="bi bi-speedometer2" style="font-size: 30px; color: #667eea;"></i>
                                <h3>${user.weight} kg</h3>
                                <small class="text-muted">체중</small>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="stat-box">
                                <i class="bi bi-rulers" style="font-size: 30px; color: #667eea;"></i>
                                <h3>${user.height} cm</h3>
                                <small class="text-muted">키</small>
                            </div>
                        </div>
                    </div>

                    <!-- BMI 계산 -->
                    <c:if test="${not empty user.weight and not empty user.height}">
                        <c:set var="bmi" value="${user.weight / ((user.height / 100) * (user.height / 100))}" />
                        <div class="mt-3">
                            <h5>BMI 지수</h5>
                            <c:choose>
                                <c:when test="${bmi < 18.5}">
                                    <div class="bmi-indicator" style="background-color: #cfe2ff; color: #084298;">
                                        <fmt:formatNumber value="${bmi}" pattern="#.##"/> - 저체중
                                    </div>
                                </c:when>
                                <c:when test="${bmi >= 18.5 and bmi < 25}">
                                    <div class="bmi-indicator bmi-normal">
                                        <fmt:formatNumber value="${bmi}" pattern="#.##"/> - 정상
                                    </div>
                                </c:when>
                                <c:when test="${bmi >= 25 and bmi < 30}">
                                    <div class="bmi-indicator bmi-overweight">
                                        <fmt:formatNumber value="${bmi}" pattern="#.##"/> - 과체중
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="bmi-indicator bmi-obese">
                                        <fmt:formatNumber value="${bmi}" pattern="#.##"/> - 비만
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- 프로필 수정 모달 -->
    <div class="modal fade" id="editProfileModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="bi bi-pencil"></i> 프로필 수정</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/user/update" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label class="form-label">프로필 사진</label>
                            <input type="file" class="form-control" name="profileImage" accept="image/*">
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">이름</label>
                                <input type="text" class="form-control" name="name" value="${user.name}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">이메일</label>
                                <input type="email" class="form-control" name="email" value="${user.email}" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">전화번호</label>
                            <input type="tel" class="form-control" name="phone" value="${user.phone}">
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">체중 (kg)</label>
                                <input type="number" step="0.1" class="form-control" name="weight" value="${user.weight}">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">키 (cm)</label>
                                <input type="number" step="0.1" class="form-control" name="height" value="${user.height}">
                            </div>
                        </div>
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                            <button type="submit" class="btn btn-primary">저장</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
