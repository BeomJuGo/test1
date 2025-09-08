<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>가게 수정</title>
<style>
  .wrap{max-width:720px;margin:24px auto;font-family:system-ui}
  label{display:block;margin:8px 0 4px}
  input{width:100%;padding:8px;border:1px solid #333}
  .row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
  .btn{margin-top:16px;padding:8px 12px;border:1px solid #333;background:#fff;cursor:pointer}
  .btn:hover{background:#f6f6f6}
</style>
</head>
<body>
<div class="wrap">
  <h1>가게 수정</h1>

  <form method="post" action="${pageContext.request.contextPath}/store/update">
    <input type="hidden" name="id" value="${store.id}" />

    <label>가게명</label>
    <input type="text" name="name" value="${store.name}" required />

    <label>주소</label>
    <input type="text" name="address" value="${store.address}" required />

    <div class="row">
      <div>
        <label>연락처</label>
        <input type="text" name="phone" value="${store.phone}" />
      </div>
      <div>
        <label>평균 평점</label>
        <input type="number" step="0.1" name="avg" value="${store.avg}" />
      </div>
    </div>

    <label>이미지 URL</label>
    <input type="text" name="img" value="${store.img}" />

    <button class="btn" type="submit">저장</button>
    <a class="btn" href="${pageContext.request.contextPath}/admin.jsp">취소</a>
  </form>
</div>
</body>
</html>
