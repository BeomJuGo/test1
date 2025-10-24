<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>일일 계획 - HealthWeb</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
        }
        .calendar-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .date-selector {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        .plan-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
        }
        .plan-card.diet {
            border-left-color: #28a745;
        }
        .plan-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .nutrition-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 15px;
            font-size: 12px;
            margin-right: 5px;
        }
        .completed {
            opacity: 0.6;
            text-decoration: line-through;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/dashboard">
                            <i class="bi bi-speedometer2"></i> 대시보드
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/plan/daily-plan">
                            <i class="bi bi-calendar-check"></i> 내 계획
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/profile">
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

    <!-- 페이지 헤더 -->
    <div class="page-header">
        <div class="container">
            <h2><i class="bi bi-calendar-check"></i> 나의 운동 & 식단 계획</h2>
            <p class="mb-0">오늘의 목표를 달성해보세요!</p>
        </div>
    </div>

    <div class="container mb-5">
        <!-- 날짜 선택 -->
        <div class="calendar-card">
            <div class="date-selector">
                <button class="btn btn-outline-primary" onclick="changeDate(-1)">
                    <i class="bi bi-chevron-left"></i>
                </button>
                <input type="date" class="form-control" id="selectedDate" 
                       value="${selectedDate}" onchange="loadPlanByDate()">
                <button class="btn btn-outline-primary" onclick="changeDate(1)">
                    <i class="bi bi-chevron-right"></i>
                </button>
                <button class="btn btn-primary" onclick="setToday()">
                    <i class="bi bi-calendar-today"></i> 오늘
                </button>
            </div>

            <div class="text-center">
                <h4 id="displayDate">
                    <fmt:formatDate value="${selectedDateObj}" pattern="yyyy년 MM월 dd일 (E)"/>
                </h4>
            </div>
        </div>

        <div class="row">
            <!-- 운동 계획 -->
            <div class="col-md-6">
                <div class="plan-card">
                    <h4 class="mb-4">
                        <i class="bi bi-dumbbell text-primary"></i> 운동 계획
                    </h4>

                    <c:choose>
                        <c:when test="${not empty exercisePlans}">
                            <c:forEach var="exercise" items="${exercisePlans}">
                                <div class="plan-item ${exercise.completed ? 'completed' : ''}">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h6 class="mb-1">${exercise.exerciseName}</h6>
                                        <c:if test="${exercise.completed}">
                                            <span class="badge bg-success">완료</span>
                                        </c:if>
                                    </div>
                                    <p class="mb-2 small text-muted">
                                        <i class="bi bi-repeat"></i> ${exercise.sets}세트 × ${exercise.reps}회 | 
                                        <i class="bi bi-clock"></i> ${exercise.duration}분 | 
                                        <i class="bi bi-fire"></i> ${exercise.calories}kcal
                                    </p>
                                    <c:if test="${not empty exercise.description}">
                                        <p class="small text-muted mb-2">${exercise.description}</p>
                                    </c:if>
                                    <c:if test="${not exercise.completed}">
                                        <a href="${pageContext.request.contextPath}/certification/upload?type=exercise&planId=${exercise.planId}" 
                                           class="btn btn-sm btn-primary">
                                            <i class="bi bi-camera"></i> 인증하기
                                        </a>
                                    </c:if>
                                </div>
                            </c:forEach>

                            <!-- 총 칼로리 -->
                            <div class="alert alert-info mt-3">
                                <i class="bi bi-fire"></i> 오늘 목표 소모 칼로리: 
                                <strong>${totalExerciseCalories}kcal</strong>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-x" style="font-size: 60px; color: #ccc;"></i>
                                <p class="text-muted mt-3">이 날짜의 운동 계획이 없습니다</p>
                                <c:if test="${isTrainer}">
                                    <a href="${pageContext.request.contextPath}/plan/create-plan?matchingId=${matchingId}&date=${selectedDate}" 
                                       class="btn btn-outline-primary">
                                        <i class="bi bi-plus-circle"></i> 계획 추가
                                    </a>
                                </c:if>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 식단 계획 -->
            <div class="col-md-6">
                <div class="plan-card diet">
                    <h4 class="mb-4">
                        <i class="bi bi-egg-fried text-success"></i> 식단 계획
                    </h4>

                    <c:choose>
                        <c:when test="${not empty dietPlans}">
                            <c:forEach var="diet" items="${dietPlans}">
                                <div class="plan-item ${diet.completed ? 'completed' : ''}">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h6 class="mb-1">
                                            <c:choose>
                                                <c:when test="${diet.mealType == 'BREAKFAST'}">
                                                    <i class="bi bi-sunrise"></i> 아침
                                                </c:when>
                                                <c:when test="${diet.mealType == 'LUNCH'}">
                                                    <i class="bi bi-sun"></i> 점심
                                                </c:when>
                                                <c:when test="${diet.mealType == 'DINNER'}">
                                                    <i class="bi bi-moon"></i> 저녁
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="bi bi-cup-straw"></i> 간식
                                                </c:otherwise>
                                            </c:choose>
                                            - ${diet.mealName}
                                        </h6>
                                        <c:if test="${diet.completed}">
                                            <span class="badge bg-success">완료</span>
                                        </c:if>
                                    </div>
                                    <p class="mb-2 small">
                                        <span class="nutrition-badge bg-danger text-white">
                                            <i class="bi bi-fire"></i> ${diet.calories}kcal
                                        </span>
                                        <span class="nutrition-badge bg-primary text-white">
                                            탄 ${diet.carbs}g
                                        </span>
                                        <span class="nutrition-badge bg-success text-white">
                                            단 ${diet.protein}g
                                        </span>
                                        <span class="nutrition-badge bg-warning text-dark">
                                            지 ${diet.fat}g
                                        </span>
                                    </p>
                                    <c:if test="${not empty diet.description}">
                                        <p class="small text-muted mb-2">${diet.description}</p>
                                    </c:if>
                                    <c:if test="${not diet.completed}">
                                        <a href="${pageContext.request.contextPath}/certification/upload?type=diet&planId=${diet.dietId}" 
                                           class="btn btn-sm btn-success">
                                            <i class="bi bi-camera"></i> 인증하기
                                        </a>
                                    </c:if>
                                </div>
                            </c:forEach>

                            <!-- 총 영양소 -->
                            <div class="alert alert-success mt-3">
                                <i class="bi bi-calculator"></i> 오늘 목표 영양소:<br>
                                <strong>칼로리 ${totalCalories}kcal | 
                                탄수화물 ${totalCarbs}g | 
                                단백질 ${totalProtein}g | 
                                지방 ${totalFat}g</strong>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="bi bi-calendar-x" style="font-size: 60px; color: #ccc;"></i>
                                <p class="text-muted mt-3">이 날짜의 식단 계획이 없습니다</p>
                                <c:if test="${isTrainer}">
                                    <a href="${pageContext.request.contextPath}/plan/create-plan?matchingId=${matchingId}&date=${selectedDate}" 
                                       class="btn btn-outline-success">
                                        <i class="bi bi-plus-circle"></i> 계획 추가
                                    </a>
                                </c:if>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- 주간 통계 -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-graph-up"></i> 이번 주 달성률</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-4">
                                <h6>운동 계획 달성률</h6>
                                <div class="progress" style="height: 30px;">
                                    <div class="progress-bar bg-primary" style="width: ${weeklyExerciseRate}%">
                                        ${weeklyExerciseRate}%
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <h6>식단 계획 달성률</h6>
                                <div class="progress" style="height: 30px;">
                                    <div class="progress-bar bg-success" style="width: ${weeklyDietRate}%">
                                        ${weeklyDietRate}%
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <h6>전체 달성률</h6>
                                <div class="progress" style="height: 30px;">
                                    <div class="progress-bar bg-warning" style="width: ${weeklyTotalRate}%">
                                        ${weeklyTotalRate}%
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function changeDate(days) {
            const dateInput = document.getElementById('selectedDate');
            const currentDate = new Date(dateInput.value);
            currentDate.setDate(currentDate.getDate() + days);
            dateInput.value = currentDate.toISOString().split('T')[0];
            loadPlanByDate();
        }

        function setToday() {
            const dateInput = document.getElementById('selectedDate');
            dateInput.value = new Date().toISOString().split('T')[0];
            loadPlanByDate();
        }

        function loadPlanByDate() {
            const date = document.getElementById('selectedDate').value;
            const matchingId = '${matchingId}';
            window.location.href = '${pageContext.request.contextPath}/plan/daily-plan?matchingId=' + matchingId + '&date=' + date;
        }
    </script>
</body>
</html>
