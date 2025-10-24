<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 - HealthWeb</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
        }
        .client-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        .client-card:hover {
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            transform: translateY(-3px);
        }
        .client-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
        }
        .info-badge {
            background-color: #f8f9fa;
            padding: 5px 10px;
            border-radius: 5px;
            margin-right: 5px;
            display: inline-block;
            margin-bottom: 5px;
        }
        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 13px;
        }
        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/trainer/dashboard">
                            <i class="bi bi-speedometer2"></i> 대시보드
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/trainer/client-list">
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

    <!-- 페이지 헤더 -->
    <div class="page-header">
        <div class="container">
            <h2><i class="bi bi-people-fill"></i> 회원 관리</h2>
            <p class="mb-0">총 ${totalClients}명의 회원을 관리하고 있습니다</p>
        </div>
    </div>

    <div class="container mb-5">
        <!-- 필터 & 검색 -->
        <div class="filter-section">
            <form action="${pageContext.request.contextPath}/trainer/client-list" method="get">
                <div class="row align-items-end">
                    <div class="col-md-3">
                        <label class="form-label">상태</label>
                        <select class="form-select" name="status">
                            <option value="">전체</option>
                            <option value="ACCEPTED" ${param.status == 'ACCEPTED' ? 'selected' : ''}>활성</option>
                            <option value="COMPLETED" ${param.status == 'COMPLETED' ? 'selected' : ''}>완료</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">정렬</label>
                        <select class="form-select" name="sort">
                            <option value="recent" ${param.sort == 'recent' ? 'selected' : ''}>최근 등록순</option>
                            <option value="name" ${param.sort == 'name' ? 'selected' : ''}>이름순</option>
                            <option value="weight" ${param.sort == 'weight' ? 'selected' : ''}>체중순</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">검색</label>
                        <input type="text" class="form-control" name="search" 
                               placeholder="회원 이름 검색" value="${param.search}">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- 회원 목록 -->
        <c:choose>
            <c:when test="${not empty clients}">
                <div class="row">
                    <c:forEach var="client" items="${clients}">
                        <div class="col-md-6">
                            <div class="client-card">
                                <div class="row">
                                    <div class="col-auto">
                                        <c:choose>
                                            <c:when test="${not empty client.user.profileImage}">
                                                <img src="${pageContext.request.contextPath}/uploads/${client.user.profileImage}" 
                                                     class="client-img" alt="회원">
                                            </c:when>
                                            <c:otherwise>
                                                <img src="https://via.placeholder.com/80" class="client-img" alt="회원">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="col">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="mb-0">${client.user.name}</h5>
                                            <c:choose>
                                                <c:when test="${client.status == 'ACCEPTED'}">
                                                    <span class="status-badge bg-success text-white">활성</span>
                                                </c:when>
                                                <c:when test="${client.status == 'COMPLETED'}">
                                                    <span class="status-badge bg-secondary text-white">완료</span>
                                                </c:when>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="mb-2">
                                            <small class="text-muted">
                                                <i class="bi bi-envelope"></i> ${client.user.email}<br>
                                                <i class="bi bi-telephone"></i> ${client.user.phone}
                                            </small>
                                        </div>

                                        <div class="mb-3">
                                            <span class="info-badge">
                                                <i class="bi bi-gender-${client.user.gender == 'M' ? 'male' : 'female'}"></i>
                                                ${client.user.gender == 'M' ? '남성' : '여성'}
                                            </span>
                                            <span class="info-badge">
                                                <i class="bi bi-speedometer2"></i> ${client.user.weight}kg
                                            </span>
                                            <span class="info-badge">
                                                <i class="bi bi-rulers"></i> ${client.user.height}cm
                                            </span>
                                            <span class="info-badge">
                                                <i class="bi bi-calendar"></i> 
                                                <fmt:formatDate value="${client.user.birthDate}" pattern="yyyy.MM.dd"/>
                                            </span>
                                        </div>

                                        <div class="mb-3">
                                            <small class="text-muted">
                                                <i class="bi bi-calendar-check"></i> 시작일: 
                                                <fmt:formatDate value="${client.startDate}" pattern="yyyy.MM.dd"/> | 
                                                <i class="bi bi-calendar-x"></i> 종료일: 
                                                <fmt:formatDate value="${client.endDate}" pattern="yyyy.MM.dd"/>
                                            </small>
                                        </div>

                                        <div class="btn-group w-100" role="group">
                                            <a href="${pageContext.request.contextPath}/plan/daily-plan?matchingId=${client.matchingId}" 
                                               class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-calendar-event"></i> 계획 보기
                                            </a>
                                            <a href="${pageContext.request.contextPath}/plan/create-plan?matchingId=${client.matchingId}" 
                                               class="btn btn-sm btn-outline-success">
                                                <i class="bi bi-plus-circle"></i> 계획 작성
                                            </a>
                                            <a href="${pageContext.request.contextPath}/certification/list?userId=${client.user.userId}" 
                                               class="btn btn-sm btn-outline-info">
                                                <i class="bi bi-images"></i> 인증 보기
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 페이지네이션 -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&status=${param.status}&sort=${param.sort}&search=${param.search}">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&status=${param.status}&sort=${param.sort}&search=${param.search}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&status=${param.status}&sort=${param.sort}&search=${param.search}">
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
                    <h4 class="mt-4 text-muted">등록된 회원이 없습니다</h4>
                    <p class="text-muted">매칭 요청을 기다려주세요!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
