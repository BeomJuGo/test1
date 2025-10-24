<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>인증 목록 - HealthWeb</title>
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
        .cert-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        .cert-card:hover {
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            transform: translateY(-3px);
        }
        .cert-img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            cursor: pointer;
        }
        .cert-info {
            padding: 20px;
        }
        .feedback-section {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
        }
        .badge-type {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 13px;
        }
        .filter-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/${isTrainer ? 'trainer' : 'user'}/dashboard">
                            <i class="bi bi-speedometer2"></i> 대시보드
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/certification/list">
                            <i class="bi bi-images"></i> 인증 내역
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/${isTrainer ? 'trainer' : 'user'}/logout">
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
            <h2><i class="bi bi-images"></i> 인증 내역</h2>
            <p class="mb-0">
                <c:choose>
                    <c:when test="${isTrainer}">
                        ${userName}님의 인증 기록을 확인하세요
                    </c:when>
                    <c:otherwise>
                        나의 운동 & 식단 인증 기록
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>

    <div class="container mb-5">
        <!-- 필터 -->
        <div class="filter-card">
            <form action="${pageContext.request.contextPath}/certification/list" method="get">
                <c:if test="${not empty userId}">
                    <input type="hidden" name="userId" value="${userId}">
                </c:if>
                <div class="row align-items-end">
                    <div class="col-md-3">
                        <label class="form-label">유형</label>
                        <select class="form-select" name="type">
                            <option value="">전체</option>
                            <option value="exercise" ${param.type == 'exercise' ? 'selected' : ''}>운동</option>
                            <option value="diet" ${param.type == 'diet' ? 'selected' : ''}>식단</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">피드백 여부</label>
                        <select class="form-select" name="feedback">
                            <option value="">전체</option>
                            <option value="pending" ${param.feedback == 'pending' ? 'selected' : ''}>대기중</option>
                            <option value="completed" ${param.feedback == 'completed' ? 'selected' : ''}>완료</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">기간</label>
                        <div class="input-group">
                            <input type="date" class="form-control" name="startDate" value="${param.startDate}">
                            <span class="input-group-text">~</span>
                            <input type="date" class="form-control" name="endDate" value="${param.endDate}">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- 통계 -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="bi bi-camera" style="font-size: 30px; color: #667eea;"></i>
                        <h4 class="mt-2">${totalCerts}</h4>
                        <small class="text-muted">총 인증 수</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="bi bi-dumbbell" style="font-size: 30px; color: #667eea;"></i>
                        <h4 class="mt-2">${exerciseCerts}</h4>
                        <small class="text-muted">운동 인증</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="bi bi-egg-fried" style="font-size: 30px; color: #28a745;"></i>
                        <h4 class="mt-2">${dietCerts}</h4>
                        <small class="text-muted">식단 인증</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <i class="bi bi-chat-dots" style="font-size: 30px; color: #ffc107;"></i>
                        <h4 class="mt-2">${feedbackCerts}</h4>
                        <small class="text-muted">피드백 완료</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- 인증 목록 -->
        <c:choose>
            <c:when test="${not empty certifications}">
                <div class="row">
                    <c:forEach var="cert" items="${certifications}">
                        <div class="col-md-4">
                            <div class="cert-card">
                                <img src="${pageContext.request.contextPath}/uploads/${cert.imagePath}" 
                                     class="cert-img" alt="인증사진"
                                     data-bs-toggle="modal" data-bs-target="#imageModal${cert.certId}">
                                
                                <div class="cert-info">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <c:choose>
                                            <c:when test="${cert.type == 'exercise'}">
                                                <span class="badge-type bg-primary text-white">
                                                    <i class="bi bi-dumbbell"></i> 운동
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-type bg-success text-white">
                                                    <i class="bi bi-egg-fried"></i> 식단
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:choose>
                                            <c:when test="${not empty cert.trainerFeedback}">
                                                <span class="badge bg-success">피드백 완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning">대기중</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <h6 class="mb-2">${cert.planName}</h6>
                                    <p class="text-muted small mb-2">
                                        <i class="bi bi-calendar"></i>
                                        <fmt:formatDate value="${cert.completedAt}" pattern="yyyy.MM.dd HH:mm"/>
                                    </p>

                                    <c:if test="${not empty cert.comment}">
                                        <p class="small mb-2">
                                            <i class="bi bi-chat-left-quote"></i> ${cert.comment}
                                        </p>
                                    </c:if>

                                    <c:if test="${not empty cert.trainerFeedback}">
                                        <div class="feedback-section">
                                            <small class="text-muted d-block mb-1">
                                                <i class="bi bi-person-badge"></i> 트레이너 피드백
                                            </small>
                                            <p class="mb-0 small">${cert.trainerFeedback}</p>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${cert.feedbackAt}" pattern="yyyy.MM.dd HH:mm"/>
                                            </small>
                                        </div>
                                    </c:if>

                                    <c:if test="${isTrainer and empty cert.trainerFeedback}">
                                        <button type="button" class="btn btn-sm btn-outline-primary w-100 mt-2"
                                                data-bs-toggle="modal" data-bs-target="#feedbackModal${cert.certId}">
                                            <i class="bi bi-chat-dots"></i> 피드백 작성
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- 이미지 확대 모달 -->
                        <div class="modal fade" id="imageModal${cert.certId}" tabindex="-1">
                            <div class="modal-dialog modal-lg modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">${cert.planName}</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body text-center">
                                        <img src="${pageContext.request.contextPath}/uploads/${cert.imagePath}" 
                                             class="img-fluid" alt="인증사진">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 피드백 작성 모달 (트레이너용) -->
                        <c:if test="${isTrainer}">
                            <div class="modal fade" id="feedbackModal${cert.certId}" tabindex="-1">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">피드백 작성</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/certification/feedback" method="post">
                                            <input type="hidden" name="certId" value="${cert.certId}">
                                            <input type="hidden" name="type" value="${cert.type}">
                                            <div class="modal-body">
                                                <div class="mb-3">
                                                    <img src="${pageContext.request.contextPath}/uploads/${cert.imagePath}" 
                                                         class="img-fluid rounded" alt="인증사진">
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">회원 코멘트</label>
                                                    <p class="form-control-plaintext">${cert.comment}</p>
                                                </div>
                                                <div class="mb-3">
                                                    <label class="form-label">피드백 <span class="text-danger">*</span></label>
                                                    <textarea class="form-control" name="feedback" rows="4" 
                                                              placeholder="회원에게 응원과 조언을 전해주세요" required></textarea>
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                                                <button type="submit" class="btn btn-primary">
                                                    <i class="bi bi-send"></i> 피드백 전송
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>

                <!-- 페이지네이션 -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&type=${param.type}&feedback=${param.feedback}&startDate=${param.startDate}&endDate=${param.endDate}&userId=${userId}">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&type=${param.type}&feedback=${param.feedback}&startDate=${param.startDate}&endDate=${param.endDate}&userId=${userId}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&type=${param.type}&feedback=${param.feedback}&startDate=${param.startDate}&endDate=${param.endDate}&userId=${userId}">
                                        <i class="bi bi-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="bi bi-inbox" style="font-size: 80px; color: #ccc;"></i>
                    <h4 class="mt-4 text-muted">인증 내역이 없습니다</h4>
                    <p class="text-muted">운동과 식단을 실천하고 인증해보세요!</p>
                    <c:if test="${not isTrainer}">
                        <a href="${pageContext.request.contextPath}/plan/daily-plan" class="btn btn-primary mt-3">
                            <i class="bi bi-calendar-check"></i> 내 계획 보기
                        </a>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
