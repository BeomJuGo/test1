<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>HealthWeb Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Permanent+Marker&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.css' rel='stylesheet' />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
      body {
        font-family: 'Roboto', sans-serif;
        background: #f7f8fa;
      }
      .marker {
        font-family: 'Permanent Marker', cursive;
      }
      .profile-pic {
        background: linear-gradient(135deg, #e0e7ff 0%, #f9fafb 100%);
        object-fit: cover;
      }
      .card {
        transition: box-shadow 0.2s, transform 0.2s;
      }
      .card:hover {
        box-shadow: 0 8px 24px 0 rgba(0,0,0,0.08);
        transform: translateY(-2px) scale(1.02);
      }
      .main-content {
        background: linear-gradient(120deg, #f1f5f9 60%, #e0e7ff 100%);
      }
      .btn {
        transition: background 0.15s, color 0.15s, box-shadow 0.15s;
      }
      .btn:active {
        box-shadow: 0 2px 8px 0 rgba(0,0,0,0.08);
      }
      #calendar {
        max-width: 100%;
        background: white;
        border-radius: 8px;
        padding: 10px;
      }
      .fc-event-main {
        font-size: 0.85rem;
      }
      .fc .fc-toolbar-title {
        font-size: 1.5rem;
        font-weight: 600;
        color: #1f2937;
      }
      .fc-button-primary {
        background-color: #6366f1 !important;
        border-color: #6366f1 !important;
      }
      .fc-button-primary:hover {
        background-color: #4f46e5 !important;
        border-color: #4f46e5 !important;
      }
      
      /* Modal Styles */
      .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0,0,0,0.5);
      }
      .modal-content {
        background-color: #fefefe;
        margin: 5% auto;
        padding: 30px;
        border: 1px solid #888;
        border-radius: 12px;
        width: 90%;
        max-width: 600px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }
      .close {
        color: #aaa;
        float: right;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
      }
      .close:hover,
      .close:focus {
        color: #000;
      }
      .plan-item {
        background: #f8f9fa;
        padding: 15px;
        margin-bottom: 10px;
        border-radius: 8px;
        border-left: 4px solid #6366f1;
      }
      .upload-area {
        border: 2px dashed #cbd5e0;
        border-radius: 8px;
        padding: 20px;
        text-align: center;
        cursor: pointer;
        transition: all 0.3s;
      }
      .upload-area:hover {
        border-color: #6366f1;
        background-color: #f7fafc;
      }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center">
  <div class="w-full max-w-5xl min-h-[95vh] bg-white rounded-xl border border-gray-300 shadow-lg p-6 flex flex-col gap-6">
    <!-- Header -->
    <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
      <div class="flex items-center gap-5">
        <div class="w-16 h-16 rounded-full border-4 border-indigo-200 bg-gray-200 profile-pic flex items-center justify-center overflow-hidden">
          <img src="https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=facearea&w=128&q=80&facepad=2" alt="Profile" class="w-full h-full object-cover"/>
        </div>
        <div>
          <div class="flex items-end gap-2">
            <span class="marker text-3xl md:text-4xl text-gray-800" id="userName">"USER" 님</span>
            <div class="flex flex-col ml-2">
              <span class="marker text-lg md:text-xl text-gray-700 leading-none" id="userWeight">00 KG</span>
              <span class="marker text-base md:text-lg text-gray-700 leading-none" id="userHeight">000 CM</span>
            </div>
          </div>
        </div>
      </div>
      <div class="flex flex-col md:flex-row gap-2 md:gap-3 mt-2 md:mt-0">
        <button class="btn px-6 py-2 border border-gray-400 rounded-md bg-white hover:bg-indigo-50 text-gray-800 font-semibold text-lg transition" onclick="location.href='<%= request.getContextPath() %>/user/login'">로그인</button>
        <button class="btn px-6 py-2 border border-gray-400 rounded-md bg-white hover:bg-indigo-50 text-gray-800 font-semibold text-lg transition" onclick="location.href='<%= request.getContextPath() %>/user/register'">회원가입</button>
        <button class="btn px-6 py-2 border border-gray-400 rounded-md bg-white hover:bg-indigo-50 text-gray-800 font-medium text-base transition">커뮤니티</button>
      </div>
    </div>
    
    <!-- Calendar -->
    <div class="main-content flex-1 rounded-lg border border-gray-300 mt-2 mb-2 p-6 min-h-[260px]">
      <div id="calendar" class="w-full"></div>
    </div>
    
    <!-- Cards Section -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 w-full">
        <div class="card bg-white border border-gray-300 rounded-lg p-6 flex items-center justify-center min-h-[100px]">
          <span class="text-gray-500 text-lg font-medium">오늘의 운동</span>
        </div>
        <div class="card bg-white border border-gray-300 rounded-lg p-6 flex items-center justify-center min-h-[100px]">
          <span class="text-gray-500 text-lg font-medium">오늘의 식단</span>
        </div>
        <div class="card bg-white border border-gray-300 rounded-lg p-6 flex items-center justify-center min-h-[100px]">
          <span class="text-gray-500 text-lg font-medium">진행률</span>
        </div>
        <div class="card bg-white border border-gray-300 rounded-lg p-6 flex items-center justify-center min-h-[100px]">
          <span class="text-gray-500 text-lg font-medium">통계</span>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal for Daily Plan -->
  <div id="planModal" class="modal">
    <div class="modal-content">
      <span class="close">&times;</span>
      <h2 class="text-2xl font-bold mb-4" id="modalDate"></h2>
      
      <!-- Exercise Plans -->
      <div class="mb-6">
        <h3 class="text-xl font-semibold mb-3 text-indigo-600">🏃 운동 계획</h3>
        <div id="exercisePlans"></div>
      </div>
      
      <!-- Diet Plans -->
      <div class="mb-6">
        <h3 class="text-xl font-semibold mb-3 text-blue-600">🥗 식단 계획</h3>
        <div id="dietPlans"></div>
      </div>
      
      <!-- Upload Certification -->
      <div class="mb-4">
        <h3 class="text-xl font-semibold mb-3 text-green-600">📸 인증 사진 업로드</h3>
        <div class="upload-area" onclick="document.getElementById('certificationFile').click()">
          <input type="file" id="certificationFile" style="display: none;" accept="image/*" onchange="uploadCertification(this)">
          <p class="text-gray-600">클릭하여 인증 사진 업로드</p>
        </div>
      </div>
    </div>
  </div>

  <!-- FullCalendar JS -->
  <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.10/index.global.min.js'></script>
  
  <script>
    let calendar;
    const contextPath = '<%= request.getContextPath() %>';
    
    document.addEventListener('DOMContentLoaded', function() {
      var calendarEl = document.getElementById('calendar');
      calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        locale: 'ko',
        headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,timeGridWeek,timeGridDay'
        },
        buttonText: {
          today: '오늘',
          month: '월',
          week: '주',
          day: '일'
        },
        events: function(info, successCallback, failureCallback) {
          // 서버에서 계획 데이터 가져오기
          $.ajax({
            url: contextPath + '/plan/calendar',
            method: 'GET',
            data: {
              startDate: info.startStr.split('T')[0],
              endDate: info.endStr.split('T')[0]
            },
            success: function(response) {
              if (response.success) {
                successCallback(response.events);
              } else {
                console.error('Failed to load plans:', response.message);
                successCallback([]);
              }
            },
            error: function(xhr, status, error) {
              console.error('Error loading plans:', error);
              successCallback([]);
            }
          });
        },
        dateClick: function(info) {
          openDailyPlanModal(info.dateStr);
        },
        eventClick: function(info) {
          openDailyPlanModal(info.event.startStr.split('T')[0]);
        },
        height: 'auto',
        aspectRatio: 2
      });
      calendar.render();
      
      // Modal close button
      document.querySelector('.close').onclick = function() {
        document.getElementById('planModal').style.display = 'none';
      }
      
      // Click outside to close
      window.onclick = function(event) {
        if (event.target == document.getElementById('planModal')) {
          document.getElementById('planModal').style.display = 'none';
        }
      }
    });
    
    // 날짜별 계획 모달 열기
    function openDailyPlanModal(dateStr) {
      $.ajax({
        url: contextPath + '/plan/daily',
        method: 'GET',
        data: { date: dateStr },
        success: function(response) {
          if (response.success) {
            displayDailyPlan(dateStr, response.data);
          } else {
            alert(response.message);
          }
        },
        error: function(xhr, status, error) {
          if (xhr.status === 401) {
            alert('로그인이 필요합니다.');
            location.href = contextPath + '/user/login';
          } else {
            alert('오류가 발생했습니다.');
          }
        }
      });
    }
    
    // 일일 계획 표시
    function displayDailyPlan(date, data) {
      document.getElementById('modalDate').textContent = date + ' 계획';
      
      // 운동 계획
      const exercisePlansDiv = document.getElementById('exercisePlans');
      if (data.exercisePlans && data.exercisePlans.length > 0) {
        exercisePlansDiv.innerHTML = data.exercisePlans.map(plan => `
          <div class="plan-item">
            <h4 class="font-bold text-lg">\${plan.exerciseName}</h4>
            <p class="text-gray-600">\${plan.sets} 세트 × \${plan.reps} 회 | \${plan.duration}분 | \${plan.calories} kcal</p>
            \${plan.description ? '<p class="text-sm text-gray-500 mt-1">' + plan.description + '</p>' : ''}
          </div>
        `).join('');
      } else {
        exercisePlansDiv.innerHTML = '<p class="text-gray-500">등록된 운동 계획이 없습니다.</p>';
      }
      
      // 식단 계획
      const dietPlansDiv = document.getElementById('dietPlans');
      if (data.dietPlans && data.dietPlans.length > 0) {
        dietPlansDiv.innerHTML = data.dietPlans.map(plan => `
          <div class="plan-item">
            <h4 class="font-bold text-lg">\${getMealTypeText(plan.mealType)} - \${plan.mealName}</h4>
            <p class="text-gray-600">\${plan.calories} kcal | 단백질: \${plan.protein}g | 탄수화물: \${plan.carbs}g | 지방: \${plan.fat}g</p>
            \${plan.description ? '<p class="text-sm text-gray-500 mt-1">' + plan.description + '</p>' : ''}
          </div>
        `).join('');
      } else {
        dietPlansDiv.innerHTML = '<p class="text-gray-500">등록된 식단 계획이 없습니다.</p>';
      }
      
      document.getElementById('planModal').style.display = 'block';
    }
    
    function getMealTypeText(type) {
      const types = {
        'BREAKFAST': '아침',
        'LUNCH': '점심',
        'DINNER': '저녁',
        'SNACK': '간식'
      };
      return types[type] || type;
    }
    
    // 인증 사진 업로드
    function uploadCertification(input) {
      if (input.files && input.files[0]) {
        const formData = new FormData();
        formData.append('file', input.files[0]);
        
        // TODO: 서버에 업로드 구현
        alert('인증 사진 업로드 기능은 곧 구현됩니다!');
        
        /* 실제 구현 예시:
        $.ajax({
          url: contextPath + '/certification/upload',
          method: 'POST',
          data: formData,
          processData: false,
          contentType: false,
          success: function(response) {
            alert('업로드 완료!');
            calendar.refetchEvents();
          }
        });
        */
      }
    }
  </script>
</body>
</html>
