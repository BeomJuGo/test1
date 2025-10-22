<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>User Gallery</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts: 'Gugi' for playful Korean, 'Inter' for UI -->
    <link href="https://fonts.googleapis.com/css2?family=Gugi&family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <style>
      body {
        font-family: 'Inter', sans-serif;
        background: #f7f8fa;
      }
      .gugi {
        font-family: 'Gugi', cursive;
      }
      /* Custom scrollbar for gallery */
      ::-webkit-scrollbar {
        width: 8px;
        background: #e5e7eb;
      }
      ::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 4px;
      }
    </style>
  </head>
  <body class="min-h-screen flex items-center justify-center bg-gray-100">
    <div class="w-full max-w-5xl min-h-[90vh] bg-white border border-gray-400 rounded-xl shadow-lg p-8 flex flex-col justify-between">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8">
        <div class="flex items-center gap-2">
          <span class="gugi text-3xl text-gray-800">"USER"</span>
          <span class="text-2xl text-gray-700 font-semibold">님</span>
        </div>
        <div class="flex gap-3">
          <button id="sort-latest" class="sort-btn px-4 py-2 border border-gray-400 rounded-md bg-white text-gray-700 hover:bg-gray-100 transition font-medium" data-sort="latest">최신순</button>
          <button id="sort-popular" class="sort-btn px-4 py-2 border border-gray-400 rounded-md bg-white text-gray-700 hover:bg-gray-100 transition font-medium" data-sort="popular">인기순</button>
          <button id="sort-views" class="sort-btn px-4 py-2 border border-gray-400 rounded-md bg-white text-gray-700 hover:bg-gray-100 transition font-medium" data-sort="views">조회수순</button>
        </div>
      </div>
      <!-- Gallery Grid -->
      <div id="gallery" class="grid grid-cols-1 sm:grid-cols-2 gap-8 flex-1 mb-8">
        <!-- Cards will be injected here -->
      </div>
      <!-- Footer -->
      <div class="flex items-center justify-between mt-4">
        <div class="flex-1 flex items-center justify-center gap-4 text-gray-600 text-lg font-semibold">
          <button id="prev-page" class="px-2 py-1 rounded hover:bg-gray-200 transition disabled:opacity-40" aria-label="Previous page">&larr;</button>
          <span id="page-indicator" class="gugi">1 page</span>
          <button id="next-page" class="px-2 py-1 rounded hover:bg-gray-200 transition disabled:opacity-40" aria-label="Next page">&rarr;</button>
        </div>
        <button id="write-btn" class="px-6 py-2 border border-gray-400 rounded-md bg-white text-gray-700 hover:bg-blue-50 hover:border-blue-400 transition font-semibold text-lg">글쓰기</button>
      </div>
    </div>
    <!-- Write Modal -->
    <div id="modal-bg" class="fixed inset-0 bg-black/30 z-40 hidden items-center justify-center">
      <div class="bg-white rounded-xl shadow-2xl p-8 w-full max-w-md flex flex-col gap-4 relative">
        <button id="close-modal" class="absolute top-3 right-3 text-gray-400 hover:text-gray-700 text-2xl">&times;</button>
