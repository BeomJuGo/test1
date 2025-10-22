<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>USER Dashboard Prototype</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Permanent+Marker&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
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
    </style>
  </head>
  <body class="min-h-screen flex items-center justify-center">
    <div class="w-full max-w-5xl min-h-[95vh] bg-white rounded-xl border border-gray-300 shadow-lg p-6 flex flex-col gap-6">
      <!-- Header -->
      <div class="flex flex-col md:flex-row md:items-start md:justify-between gap-4">
        <!-- Profile Info -->
        <div class="flex items-center gap-5">
          <div class="w-16 h-16 rounded-full border-4 border-indigo-200 bg-gray-200 profile-pic flex items-center justify-center overflow-hidden">
            <img src="https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?auto=format&fit=facearea&w=128&q=80&facepad=2" alt="Profile" class="w-full h-full object-cover"/>
          </div>
          <div>
            <div class="flex items-end gap-2">
              <span class="marker text-3xl md:text-4xl text-gray-800">"USER" 님</span>
              <div class="flex flex-col ml-2">
                <span class="marker text-lg md:text-xl text-gray-700 leading-none">00 KG</span>
                <span class="marker text-base md:text-lg text-gray-700 leading-none">000 CM</span>
              </div>
            </div>
          </div>
        </div>
        <!-- Actions -->
        <div class="flex flex-col md:flex-row gap-2 md:gap-3 mt-2 md:mt-0">
          <button class="btn px-6 py-2 border border-gray-400 rounded-md bg-white hover:bg-indigo-50 text-gray-800 font-semibold text-lg transition">로그인</button>
          <button class="btn px-6 py-2 border border-gray-400 rounded-md bg-white hover:bg-indigo-50 text-gray-800 font-semibold text-lg transition">회원가입</button>
          <button class="btn px-6 py-2 border border-gray-400 rounded-md bg-white hover:bg-indigo-50 text-gray-800 font-medium text-base transition">커뮤니티</button>
        </div>
      </div>
      <!-- Main Content Area -->
      <div class="main-content flex-1 rounded-lg border border-gray-300 mt-2 mb-2 p-6 flex items-center justify-center min-h-[260px]">
        <div class="w-full h-56 md:h-64 flex items-center justify-center">
          <span class="text-gray-400 text-2xl font-semibold">메인 콘텐츠 영역</span>
        </div>
      </div>
      <!-- Cards Section -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 w-full">
          <div class="card bg-white border border-gray-300 rounded-lg p-6 flex items-center justify-center min-h-[100px]">
            <span class="text-gray-500 text-lg font-medium">카드 1</span>
          </div>
          <div class="card bg-white border border-gray-300 rounded-lg p-6 flex items-center justify-center min-h-[100px]">
            <span class="text-gray-500 text-lg font-medium">카드 2</span>
          </div>
          <div class="card bg-white border border-gray-300 rounded-lg p-6 flex items-center justify-center min-h-[100px]">
            <span class="text-gray-500 text-lg font-medium">카드 3</span>
          </div>
          <div class="card bg-white border border-gray-300 rounded-lg p-6 flex items-center justify-center min-h-[100px]">
            <span class="text-gray-500 text-lg font-medium">카드 4</span>
          </div>
        </div>
      </div>
    </div>
    <script type="module">
      // Example: Add interactivity for login/signup/community
      document.querySelectorAll('.btn').forEach(btn => {
        btn.addEventListener('click', e => {
          const text = e.target.textContent.trim();
          if (text === '로그인') {
            alert('로그인 기능은 곧 제공됩니다!');
          } else if (text === '회원가입') {
            alert('회원가입 기능은 곧 제공됩니다!');
          } else if (text === '커뮤니티') {
            alert('커뮤니티로 이동합니다!');
          }
        });
      });
    </script>
  </body>
</html>