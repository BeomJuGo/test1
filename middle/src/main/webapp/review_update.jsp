<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"
    import="com.review.*"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%
    String ctx = request.getContextPath();
    com.member.MemberDTO loginUser = (com.member.MemberDTO) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    String idParam = request.getParameter("reviewId");
    if (idParam == null) { out.print("잘못된 접근입니다."); return; }
    int reviewId = Integer.parseInt(idParam);

    ReviewDTO dto = ReviewDAO.getInstance().findById(reviewId);
    if (dto == null) { out.print("존재하지 않는 리뷰입니다."); return; }

    boolean isOwner = dto.getUserId() != null && dto.getUserId().equals(loginUser.getId());
    boolean isAdmin = loginUser.getUser_level() == 4;
    if (!isOwner && !isAdmin) { out.print("권한이 없습니다."); return; }

    request.setAttribute("dto", dto);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>리뷰 수정</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
  body{font-family:system-ui,Segoe UI,Arial;background:#f7f7f7;margin:0}
  .wrap{max-width:720px;margin:24px auto;padding:16px}
  .card{background:#fff;border:2px solid #000;padding:16px}
  .row{margin-bottom:12px}
  .label{font-weight:700;margin-bottom:4px}
  .input, textarea{width:100%;padding:8px;box-sizing:border-box}
  .thumb{max-width:240px;height:auto;border:1px solid #0001;border-radius:6px}
  .btn{border:1px solid #000;background:#fff;padding:.5rem .9rem;cursor:pointer;text-decoration:none;color:#000}
  .actions{display:flex;gap:8px;margin-top:12px}
</style>
</head>
<body>
<div class="wrap">
  <div class="card">
    <h2>리뷰 수정</h2>

    <form method="post" action="<%=ctx%>/ReviewUpdate" enctype="multipart/form-data">
      <input type="hidden" name="reviewId" value="${dto.reviewId}">
      <input type="hidden" name="storeName" value="${dto.storeName}"><!-- 성공 후 리다이렉트에 사용 가능 -->

      <div class="row">
        <div class="label">가게명</div>
        <div>${dto.storeName}</div>
      </div>

      <div class="row">
        <div class="label">현재 평점</div>
        <div><c:out value="${dto.rating}"/> 점</div>
      </div>

      <div class="row">
        <div class="label">새 평점 (0~5, 소수 1자리)</div>
        <input class="input" type="number" name="rating" min="0" max="5" step="0.1" value="${dto.rating}">
      </div>

      <div class="row">
        <div class="label">리뷰 내용</div>
        <textarea name="content" rows="6" maxlength="1000" required>${dto.content}</textarea>
      </div>

      <div class="row">
        <div class="label">현재 이미지</div>
        <c:choose>
          <c:when test="${empty dto.reviewImg}">
            <div>없음</div>
          </c:when>
          <c:otherwise>
            <div><img class="thumb" src="${dto.reviewImg}" alt="현재 이미지"></div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="row">
        <div class="label">새 이미지 업로드 (선택)</div>
        <input type="file" name="reviewImg" accept="image/*">
        <label style="display:block;margin-top:6px;">
          <input type="checkbox" name="deleteImage" value="on"> 기존 이미지 삭제
        </label>
      </div>

      <div class="actions">
        <button type="submit" class="btn">저장</button>
        <a class="btn" href="<%=ctx%>/mypage.jsp">취소</a>
      </div>
    </form>
  </div>
</div>
</body>
</html>
