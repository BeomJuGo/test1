<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"
    import="java.util.List,com.review.*"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%
    String ctx = request.getContextPath();
    com.member.MemberDTO loginUser = (com.member.MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    String userId = loginUser.getId(); // MemberDTO에 getId()가 있다고 가정
    List<ReviewDTO> myReviews = ReviewDAO.getInstance().findByUser(userId);
    request.setAttribute("myReviews", myReviews);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지 - 나의 리뷰</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
  body{font-family:system-ui,Segoe UI,Arial; background:#fafafa; margin:0}
  /* 마이페이지 썸네일도 동일 규격 적용 */
.review-img{
  width: 180px;
  aspect-ratio: 1 / 1;
  height: auto;
  object-fit: cover;
  border: 1px solid #0001;
  border-radius: 6px;
  display: block;
}
  
  .wrap{max-width:900px;margin:24px auto;padding:16px}
  .header{display:flex;align-items:center;justify-content:space-between;margin-bottom:16px}
  .btn{border:1px solid #000;background:#fff;padding:.5rem .9rem;cursor:pointer;text-decoration:none;color:#000}
  .card{background:#fff;border:2px solid #000;padding:16px;margin-bottom:12px}
  .meta{font-size:.9rem;color:#555;margin-bottom:8px}
  .rating{font-weight:700;color:#ff9800}
  .content{white-space:pre-wrap;word-break:break-word;margin:8px 0}
  .thumb{max-width:180px;height:auto;border:1px solid #0001;border-radius:6px}
  .right{display:flex;gap:8px}
  .title{font-weight:700;font-size:1.1rem}
  .empty{padding:32px;text-align:center;color:#777;border:2px dashed #aaa;background:#fff}
</style>
</head>
<body>
<div class="wrap">
  <div class="header">
    <div class="title">안녕하세요, <strong><c:out value="${sessionScope.loginUser.user_name}"/></strong> 님</div>
    <div class="right">
      <a class="btn" href="<%=ctx%>/main.jsp">메인으로</a>
      <a class="btn" href="<%=ctx%>/map.jsp">지도보기</a>
      <a class="btn" href="<%=ctx%>/logout.jsp">로그아웃</a>
    </div>
  </div>

  <h2>내가 작성한 리뷰</h2>

  <c:choose>
    <c:when test="${empty myReviews}">
      <div class="empty">아직 작성한 리뷰가 없습니다.</div>
    </c:when>
    <c:otherwise>
      <c:forEach var="r" items="${myReviews}">
        <div class="card">
          <div class="meta">
            가게: <a class="btn" href="<%=ctx%>/review.jsp?storeName=${r.storeName}"> ${r.storeName} 리뷰보기</a>
            &nbsp;|&nbsp; 평점: <span class="rating"><fmt:formatNumber value="${r.rating}" pattern="0.0"/></span> ⭐
            &nbsp;|&nbsp; 작성일: <fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
            &nbsp;|&nbsp; ID: #${r.reviewId}
          </div>
          <div class="content"><c:out value="${r.content}"/></div>
          <c:if test="${not empty r.reviewImg}">
            <img class="review-img"
     src="${pageContext.request.contextPath}${r.reviewImg}"
     alt="리뷰 이미지">
          </c:if>

          <div style="margin-top:10px; display:flex; gap:8px;">
            <a class="btn" href="<%=ctx%>/review_update.jsp?reviewId=${r.reviewId}">수정</a>

            <!-- 삭제는 POST로 안전하게 -->
            <form method="post" action="<%=ctx%>/ReviewDelete" onsubmit="return confirm('정말 삭제하시겠습니까?');" style="display:inline;">
              <input type="hidden" name="reviewId" value="${r.reviewId}">
              <button type="submit" class="btn">삭제</button>
            </form>
          </div>
        </div>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</div>
</body>
</html>
