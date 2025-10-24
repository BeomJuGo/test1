// Health Web Application - Main JavaScript

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    console.log('Health Web Application Initialized');
    
    // 알림 메시지 자동 숨기기
    hideAlertMessages();
    
    // 폼 검증
    setupFormValidation();
    
    // 이미지 미리보기
    setupImagePreview();
});

/**
 * 알림 메시지 자동 숨기기 (3초 후)
 */
function hideAlertMessages() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.opacity = '0';
            setTimeout(() => alert.remove(), 500);
        }, 3000);
    });
}

/**
 * 폼 검증 설정
 */
function setupFormValidation() {
    const forms = document.querySelectorAll('form[data-validate]');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!validateForm(this)) {
                e.preventDefault();
            }
        });
    });
}

/**
 * 폼 검증 함수
 */
function validateForm(form) {
    const requiredFields = form.querySelectorAll('[required]');
    let isValid = true;
    
    requiredFields.forEach(field => {
        if (!field.value.trim()) {
            showError(field, '이 필드는 필수입니다.');
            isValid = false;
        } else {
            clearError(field);
        }
    });
    
    // 이메일 검증
    const emailFields = form.querySelectorAll('input[type="email"]');
    emailFields.forEach(field => {
        if (field.value && !isValidEmail(field.value)) {
            showError(field, '유효한 이메일 주소를 입력하세요.');
            isValid = false;
        }
    });
    
    // 비밀번호 검증
    const passwordFields = form.querySelectorAll('input[name="password"]');
    const confirmFields = form.querySelectorAll('input[name="confirmPassword"]');
    
    if (passwordFields.length > 0 && confirmFields.length > 0) {
        if (passwordFields[0].value !== confirmFields[0].value) {
            showError(confirmFields[0], '비밀번호가 일치하지 않습니다.');
            isValid = false;
        }
    }
    
    return isValid;
}

/**
 * 이메일 유효성 검사
 */
function isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

/**
 * 에러 메시지 표시
 */
function showError(field, message) {
    clearError(field);
    
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.style.color = 'red';
    errorDiv.style.fontSize = '0.9rem';
    errorDiv.style.marginTop = '5px';
    errorDiv.textContent = message;
    
    field.style.borderColor = 'red';
    field.parentElement.appendChild(errorDiv);
}

/**
 * 에러 메시지 제거
 */
function clearError(field) {
    const errorDiv = field.parentElement.querySelector('.error-message');
    if (errorDiv) {
        errorDiv.remove();
    }
    field.style.borderColor = '';
}

/**
 * 이미지 미리보기 설정
 */
function setupImagePreview() {
    const imageInputs = document.querySelectorAll('input[type="file"][accept*="image"]');
    
    imageInputs.forEach(input => {
        input.addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    // 미리보기 영역 찾기 또는 생성
                    let preview = input.parentElement.querySelector('.image-preview');
                    if (!preview) {
                        preview = document.createElement('img');
                        preview.className = 'image-preview';
                        preview.style.maxWidth = '300px';
                        preview.style.marginTop = '10px';
                        preview.style.borderRadius = '5px';
                        input.parentElement.appendChild(preview);
                    }
                    preview.src = event.target.result;
                };
                reader.readAsDataURL(file);
            }
        });
    });
}

/**
 * 날짜 포맷팅
 */
function formatDate(date) {
    const d = new Date(date);
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

/**
 * 확인 다이얼로그
 */
function confirmAction(message) {
    return confirm(message);
}

/**
 * AJAX 요청 헬퍼 함수
 */
function sendAjaxRequest(url, method, data, callback) {
    const xhr = new XMLHttpRequest();
    xhr.open(method, url, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    
    xhr.onload = function() {
        if (xhr.status >= 200 && xhr.status < 300) {
            callback(null, JSON.parse(xhr.responseText));
        } else {
            callback(new Error('Request failed'), null);
        }
    };
    
    xhr.onerror = function() {
        callback(new Error('Network error'), null);
    };
    
    xhr.send(JSON.stringify(data));
}

/**
 * 로딩 스피너 표시
 */
function showLoading() {
    const spinner = document.createElement('div');
    spinner.id = 'loading-spinner';
    spinner.innerHTML = '<div class="spinner"></div>';
    spinner.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999;
    `;
    document.body.appendChild(spinner);
}

/**
 * 로딩 스피너 숨기기
 */
function hideLoading() {
    const spinner = document.getElementById('loading-spinner');
    if (spinner) {
        spinner.remove();
    }
}

// 유틸리티 함수들을 전역으로 export
window.HealthApp = {
    formatDate,
    confirmAction,
    sendAjaxRequest,
    showLoading,
    hideLoading,
    showError,
    clearError
};
