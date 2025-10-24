<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>유저 대시보드 - HealthWeb</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .dashboard-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-icon {
            font-size: 40px;
            margin-bottom: 15px;
        }
        .plan-card {
            background: white;
            border-left: 4px solid #667eea;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .trainer-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .trainer-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
        }
        .progress-custom {
            height: 30px;
            font-size: 14px;
            font-weight: bold;
        }
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/dashboard">
                            <i class="bi bi-speedometer2"></i> 대시보드
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/profile">
                            <i class="bi bi-person"></i> 내 프로필
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/matching/trainer-list">
                            <i class="bi bi-people"></i> 트레이너 찾기
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

    <!-- 대시보드 헤더 -->
    <div class="dashboard-header">
        <div class="container">
            <h2><i class="bi bi-speedometer2"></i> ${user.name}님의 대시보드</h2>
            <p class="mb-0">오늘도 건강한 하루 되세요!</p>
        </div>
    </div>

    <div class="container mb-5">
        <!-- 통계 카드 -->
        <div class="row">
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <i class="bi bi-calendar-check stat-icon text-primary"></i>
                    <h3>15일</h3>
                    <p class="text-muted mb-0">운동 일수</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <i class="bi bi-fire stat-icon text-danger"></i>
                    <h3>2,450</h3>
                    <p class="text-muted mb-0">소모 칼로리</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <i class="bi bi-trophy stat-icon text-warning"></i>
                    <h3>85%</h3>
                    <p class="text-muted mb-0">목표 달성률</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <i class="bi bi-graph-up stat-icon text-success"></i>
                    <h3>-2.5kg</h3>
                    <p class="text-muted mb-0">체중 변화</p>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <!-- 왼쪽: 오늘의 계획 -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-list-check"></i> 오늘의 계획</h5>
                    </div>
                    <div class="card-body">
                        <!-- 운동 계획 -->
                        <h6 class="text-muted"><i class="bi bi-dumbbell"></i> 운동</h6>
                        <c:choose>
                            <c:when test="${not empty todayExercises}">
                                <c:forEach var="exercise" items="${todayExercises}">
                                    <div class="plan-card">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">${exercise.exerciseName}</h6>
                                                <small class="text-muted">
                                                    ${exercise.sets}세트 × ${exercise.reps}회 | 
                                                    ${exercise.duration}분 | ${exercise.calories}kcal
                                                </small>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/certification/upload?type=exercise&planId=${exercise.planId}" 
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-camera"></i> 인증
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> 오늘의 운동 계획이 없습니다.
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- 식단 계획 -->
                        <h6 class="text-muted mt-4"><i class="bi bi-egg-fried"></i> 식단</h6>
                        <c:choose>
                            <c:when test="${not empty todayDiets}">
                                <c:forEach var="diet" items="${todayDiets}">
                                    <div class="plan-card">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <h6 class="mb-1">
                                                    <c:choose>
                                                        <c:when test="${diet.mealType == 'BREAKFAST'}">아침</c:when>
                                                        <c:when test="${diet.mealType == 'LUNCH'}">점심</c:when>
                                                        <c:when test="${diet.mealType == 'DINNER'}">저녁</c:when>
                                                        <c:otherwise>간식</c:otherwise>
                                                    </c:choose>
                                                    - ${diet.mealName}
                                                </h6>
                                                <small class="text-muted">
                                                    ${diet.calories}kcal | 
                                                    탄수화물 ${diet.carbs}g | 단백질 ${diet.protein}g | 지방 ${diet.fat}g
                                                </small>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/certification/upload?type=diet&planId=${diet.dietId}" 
                                               class="btn btn-sm btn-outline-success">
                                                <i class="bi bi-camera"></i> 인증
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> 오늘의 식단 계획이 없습니다.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 주간 진행상황 -->
                <div class="card mt-3">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="bi bi-graph-up"></i> 이번 주 진행상황</h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <div class="d-flex justify-content-between mb-2">
                                <span>운동 계획 달성률</span>
                                <span class="fw-bold">85%</span>
                            </div>
                            <div class="progress progress-custom">
                                <div class="progress-bar bg-primary" style="width: 85%">85%</div>
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="d-flex justify-content-between mb-2">
                                <span>식단 계획 달성률</span>
                                <span class="fw-bold">92%</span>
                            </div>
                            <div class="progress progress-custom">
                                <div class="progress-bar bg-success" style="width: 92%">92%</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 오른쪽: 내 트레이너 -->
            <div class="col-md-4">
                <c:choose>
                    <c:when test="${not empty currentMatching}">
                        <div class="trainer-card">
                            <h5 class="mb-3"><i class="bi bi-person-badge"></i> 내 트레이너</h5>
                            <div class="text-center mb-3">
                                <c:choose>
                                    <c:when test="${not empty currentMatching.trainer.profileImage}">
                                        <img src="${pageContext.request.contextPath}/uploads/${currentMatching.trainer.profileImage}" 
                                             class="trainer-img" alt="트레이너">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://via.placeholder.com/80" class="trainer-img" alt="트레이너">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h6 class="text-center">${currentMatching.trainer.name}</h6>
                            <p class="text-muted text-center small">${currentMatching.trainer.specialization}</p>
                            <div class="text-center mb-3">
                                <i class="bi bi-star-fill text-warning"></i>
                                ${currentMatching.trainer.rating} / 5.0
                            </div>
                            <hr>
                            <p class="small"><i class="bi bi-calendar-event"></i> 시작일: 
                                <fmt:formatDate value="${currentMatching.startDate}" pattern="yyyy.MM.dd"/>
                            </p>
                            <p class="small"><i class="bi bi-calendar-check"></i> 종료일: 
                                <fmt:formatDate value="${currentMatching.endDate}" pattern="yyyy.MM.dd"/>
                            </p>
                            <button class="btn btn-outline-primary w-100 mt-2">
                                <i class="bi bi-chat-dots"></i> 메시지 보내기
                            </button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="trainer-card text-center">
                            <i class="bi bi-person-x" style="font-size: 60px; color: #ccc;"></i>
                            <h5 class="mt-3">등록된 트레이너가 없습니다</h5>
                            <p class="text-muted">트레이너와 매칭하여 체계적인 관리를 받아보세요!</p>
                            <a href="${pageContext.request.contextPath}/matching/trainer-list" class="btn btn-primary mt-2">
                                <i class="bi bi-search"></i> 트레이너 찾기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- 최근 인증 -->
                <div class="card mt-3">
                    <div class="card-header">
                        <h6 class="mb-0"><i class="bi bi-images"></i> 최근 인증</h6>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty recentCertifications}">
                                <c:forEach var="cert" items="${recentCertifications}">
                                    <div class="d-flex align-items-center mb-2">
                                        <img src="${pageContext.request.contextPath}/uploads/${cert.imagePath}" 
                                             width="60" height="60" class="rounded me-2" alt="인증사진">
                                        <div class="flex-grow-1">
                                            <small class="d-block">
                                                <fmt:formatDate value="${cert.completedAt}" pattern="MM/dd HH:mm"/>
                                            </small>
                                            <small class="text-muted">${cert.comment}</small>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted text-center small">아직 인증 내역이 없습니다.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
