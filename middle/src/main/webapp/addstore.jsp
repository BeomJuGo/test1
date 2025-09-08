<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%
    String ctx = request.getContextPath();
    Object loginUser = session.getAttribute("loginUser");
    Integer userLevel = (Integer) session.getAttribute("userLevel"); // 세션에 로그인 시 저장했다고 가정

    if (loginUser == null || userLevel == null || userLevel != 1) {
        response.sendRedirect(ctx + "/main.jsp"); // 일반회원 접근 불가
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>가게 등록</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex justify-center items-center min-h-screen bg-gray-100">
    <div class="bg-white p-8 border-2 border-black rounded-lg shadow-lg w-96">
        <h2 class="text-xl font-bold mb-6 text-center">가게 등록</h2>
        <form action="<%=ctx%>/AddStore" method="post" class="space-y-4">
            <div>
                <label class="block mb-1">가게 이름</label>
                <input type="text" name="name" required class="w-full px-3 py-2 border-2 border-black">
            </div>
            <div>
                <label class="block mb-1">주소</label>
                <input type="text" name="adress" required class="w-full px-3 py-2 border-2 border-black">
            </div>
            <div>
                <label class="block mb-1">리뷰</label>
                <textarea name="review" class="w-full px-3 py-2 border-2 border-black" rows="4"></textarea>
            </div>
            <div>
                <label class="block mb-1">평점 (1~5)</label>
                <input type="number" name="rating" min="1" max="5" required class="w-full px-3 py-2 border-2 border-black">
            </div>
            <div>
                <label class="block mb-1">이미지 URL</label>
                <input type="text" name="store_img" class="w-full px-3 py-2 border-2 border-black">
            </div>
            <button type="submit" class="w-full py-2 bg-black text-white border-2 border-black hover:bg-gray-800">
                등록
            </button>
        </form>
    </div>
</body>
</html>
