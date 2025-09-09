<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>유저 수정</title>
<style>
  .wrap{max-width:720px;margin:24px auto;font-family:system-ui}
  label{display:block;margin:8px 0 4px}
  input,select{width:100%;padding:8px;border:1px solid #333}
  .row{display:grid;grid-template-columns:1fr 1fr;gap:12px}
  .btn{margin-top:16px;padding:8px 12px;border:1px solid #333;background:#fff;cursor:pointer}
  .btn:hover{background:#f6f6f6}
</style>
</head>
<body>
<div class="wrap">
  <h1>유저 수정</h1>

  <form method="post" action="${pageContext.request.contextPath}/user/update">
    <input type="hidden" name="id" value="${user.id}"/>

    <label>아이디(닉네임)</label>
    <input type="text" name="username" value="${user.username}" required />

    <label>이메일</label>
    <input type="email" name="email" value="${user.email}" required />

    <div class="row">
      <div>
        <label>권한(role)</label>
        <select name="role">
          <option ${user.role=='USER'?'selected':''}>USER</option>
          <option ${user.role=='ADMIN'?'selected':''}>ADMIN</option>
        </select>
      </div>
      <div>
        <label>상태(status)</label>
        <select name="status">
          <option ${user.status=='ACTIVE'?'selected':''}>ACTIVE</option>
          <option ${user.status=='BLOCKED'?'selected':''}>BLOCKED</option>
        </select>
      </div>
    </div>

    <button class="btn" type="submit">저장</button>
    <a class="btn" href="${pageContext.request.contextPath}/admin.jsp">취소</a>
  </form>
</div>
</body>
</html>
