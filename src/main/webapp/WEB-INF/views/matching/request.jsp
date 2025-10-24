<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>매칭 요청 - HealthWeb</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 30px 0;
        }
        .request-container {
            max-width: 700px;
            margin: 0 auto;
        }
        .request-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        .card-header-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .trainer-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .trainer-img {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }
        .rating-badge {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
        }
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="request-container">
            <div class="request-card">
                <div class="card-header-custom">
                    <i class="bi bi-send-check" style="font-size: 50px;"></i>
                    <h2 class="mt-3">매칭 요청</h2>
                    <p class="mb-0">트레이너에게 매칭을 요청합니다</p>
                </div>

                <div class="p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- 트레이너 정보 -->
                    <div class="trainer-info">
                        <div class="row align-items-center">
                            <div class="col-auto text-center">
                                <c:choose>
                                    <c:when test="${not empty trainer.profileImage}">
                                        <img src="${pageContext.request.contextPath}/uploads/${trainer.profileImage}" 
                                             class="trainer-img" alt="트레이너">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://via.placeholder.com/100" class="trainer-img" alt="트레이너">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="col">
                                <h4 class="mb-2">${trainer.name} 트레이너</h4>
                                <p class="mb-1">
                                    <span class="rating-badge">
                                        <i class="bi bi-star-fill"></i> ${trainer.rating}
                                    </span>
                                    <span class="ms-2 text-muted">경력 ${trainer.experienceYears}년</span>
                                </p>
                                <p class="mb-1">
                                    <i class="bi bi-award text-primary"></i> ${trainer.certification}
                                </p>
                                <p class="mb-0">
                                    <i class="bi bi-tag text-success"></i> ${trainer.specialization}
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- 요청 폼 -->
                    <form action="${pageContext.request.contextPath}/matching/request" method="post" id="requestForm">
                        <input type="hidden" name="trainerId" value="${trainer.trainerId}">

                        <h5 class="mb-3"><i class="bi bi-calendar-range"></i> 트레이닝 기간 설정</h5>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="startDate" class="form-label">
                                    시작일 <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="startDate" name="startDate" required>
                                <small class="text-muted">오늘 날짜 이후로 선택해주세요</small>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label for="endDate" class="form-label">
                                    종료일 <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="endDate" name="endDate" required>
                                <small class="text-muted">시작일 이후로 선택해주세요</small>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">추천 기간 선택</label>
                            <div class="btn-group w-100" role="group">
                                <button type="button" class="btn btn-outline-primary" onclick="setPeriod(30)">
                                    1개월
                                </button>
                                <button type="button" class="btn btn-outline-primary" onclick="setPeriod(60)">
                                    2개월
                                </button>
                                <button type="button" class="btn btn-outline-primary" onclick="setPeriod(90)">
                                    3개월
                                </button>
                                <button type="button" class="btn btn-outline-primary" onclick="setPeriod(180)">
                                    6개월
                                </button>
                            </div>
                        </div>

                        <hr class="my-4">

                        <h5 class="mb-3"><i class="bi bi-chat-left-text"></i> 추가 메시지 (선택)</h5>
                        <div class="mb-3">
                            <textarea class="form-control" id="message" name="message" rows="5" 
                                      placeholder="트레이너에게 전달할 메시지를 입력하세요 (목표, 건강상태, 특이사항 등)"></textarea>
                            <small class="text-muted">더 나은 트레이닝을 위해 자세히 알려주세요</small>
                        </div>

                        <hr class="my-4">

                        <h5 class="mb-3"><i class="bi bi-person-lines-fill"></i> 내 정보 확인</h5>
                        <div class="mb-3 p-3" style="background-color: #f8f9fa; border-radius: 8px;">
                            <p class="mb-2"><strong>이름:</strong> ${user.name}</p>
                            <p class="mb-2"><strong>연락처:</strong> ${user.phone}</p>
                            <p class="mb-2"><strong>이메일:</strong> ${user.email}</p>
                            <p class="mb-2">
                                <strong>신체정보:</strong> 
                                ${user.weight}kg / ${user.height}cm
                            </p>
                            <p class="mb-0">
                                <strong>성별/나이:</strong> 
                                ${user.gender == 'M' ? '남성' : '여성'} / ${user.age}세
                            </p>
                        </div>

                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i>
                            <strong>알림:</strong> 매칭 요청 후 트레이너가 수락하면 트레이닝이 시작됩니다. 
                            트레이너의 승인을 기다려주세요.
                        </div>

                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="agreeTerms" required>
                            <label class="form-check-label" for="agreeTerms">
                                <a href="#" class="text-decoration-none">매칭 이용약관</a>에 동의합니다 
                                <span class="text-danger">*</span>
                            </label>
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-submit">
                                <i class="bi bi-send-check"></i> 매칭 요청 보내기
                            </button>
                            <a href="${pageContext.request.contextPath}/matching/trainer-list" 
                               class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> 목록으로 돌아가기
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 오늘 날짜 설정
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('startDate').setAttribute('min', today);
        
        // 시작일 변경 시 종료일 최소값 업데이트
        document.getElementById('startDate').addEventListener('change', function() {
            const startDate = this.value;
            document.getElementById('endDate').setAttribute('min', startDate);
            
            // 종료일이 시작일보다 이전이면 초기화
            const endDate = document.getElementById('endDate').value;
            if (endDate && endDate < startDate) {
                document.getElementById('endDate').value = '';
            }
        });

        // 기간 설정 함수
        function setPeriod(days) {
            const startDate = new Date();
            const endDate = new Date();
            endDate.setDate(startDate.getDate() + days);
            
            document.getElementById('startDate').value = startDate.toISOString().split('T')[0];
            document.getElementById('endDate').value = endDate.toISOString().split('T')[0];
        }

        // 폼 검증
        document.getElementById('requestForm').addEventListener('submit', function(e) {
            const startDate = new Date(document.getElementById('startDate').value);
            const endDate = new Date(document.getElementById('endDate').value);
            
            if (endDate <= startDate) {
                e.preventDefault();
                alert('종료일은 시작일 이후여야 합니다.');
                return false;
            }

            const daysDiff = (endDate - startDate) / (1000 * 60 * 60 * 24);
            if (daysDiff < 7) {
                e.preventDefault();
                alert('최소 1주일 이상의 기간을 설정해주세요.');
                return false;
            }

            if (!confirm('매칭 요청을 보내시겠습니까?')) {
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>
