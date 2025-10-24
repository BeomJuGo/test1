<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>트레이너 찾기 - HealthWeb</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 0;
            margin-bottom: 30px;
        }
        .trainer-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            margin-bottom: 25px;
            box-shadow: 0 3px 15px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        .trainer-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            transform: translateY(-5px);
        }
        .trainer-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .trainer-rating {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }
        .spec-badge {
            background-color: #e9ecef;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 13px;
            margin-right: 5px;
            margin-bottom: 5px;
            display: inline-block;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/user/dashboard">
                            <i class="bi bi-speedometer2"></i> 대시보드
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/matching/trainer-list">
                            <i class="bi bi-people"></i> 트레이너 찾기
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
        <div class="container text-center">
            <h1><i class="bi bi-search"></i> 나에게 맞는 트레이너를 찾아보세요</h1>
            <p class="lead mb-0">전문 트레이너와 함께 목표를 달성하세요!</p>
        </div>
    </div>

    <div class="container mb-5">
        <!-- 검색 및 필터 -->
        <div class="filter-card">
            <form action="${pageContext.request.contextPath}/matching/trainer-list" method="get">
                <div class="row align-items-end">
                    <div class="col-md-4">
                        <label class="form-label"><i class="bi bi-search"></i> 검색</label>
                        <input type="text" class="form-control" name="search" 
                               placeholder="트레이너 이름 또는 전문분야" value="${param.search}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="bi bi-tag"></i> 전문분야</label>
                        <select class="form-select" name="specialization">
                            <option value="">전체</option>
                            <option value="근력운동" ${param.specialization == '근력운동' ? 'selected' : ''}>근력운동</option>
                            <option value="체중감량" ${param.specialization == '체중감량' ? 'selected' : ''}>체중감량</option>
                            <option value="요가" ${param.specialization == '요가' ? 'selected' : ''}>요가</option>
                            <option value="필라테스" ${param.specialization == '필라테스' ? 'selected' : ''}>필라테스</option>
                            <option value="다이어트" ${param.specialization == '다이어트' ? 'selected' : ''}>다이어트</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label"><i class="bi bi-sort-down"></i> 정렬</label>
                        <select class="form-select" name="sort">
                            <option value="rating" ${param.sort == 'rating' ? 'selected' : ''}>평점 높은순</option>
                            <option value="experience" ${param.sort == 'experience' ? 'selected' : ''}>경력순</option>
                            <option value="recent" ${param.sort == 'recent' ? 'selected' : ''}>최신 등록순</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- 트레이너 목록 -->
        <c:choose>
            <c:when test="${not empty trainers}">
                <div class="row">
                    <c:forEach var="trainer" items="${trainers}">
                        <div class="col-md-4">
                            <div class="trainer-card">
                                <c:choose>
                                    <c:when test="${not empty trainer.profileImage}">
                                        <img src="${pageContext.request.contextPath}/uploads/${trainer.profileImage}" 
                                             class="trainer-img" alt="트레이너">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://via.placeholder.com/400x200" class="trainer-img" alt="트레이너">
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="p-4">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h4 class="mb-0">${trainer.name}</h4>
                                        <span class="trainer-rating">
                                            <i class="bi bi-star-fill"></i> ${trainer.rating}
                                        </span>
                                    </div>

                                    <div class="mb-3">
                                        <i class="bi bi-award text-primary"></i>
                                        <small class="text-muted">경력 ${trainer.experienceYears}년</small>
                                        <span class="mx-2">•</span>
                                        <small class="text-muted">${trainer.certification}</small>
                                    </div>

                                    <div class="mb-3">
                                        <c:forEach var="spec" items="${trainer.specializationList}">
                                            <span class="spec-badge">${spec}</span>
                                        </c:forEach>
                                    </div>

                                    <p class="text-muted small" style="height: 60px; overflow: hidden;">
                                        ${trainer.introduction}
                                    </p>

                                    <div class="mb-3">
                                        <small class="text-muted">
                                            <i class="bi bi-envelope"></i> ${trainer.email}<br>
                                            <i class="bi bi-telephone"></i> ${trainer.phone}
                                        </small>
                                    </div>

                                    <div class="d-grid gap-2">
                                        <button type="button" class="btn btn-outline-primary" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#trainerDetailModal${trainer.trainerId}">
                                            <i class="bi bi-info-circle"></i> 상세보기
                                        </button>
                                        <a href="${pageContext.request.contextPath}/matching/request?trainerId=${trainer.trainerId}" 
                                           class="btn btn-primary">
                                            <i class="bi bi-send"></i> 매칭 요청
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 트레이너 상세 모달 -->
                        <div class="modal fade" id="trainerDetailModal${trainer.trainerId}" tabindex="-1">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title">${trainer.name} 트레이너</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <div class="text-center mb-4">
                                            <c:choose>
                                                <c:when test="${not empty trainer.profileImage}">
                                                    <img src="${pageContext.request.contextPath}/uploads/${trainer.profileImage}" 
                                                         width="150" height="150" class="rounded-circle" alt="트레이너">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="https://via.placeholder.com/150" 
                                                         class="rounded-circle" alt="트레이너">
                                                </c:otherwise>
                                            </c:choose>
                                            <h4 class="mt-3">${trainer.name}</h4>
                                            <span class="trainer-rating">
                                                <i class="bi bi-star-fill"></i> ${trainer.rating} / 5.0
                                            </span>
                                        </div>

                                        <h6><i class="bi bi-award"></i> 자격 및 경력</h6>
                                        <p>• 경력: ${trainer.experienceYears}년</p>
                                        <p>• 자격증: ${trainer.certification}</p>

                                        <h6 class="mt-3"><i class="bi bi-star"></i> 전문 분야</h6>
                                        <p>${trainer.specialization}</p>

                                        <h6 class="mt-3"><i class="bi bi-chat-quote"></i> 소개</h6>
                                        <p>${trainer.introduction}</p>

                                        <h6 class="mt-3"><i class="bi bi-telephone"></i> 연락처</h6>
                                        <p>• 이메일: ${trainer.email}</p>
                                        <p>• 전화번호: ${trainer.phone}</p>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                                        <a href="${pageContext.request.contextPath}/matching/request?trainerId=${trainer.trainerId}" 
                                           class="btn btn-primary">
                                            <i class="bi bi-send"></i> 매칭 요청
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- 페이지네이션 -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Page navigation" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}&search=${param.search}&specialization=${param.specialization}&sort=${param.sort}">
                                        <i class="bi bi-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&search=${param.search}&specialization=${param.specialization}&sort=${param.sort}">
                                        ${i}
                                    </a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}&search=${param.search}&specialization=${param.specialization}&sort=${param.sort}">
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
                    <i class="bi bi-search" style="font-size: 80px; color: #ccc;"></i>
                    <h4 class="mt-4 text-muted">검색 결과가 없습니다</h4>
                    <p class="text-muted">다른 검색어로 다시 시도해보세요</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
