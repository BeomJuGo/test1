<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>계획 작성 - HealthWeb</title>
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
        .plan-section {
            background: white;
            border-radius: 10px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .exercise-item, .diet-item {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background: #f8f9fa;
        }
        .btn-add {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
        }
        .btn-remove {
            background: #dc3545;
            border: none;
            color: white;
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/trainer/client-list">
                            <i class="bi bi-people"></i> 회원 관리
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
            <h2><i class="bi bi-calendar-plus"></i> 운동 & 식단 계획 작성</h2>
            <p class="mb-0">회원: <strong>${client.user.name}</strong>님</p>
        </div>
    </div>

    <div class="container mb-5">
        <form action="${pageContext.request.contextPath}/plan/create-plan" method="post" id="planForm">
            <input type="hidden" name="matchingId" value="${matchingId}">

            <!-- 날짜 선택 -->
            <div class="plan-section">
                <h5 class="mb-3"><i class="bi bi-calendar"></i> 계획 날짜</h5>
                <div class="row">
                    <div class="col-md-6">
                        <label class="form-label">날짜 선택 <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" name="planDate" id="planDate" 
                               value="${planDate}" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">회원 정보</label>
                        <div class="form-control-plaintext">
                            ${client.user.name} | ${client.user.weight}kg / ${client.user.height}cm
                        </div>
                    </div>
                </div>
            </div>

            <!-- 운동 계획 -->
            <div class="plan-section">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0"><i class="bi bi-dumbbell text-primary"></i> 운동 계획</h5>
                    <button type="button" class="btn btn-sm btn-add" onclick="addExercise()">
                        <i class="bi bi-plus-circle"></i> 운동 추가
                    </button>
                </div>

                <div id="exerciseContainer">
                    <!-- 운동 항목이 여기에 추가됩니다 -->
                </div>

                <div class="alert alert-info">
                    <i class="bi bi-info-circle"></i>
                    <strong>팁:</strong> 구체적인 운동 방법과 주의사항을 상세히 작성하면 회원의 이해도가 높아집니다.
                </div>
            </div>

            <!-- 식단 계획 -->
            <div class="plan-section">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="mb-0"><i class="bi bi-egg-fried text-success"></i> 식단 계획</h5>
                    <button type="button" class="btn btn-sm btn-add" onclick="addDiet()">
                        <i class="bi bi-plus-circle"></i> 식단 추가
                    </button>
                </div>

                <div id="dietContainer">
                    <!-- 식단 항목이 여기에 추가됩니다 -->
                </div>

                <div class="alert alert-success">
                    <i class="bi bi-info-circle"></i>
                    <strong>팁:</strong> 영양 정보를 정확히 입력하면 회원이 섭취 관리를 효과적으로 할 수 있습니다.
                </div>
            </div>

            <!-- 제출 버튼 -->
            <div class="text-center">
                <button type="submit" class="btn btn-primary btn-lg px-5">
                    <i class="bi bi-check-circle"></i> 계획 저장
                </button>
                <a href="${pageContext.request.contextPath}/trainer/client-list" class="btn btn-secondary btn-lg px-5">
                    <i class="bi bi-x-circle"></i> 취소
                </a>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let exerciseCount = 0;
        let dietCount = 0;

        // 운동 추가
        function addExercise() {
            exerciseCount++;
            const container = document.getElementById('exerciseContainer');
            const html = `
                <div class="exercise-item" id="exercise-\${exerciseCount}">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6>운동 \${exerciseCount}</h6>
                        <button type="button" class="btn btn-sm btn-remove" onclick="removeExercise(\${exerciseCount})">
                            <i class="bi bi-trash"></i> 삭제
                        </button>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">운동 이름 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="exercises[\${exerciseCount}].exerciseName" 
                                   placeholder="예: 스쿼트" required>
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label">세트</label>
                            <input type="number" class="form-control" name="exercises[\${exerciseCount}].sets" 
                                   placeholder="3" min="1">
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label">횟수</label>
                            <input type="number" class="form-control" name="exercises[\${exerciseCount}].reps" 
                                   placeholder="12" min="1">
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label">시간(분)</label>
                            <input type="number" class="form-control" name="exercises[\${exerciseCount}].duration" 
                                   placeholder="30" min="1">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <label class="form-label">칼로리 (kcal)</label>
                            <input type="number" class="form-control" name="exercises[\${exerciseCount}].calories" 
                                   placeholder="250" min="0">
                        </div>
                        <div class="col-md-9 mb-3">
                            <label class="form-label">상세 설명</label>
                            <textarea class="form-control" name="exercises[\${exerciseCount}].description" rows="2"
                                      placeholder="운동 방법, 자세 교정, 주의사항 등을 자세히 적어주세요"></textarea>
                        </div>
                    </div>
                </div>
            `;
            container.insertAdjacentHTML('beforeend', html);
        }

        // 운동 삭제
        function removeExercise(id) {
            const element = document.getElementById('exercise-' + id);
            if (element) {
                element.remove();
            }
        }

        // 식단 추가
        function addDiet() {
            dietCount++;
            const container = document.getElementById('dietContainer');
            const html = `
                <div class="diet-item" id="diet-\${dietCount}">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h6>식단 \${dietCount}</h6>
                        <button type="button" class="btn btn-sm btn-remove" onclick="removeDiet(\${dietCount})">
                            <i class="bi bi-trash"></i> 삭제
                        </button>
                    </div>

                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <label class="form-label">식사 시간 <span class="text-danger">*</span></label>
                            <select class="form-select" name="diets[\${dietCount}].mealType" required>
                                <option value="">선택</option>
                                <option value="BREAKFAST">아침</option>
                                <option value="LUNCH">점심</option>
                                <option value="DINNER">저녁</option>
                                <option value="SNACK">간식</option>
                            </select>
                        </div>
                        <div class="col-md-9 mb-3">
                            <label class="form-label">메뉴 이름 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="diets[\${dietCount}].mealName" 
                                   placeholder="예: 현미밥, 닭가슴살, 샐러드" required>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <label class="form-label">칼로리 (kcal)</label>
                            <input type="number" class="form-control" name="diets[\${dietCount}].calories" 
                                   placeholder="500" min="0">
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label">탄수화물 (g)</label>
                            <input type="number" step="0.1" class="form-control" name="diets[\${dietCount}].carbs" 
                                   placeholder="60.5" min="0">
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label">단백질 (g)</label>
                            <input type="number" step="0.1" class="form-control" name="diets[\${dietCount}].protein" 
                                   placeholder="30.5" min="0">
                        </div>
                        <div class="col-md-3 mb-3">
                            <label class="form-label">지방 (g)</label>
                            <input type="number" step="0.1" class="form-control" name="diets[\${dietCount}].fat" 
                                   placeholder="15.5" min="0">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">상세 설명</label>
                        <textarea class="form-control" name="diets[\${dietCount}].description" rows="2"
                                  placeholder="조리 방법, 영양 정보, 섭취 시 주의사항 등을 자세히 적어주세요"></textarea>
                    </div>
                </div>
            `;
            container.insertAdjacentHTML('beforeend', html);
        }

        // 식단 삭제
        function removeDiet(id) {
            const element = document.getElementById('diet-' + id);
            if (element) {
                element.remove();
            }
        }

        // 폼 검증
        document.getElementById('planForm').addEventListener('submit', function(e) {
            const exerciseContainer = document.getElementById('exerciseContainer');
            const dietContainer = document.getElementById('dietContainer');

            if (exerciseContainer.children.length === 0 && dietContainer.children.length === 0) {
                e.preventDefault();
                alert('최소 1개 이상의 운동 또는 식단 계획을 추가해주세요.');
                return false;
            }

            if (!confirm('계획을 저장하시겠습니까?')) {
                e.preventDefault();
                return false;
            }
        });

        // 오늘 날짜 기본값 설정
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('planDate');
            if (!dateInput.value) {
                dateInput.value = new Date().toISOString().split('T')[0];
            }

            // 초기에 운동 1개, 식단 1개 자동 추가
            addExercise();
            addDiet();
        });
    </script>
</body>
</html>
