<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 로그인 확인: loginUser 없으면 로그인 페이지로
    Object loginUser = session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // storeName/address 파라미터 기본값
    String storeName = request.getParameter("storeName");
    String address   = request.getParameter("address");
    if (storeName == null || storeName.trim().length() == 0) storeName = "테스트 식당";
    if (address   == null || address.trim().length()   == 0) address   = "서울시 테스트구 123";

    // 로그인 객체에서 id 꺼내기 (loginUser가 UserInfoVO 등이라면 getId() 보유 가정)
    // EL로도 접근 가능하지만 여기선 히든 필드 값 만들려고 꺼내둠
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
      font-weight: 300;
      font-display: swap;
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

    <!-- action 경로는 프로젝트 서블릿 매핑에 맞게 사용하세요.
         예) review 등록 서블릿이 /Review 인 경우 그대로 사용 -->
    <form name="reviewInput" action="<%=request.getContextPath()%>/Review" method="post" enctype="multipart/form-data">
      <!-- 서버에서 사용할 필드: userId / storeName / rating / reviewImg / content -->

      <!-- 로그인 사용자 ID (히든) : EL로 추출 -->
      <input type="hidden" name="userId" value="${sessionScope.loginUser.id}">

      <label>식당명</label>
      <p><%= storeName %></p>
      <input type="hidden" name="storeName" value="<%= storeName %>">

      <label>주소 <span>(참고표시용)</span></label>
      <p><%= address %></p>
      <!-- 주소는 review 테이블에 없으므로 전송 생략 -->

      <label>평점</label>
      <div class="star-rating">
        <input type="radio" id="star5" name="rating" value="5"><label for="star5">★</label>
        <input type="radio" id="star4" name="rating" value="4"><label for="star4">★</label>
        <input type="radio" id="star3" name="rating" value="3"><label for="star3">★</label>
        <input type="radio" id="star2" name="rating" value="2"><label for="star2">★</label>
        <input type="radio" id="star1" name="rating" value="1" required><label for="star1">★</label>
      </div>
      <div class="tip">* 별점을 선택하세요 (1~5). 소수점 평점은 이후 수정 화면에서 지원 가능.</div>

      <hr>

      <label>사진 <span>(선택사항)</span></label>
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
