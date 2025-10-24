<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>트레이너 대시보드 - HealthWeb</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .dashboard-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
        .client-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        .client-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .client-img {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
        }
        .badge-status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        .request-card {
            background: white;
            border-left: 4px solid #f5576c;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <!-- 네비게이션 -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-heart-pulse"></i> HealthWeb Trainer
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/trainer/dashboard">
                            <i class="bi bi-speedometer2"></i> 대시보드
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/trainer/client-list">
                            <i class="bi bi-people"></i> 회원 관리
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/trainer/profile">
                            <i class="bi bi-person"></i> 내 프로필
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/trainer/logout">
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
            <h2><i class="bi bi-person-badge"></i> ${trainer.name} 트레이너님</h2>
            <p class="mb-0">오늘도 회원들의 건강을 응원합니다!</p>
        </div>
    </div>

    <div class="container mb-5">
        <!-- 통계 카드 -->
        <div class="row">
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <i class="bi bi-people-fill stat-icon text-primary"></i>
                    <h3>${totalClients}</h3>
                    <p class="text-muted mb-0">총 회원 수</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <i class="bi bi-person-check-fill stat-icon text-success"></i>
                    <h3>${activeClients}</h3>
                    <p class="text-muted mb-0">활성 회원</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <i class="bi bi-bell-fill stat-icon text-warning"></i>
                    <h3>${pendingRequests}</h3>
                    <p class="text-muted mb-0">대기 중인 요청</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card text-center">
                    <i class="bi bi-star-fill stat-icon text-danger"></i>
                    <h3>${trainer.rating}</h3>
                    <p class="text-muted mb-0">평점</p>
                </div>
            </div>
        </div>

        <div class="row mt-4">
            <!-- 왼쪽: 오늘의 회원 -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-calendar-check"></i> 오늘의 회원</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty todayClients}">
                                <c:forEach var="client" items="${todayClients}">
                                    <div class="client-card">
                                        <div class="row align-items-center">
                                            <div class="col-auto">
                                                <c:choose>
                                                    <c:when test="${not empty client.user.profileImage}">
                                                        <img src="${pageContext.request.contextPath}/uploads/${client.user.profileImage}" 
                                                             class="client-img" alt="회원">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="https://via.placeholder.com/60" class="client-img" alt="회원">
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="col">
                                                <h6 class="mb-1">${client.user.name}</h6>
                                                <small class="text-muted">
                                                    <i class="bi bi-envelope"></i> ${client.user.email} | 
                                                    <i class="bi bi-telephone"></i> ${client.user.phone}
                                                </small>
                                                <div class="mt-1">
                                                    <small>
                                                        <i class="bi bi-speedometer2"></i> ${client.user.weight}kg | 
                                                        <i class="bi bi-rulers"></i> ${client.user.height}cm
                                                    </small>
                                                </div>
                                            </div>
                                            <div class="col-auto">
                                                <a href="${pageContext.request.contextPath}/plan/create-plan?matchingId=${client.matchingId}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-calendar-plus"></i> 계획 작성
                                                </a>
                                                <a href="${pageContext.request.contextPath}/certification/list?userId=${client.user.userId}" 
                                                   class="btn btn-sm btn-outline-success">
                                                    <i class="bi bi-images"></i> 인증 보기
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle"></i> 오늘 관리할 회원이 없습니다.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 최근 인증 확인 필요 -->
                <div class="card mt-3">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0"><i class="bi bi-exclamation-triangle"></i> 피드백 대기 중인 인증</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty pendingCertifications}">
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>회원</th>
                                                <th>유형</th>
                                                <th>날짜</th>
                                                <th>상태</th>
                                                <th>작업</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="cert" items="${pendingCertifications}">
                                                <tr>
                                                    <td>${cert.userName}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${cert.type == 'exercise'}">
                                                                <i class="bi bi-dumbbell text-primary"></i> 운동
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="bi bi-egg-fried text-success"></i> 식단
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td><fmt:formatDate value="${cert.completedAt}" pattern="MM/dd HH:mm"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${empty cert.trainerFeedback}">
                                                                <span class="badge bg-warning">대기중</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-success">완료</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/certification/feedback?certId=${cert.certId}" 
                                                           class="btn btn-sm btn-outline-primary">
                                                            <i class="bi bi-chat-dots"></i> 피드백
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted text-center">피드백 대기 중인 인증이 없습니다.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- 오른쪽: 매칭 요청 -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0"><i class="bi bi-bell"></i> 매칭 요청</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty matchingRequests}">
                                <c:forEach var="request" items="${matchingRequests}">
                                    <div class="request-card">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <div>
                                                <h6 class="mb-1">${request.user.name}</h6>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${request.createdAt}" pattern="yyyy.MM.dd"/>
                                                </small>
                                            </div>
                                            <span class="badge bg-warning">대기중</span>
                                        </div>
                                        <small class="d-block mb-2">
                                            ${request.user.gender == 'M' ? '남성' : '여성'} | 
                                            ${request.user.age}세 | 
                                            ${request.user.weight}kg / ${request.user.height}cm
                                        </small>
                                        <div class="btn-group w-100" role="group">
                                            <button type="button" class="btn btn-sm btn-success" 
                                                    onclick="acceptRequest(${request.matchingId})">
                                                <i class="bi bi-check-circle"></i> 수락
                                            </button>
                                            <button type="button" class="btn btn-sm btn-danger" 
                                                    onclick="rejectRequest(${request.matchingId})">
                                                <i class="bi bi-x-circle"></i> 거절
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-4">
                                    <i class="bi bi-inbox" style="font-size: 50px; color: #ccc;"></i>
                                    <p class="text-muted mt-3 mb-0">매칭 요청이 없습니다</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- 나의 통계 -->
                <div class="card mt-3">
                    <div class="card-header">
                        <h6 class="mb-0"><i class="bi bi-bar-chart"></i> 이번 주 통계</h6>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <small class="text-muted">작성한 운동 계획</small>
                            <h4>${weeklyExercisePlans}개</h4>
                        </div>
                        <div class="mb-3">
                            <small class="text-muted">작성한 식단 계획</small>
                            <h4>${weeklyDietPlans}개</h4>
                        </div>
                        <div>
                            <small class="text-muted">피드백 개수</small>
                            <h4>${weeklyFeedbacks}개</h4>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function acceptRequest(matchingId) {
            if (confirm('이 매칭 요청을 수락하시겠습니까?')) {
                location.href = '${pageContext.request.contextPath}/matching/accept?matchingId=' + matchingId;
            }
        }
        
        function rejectRequest(matchingId) {
            if (confirm('이 매칭 요청을 거절하시겠습니까?')) {
                location.href = '${pageContext.request.contextPath}/matching/reject?matchingId=' + matchingId;
            }
        }
    </script>
</body>
</html>
