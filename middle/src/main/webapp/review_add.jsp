<%@page import="com.member.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 로그인 & 권한(레벨 2 이상 또는 관리자) 확인
    MemberDTO loginUserObj = (MemberDTO) session.getAttribute("loginUser");
    if (loginUserObj == null || (loginUserObj.getUser_level() < 2 && loginUserObj.getUser_level() != 4)) {
%>
<script>
  alert('리뷰 작성은 레벨 2 이상부터 가능합니다.');
  location.href = '<%=request.getContextPath()%>/main.jsp';
</script>
<%
        return;
    }

    // 필수 파라미터
    String storeName = request.getParameter("storeName");
    String address   = request.getParameter("address");
    if (storeName == null || storeName.isBlank() || address == null || address.isBlank()) {
%>
<script>
  alert('가게 정보가 없습니다. 목록에서 다시 시도해주세요.');
  location.href = '<%=request.getContextPath()%>/main.jsp';
</script>
<%
        return;
    }

    request.setAttribute("storeName", storeName);
    request.setAttribute("address",   address);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>리뷰 입력 폼</title>
  <style>
    @font-face {
      font-family: 'Paperozi';
      src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/2408-3@1.0/Paperlogy-3Light.woff2') format('woff2');
      font-weight: 300; font-display: swap;
    }
    body { font-family:'Paperozi',sans-serif; background:#f8f8f8; display:flex; justify-content:center; align-items:center; min-height:100vh; margin:0; }
    .form-container { background:#fff; border:2px solid #ccc; padding:30px 40px; max-width:500px; width:100%; box-shadow:0 4px 8px rgba(0,0,0,.1); }
    h2 { text-align:center; margin-bottom:20px; }
    form { text-align:center; }
    form label { display:flex; justify-content:space-between; align-items:center; text-align:left; margin:10px 0 5px; font-weight:bold; }
    label span { font-size:.8em; color:gray; }
    .form-container input[type="text"],
    .form-container input[type="button"],
    .form-container textarea,
    p { width:100%; box-sizing:border-box; padding:8px; margin-top:5px; margin-bottom:15px; font-size:1rem; }
    .star-rating { unicode-bidi:bidi-override; font-size:2.2rem; display:inline-flex; flex-direction:row-reverse; justify-content:center; margin-top:10px; }
    .star-rating input[type="radio"] { display:none; }
    .star-rating label { color:#ccc; cursor:pointer; transition:color .2s; }
    .star-rating input:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label { color:gold; }
    .btn-container { margin-top:20px; }
    .btn-submit { background:#44444E; color:#fff; padding:10px 20px; border:none; border-radius:4px; font-size:14px; cursor:pointer; }
    .btn-submit:hover { background:#D3DAD9; color:#000; }
    .btn-reset { background:#7A7A73; color:#fff; padding:10px 20px; border:none; border-radius:4px; font-size:14px; margin-left:10px; cursor:pointer; }
    .btn-reset:hover { background:#44444E; }
    .tip { color:#666; font-size:.9rem; margin-top:-8px; margin-bottom:12px; text-align:left; }
  </style>
</head>
<body>
  <div class="form-container">
    <h2>리뷰 입력 폼</h2>

    <!-- ✅ ReviewServlet 매핑: /Review -->
    <form name="reviewInput" action="<%=request.getContextPath()%>/Review" method="post" enctype="multipart/form-data">
      <!-- 서버 사용 필드: userId / storeName / rating / reviewImg / content -->

      <!-- 로그인 사용자 ID (히든, EL) -->
      <input type="hidden" name="userId" value="${sessionScope.loginUser.id}">

      <label>식당명</label>
      <p>${storeName}</p>
      <input type="hidden" name="storeName" value="${storeName}">

      <label>주소 <span>(참고표시용)</span></label>
      <p>${address}</p>
      <!-- 주소는 review 테이블에 없으므로 전송하지 않음 -->

      <label>평점</label>
      <div class="star-rating">
        <input type="radio" id="star5" name="rating" value="5"><label for="star5">★</label>
        <input type="radio" id="star4" name="rating" value="4"><label for="star4">★</label>
        <input type="radio" id="star3" name="rating" value="3"><label for="star3">★</label>
        <input type="radio" id="star2" name="rating" value="2"><label for="star2">★</label>
        <input type="radio" id="star1" name="rating" value="1" required><label for="star1">★</label>
      </div>
      <div class="tip">* 별점을 선택하세요 (1~5). DB는 NUMBER(2,1)이라 이후 수정에서 4.5 같은 소수도 가능.</div>

      <hr>

      <label>사진 <span>(선택사항)</span></label>
      <!-- ✅ ReviewServlet에서 기대하는 파라미터명: reviewImg -->
      <input type="file" name="reviewImg" accept="image/*">

      <label>리뷰 내용 <span>(필수)</span></label>
      <textarea name="content" rows="5" minlength="2" maxlength="1000" required placeholder="가게의 장점/단점을 구체적으로 적어주세요."></textarea>

      <div class="btn-container">
        <input type="submit" class="btn-submit" value="리뷰 제출">
        <input type="reset" class="btn-reset" value="다시 작성">
      </div>
    </form>
  </div>
</body>
</html>
