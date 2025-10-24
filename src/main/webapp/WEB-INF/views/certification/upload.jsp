<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>인증 업로드 - HealthWeb</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 30px 0;
        }
        .upload-container {
            max-width: 600px;
            margin: 0 auto;
        }
        .upload-card {
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
        .image-preview {
            width: 100%;
            max-height: 400px;
            object-fit: contain;
            border-radius: 10px;
            margin: 20px 0;
            display: none;
        }
        .upload-area {
            border: 3px dashed #dee2e6;
            border-radius: 10px;
            padding: 40px;
            text-align: center;
            background: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s;
        }
        .upload-area:hover {
            border-color: #667eea;
            background: #e9ecef;
        }
        .upload-area.dragover {
            border-color: #667eea;
            background: #e7f0ff;
        }
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 40px;
            font-weight: bold;
        }
        .plan-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="upload-container">
            <div class="upload-card">
                <div class="card-header-custom">
                    <i class="bi bi-camera-fill" style="font-size: 50px;"></i>
                    <h2 class="mt-3">
                        <c:choose>
                            <c:when test="${type == 'exercise'}">
                                <i class="bi bi-dumbbell"></i> 운동 인증
                            </c:when>
                            <c:otherwise>
                                <i class="bi bi-egg-fried"></i> 식단 인증
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <p class="mb-0">사진을 업로드하고 피드백을 받아보세요</p>
                </div>

                <div class="p-4">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- 계획 정보 -->
                    <div class="plan-info">
                        <h5 class="mb-3">
                            <c:choose>
                                <c:when test="${type == 'exercise'}">
                                    <i class="bi bi-clipboard-check"></i> 운동 정보
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-clipboard-check"></i> 식단 정보
                                </c:otherwise>
                            </c:choose>
                        </h5>
                        <c:choose>
                            <c:when test="${type == 'exercise'}">
                                <p class="mb-1"><strong>운동명:</strong> ${plan.exerciseName}</p>
                                <p class="mb-1"><strong>세트/횟수:</strong> ${plan.sets}세트 × ${plan.reps}회</p>
                                <p class="mb-1"><strong>시간:</strong> ${plan.duration}분</p>
                                <p class="mb-0"><strong>목표 칼로리:</strong> ${plan.calories}kcal</p>
                            </c:when>
                            <c:otherwise>
                                <p class="mb-1"><strong>식사:</strong> 
                                    <c:choose>
                                        <c:when test="${plan.mealType == 'BREAKFAST'}">아침</c:when>
                                        <c:when test="${plan.mealType == 'LUNCH'}">점심</c:when>
                                        <c:when test="${plan.mealType == 'DINNER'}">저녁</c:when>
                                        <c:otherwise>간식</c:otherwise>
                                    </c:choose>
                                    - ${plan.mealName}
                                </p>
                                <p class="mb-1"><strong>칼로리:</strong> ${plan.calories}kcal</p>
                                <p class="mb-0"><strong>영양소:</strong> 
                                    탄수화물 ${plan.carbs}g | 단백질 ${plan.protein}g | 지방 ${plan.fat}g
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- 업로드 폼 -->
                    <form action="${pageContext.request.contextPath}/certification/upload" 
                          method="post" enctype="multipart/form-data" id="uploadForm">
                        <input type="hidden" name="type" value="${type}">
                        <input type="hidden" name="planId" value="${planId}">

                        <!-- 이미지 업로드 영역 -->
                        <div class="upload-area" id="uploadArea" onclick="document.getElementById('imageFile').click()">
                            <i class="bi bi-cloud-upload" style="font-size: 60px; color: #667eea;"></i>
                            <h5 class="mt-3">사진을 업로드하세요</h5>
                            <p class="text-muted mb-0">클릭하거나 드래그 앤 드롭</p>
                            <small class="text-muted">JPG, PNG, GIF (최대 10MB)</small>
                        </div>

                        <input type="file" class="d-none" id="imageFile" name="imageFile" 
                               accept="image/*" required>

                        <!-- 이미지 미리보기 -->
                        <img id="imagePreview" class="image-preview" alt="미리보기">

                        <!-- 코멘트 -->
                        <div class="mb-3 mt-4">
                            <label for="comment" class="form-label">
                                <i class="bi bi-chat-left-text"></i> 코멘트 (선택)
                            </label>
                            <textarea class="form-control" id="comment" name="comment" rows="4"
                                      placeholder="오늘의 운동/식사에 대한 소감을 남겨주세요"></textarea>
                        </div>

                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i>
                            <strong>안내:</strong> 업로드된 사진은 트레이너가 확인하고 피드백을 남깁니다.
                        </div>

                        <!-- 제출 버튼 -->
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-submit" id="submitBtn" disabled>
                                <i class="bi bi-check-circle"></i> 인증 완료
                            </button>
                            <a href="${pageContext.request.contextPath}/plan/daily-plan" 
                               class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> 돌아가기
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const uploadArea = document.getElementById('uploadArea');
        const imageFile = document.getElementById('imageFile');
        const imagePreview = document.getElementById('imagePreview');
        const submitBtn = document.getElementById('submitBtn');

        // 파일 선택 시 미리보기
        imageFile.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                // 파일 크기 체크 (10MB)
                if (file.size > 10 * 1024 * 1024) {
                    alert('파일 크기는 10MB를 초과할 수 없습니다.');
                    imageFile.value = '';
                    return;
                }

                // 이미지 파일 체크
                if (!file.type.startsWith('image/')) {
                    alert('이미지 파일만 업로드 가능합니다.');
                    imageFile.value = '';
                    return;
                }

                // 미리보기 표시
                const reader = new FileReader();
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    imagePreview.style.display = 'block';
                    uploadArea.style.display = 'none';
                    submitBtn.disabled = false;
                };
                reader.readAsDataURL(file);
            }
        });

        // 드래그 앤 드롭
        uploadArea.addEventListener('dragover', function(e) {
            e.preventDefault();
            uploadArea.classList.add('dragover');
        });

        uploadArea.addEventListener('dragleave', function(e) {
            uploadArea.classList.remove('dragover');
        });

        uploadArea.addEventListener('drop', function(e) {
            e.preventDefault();
            uploadArea.classList.remove('dragover');

            const files = e.dataTransfer.files;
            if (files.length > 0) {
                imageFile.files = files;
                imageFile.dispatchEvent(new Event('change'));
            }
        });

        // 이미지 클릭 시 파일 재선택
        imagePreview.addEventListener('click', function() {
            if (confirm('다른 사진을 선택하시겠습니까?')) {
                imageFile.value = '';
                imagePreview.style.display = 'none';
                uploadArea.style.display = 'block';
                submitBtn.disabled = true;
            }
        });

        // 폼 검증
        document.getElementById('uploadForm').addEventListener('submit', function(e) {
            if (!imageFile.files || imageFile.files.length === 0) {
                e.preventDefault();
                alert('사진을 업로드해주세요.');
                return false;
            }

            if (!confirm('인증을 완료하시겠습니까?')) {
                e.preventDefault();
                return false;
            }

            // 제출 중 중복 클릭 방지
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>업로드 중...';
        });
    </script>
</body>
</html>
