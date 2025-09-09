<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.member.MemberDTO" %>
<%@ page import="com.store.StoreDTO" %>

<%
    String ctx = request.getContextPath();
    MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");
    boolean isAdmin = (loginUser != null && loginUser.getUser_level() == 4);

    // ✅ 관리자만 접근
    if (!isAdmin) {
        response.sendRedirect(ctx + "/main.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>관리자 페이지</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <style>
      @font-face {
     font-family: 'Paperozi';
     src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/2408-3@1.0/Paperlogy-3Light.woff2') format('woff2');
     font-weight: 300;
     font-display: swap;
   }
   
   body {
     font-family: 'Paperozi', sans-serif;
     background: #f8f8f8;
     display: flex;
     justify-content: center;
     align-items: flex-start;
     min-height: 100vh;
     margin: 0;
   }
   
   .wrap {
     max-width: 1200px;
     margin: 30px auto;
     padding: 30px 40px;
     background: #fff;
     border: 2px solid #ccc;
     border-radius: 10px;
     box-shadow: 0 4px 8px rgba(0,0,0,0.1);
     width: 100%;
   }
   
   h1 {
     font-size: 1.8rem;
     margin: 0 0 20px;
     text-align: center;
     color: #333;
   }
   
   h2 {
     font-size: 1.2rem;
     margin: 20px 0 10px;
     border-bottom: 2px solid #7A7A73;
     padding-bottom: 6px;
     color: #44444E;
   }
   
   .top-left-toolbar {
     position: absolute;
     top: 20px;
     left: 20px;
   }
   
   /* 버튼 */
   .btn {
     background-color: #44444E;
     color: white;
     padding: 8px 16px;
     border: none;
     border-radius: 4px;
     font-size: 14px;
     cursor: pointer;
     text-decoration: none;
     transition: background 0.2s;
   }
   .btn:hover {
     background-color: #D3DAD9;
     color: #000;
   }
   
   /* 버튼 색상 변형 */
   .btn-delete { background-color: #7A7A73; }
   .btn-delete:hover { background-color: #44444E; }
   
   .btn-edit { background-color: #7A7A73; }
   .btn-edit:hover { background-color: #44444E; }
   
   .btn-save { background-color: #44444E; }
   .btn-save:hover { background-color: #D3DAD9; color:#000; }
   
   .btn-cancel { background-color: #7A7A73; }
   .btn-cancel:hover { background-color: #44444E; }
   
   .btn-toggle { background-color: #44444E; margin-left: 5px; }
   .btn-toggle:hover { background-color: #D3DAD9; color:#000; }
   
   /* 테이블 */
   table {
     width: 100%;
     border-collapse: collapse;
     margin-bottom: 24px;
     font-size: 0.95rem;
   }
   th, td {
     border: 1px solid #ddd;
     padding: 10px;
     text-align: center;
   }
   th {
     background: #44444E;
     color: #fff;
     font-weight: 600;
   }
   tr:nth-child(even) { background: #f9f9f9; }
   tr:hover { background: #f1f1f1; }
   
   form { display: inline; }
   .hidden { display: none; }
   .mt-2 { margin-top: 8px; }
   .mb-2 { margin-bottom: 8px; }
   
   /* 리뷰 박스 */
   .review-box {
     margin-bottom: 10px;
     border-bottom: 1px solid #ddd;
     padding-bottom: 5px;
   }
   .review-box img {
     max-width: 100px;
     max-height: 100px;
     display: block;
     margin-top: 5px;
   }
      /* 공통 입력 스타일 */
   form input[type="text"],
   form input[type="password"],
   form input[type="number"],
   form select {
     width: 280px;          /* 입력칸 고정 너비 */
     display: block;        /* 줄바꿈 + 왼쪽 정렬 */
     text-align: left;
     box-sizing: border-box;
     padding: 8px;
     margin-bottom: 12px;   /* 입력칸 간격 */
     border: 1px solid #ccc;
     border-radius: 4px;
     font-size: 14px;
   }
   
   /* 공통 입력 스타일 */
   form input[type="text"],
   form input[type="password"],
   form input[type="number"],
   form select {
     width: 280px;          /* 입력칸 고정 너비 */
     display: block;        /* 줄바꿈 + 왼쪽 정렬 */
     text-align: left;
     box-sizing: border-box;
     padding: 8px;
     margin-bottom: 12px;   /* 입력칸 간격 */
     border: 1px solid #ccc;
     border-radius: 4px;
     font-size: 14px;
   }
   

      
      
</style>
  <script>
    function enableEdit(rowId){
      const row = document.getElementById(rowId);
      row.querySelectorAll('.view').forEach(el=>el.classList.add('hidden'));
      row.querySelectorAll('.edit').forEach(el=>el.classList.remove('hidden'));
      const be = row.querySelector('.btn-edit'); if(be) be.classList.add('hidden');
      const bs = row.querySelector('.btn-save'); if(bs) bs.classList.remove('hidden');
      const bc = row.querySelector('.btn-cancel'); if(bc) bc.classList.remove('hidden');
      const bd = row.querySelector('.btn-delete'); if(bd) bd.classList.add('hidden');
    }
    function cancelEdit(rowId){
      const row = document.getElementById(rowId);
      row.querySelectorAll('.view').forEach(el=>el.classList.remove('hidden'));
      row.querySelectorAll('.edit').forEach(el=>el.classList.add('hidden'));
      const be = row.querySelector('.btn-edit'); if(be) be.classList.remove('hidden');
      const bs = row.querySelector('.btn-save'); if(bs) bs.classList.add('hidden');
      const bc = row.querySelector('.btn-cancel'); if(bc) bc.classList.add('hidden');
      const bd = row.querySelector('.btn-delete'); if(bd) bd.classList.remove('hidden');
      const pwd = row.querySelector('input[name="userPwd"]'); if(pwd) pwd.value = '';
    }
    function confirmDelete(msg){ return confirm(msg || '정말 삭제하시겠습니까?'); }
  </script>
</head>
<body>
<div class="wrap">
  <div class="top-left-toolbar">
    <a href="<%=ctx%>/main.jsp" class="btn">메인으로</a>
  </div>

  <h1>관리자 페이지</h1>

  <!-- ========== 회원 등록 ========= -->
  <section>
    <h2>회원 등록</h2>
    <form method="post" action="<%=ctx%>/admin.do" class="mb-2">
      <input type="hidden" name="action" value="createUser"/>
      ID: <input type="text" name="userId" required />
      이름: <input type="text" name="userName" required />
      비밀번호: <input type="password" name="userPwd" required />
      권한: <input type="number" name="userLevel" value="1" min="1" max="4" required />
      <button type="submit" class="btn">등록</button>
    </form>
  </section>

  <!-- ========== 회원 목록 ========= -->
  <section>
    <h2>회원 목록</h2>
    <table>
      <thead>
      <tr>
        <th>ID</th><th>이름</th><th>비밀번호</th><th>권한</th><th>관리</th>
      </tr>
      </thead>
      <tbody>
      <%
        List<MemberDTO> users = (List<MemberDTO>) request.getAttribute("users");
        if (users == null) users = (List<MemberDTO>) request.getAttribute("userList");
        if (users != null && !users.isEmpty()) {
          for (MemberDTO u : users) {
            String uid = u.getId();
            String rowId = "user_" + uid.replaceAll("[^A-Za-z0-9_-]", "_");
            String formId = "f_user_" + uid.replaceAll("[^A-Za-z0-9_-]", "_");
      %>
      <tr id="<%=rowId%>">
        <td><span class="view"><%=uid%></span></td>
        <td>
          <span class="view"><%=u.getUser_name()%></span>
          <input class="edit hidden" type="text" name="userName" value="<%=u.getUser_name()%>" form="<%=formId%>"/>
        </td>
        <td>
          <span class="view">******</span>
          <input class="edit hidden" type="password" name="userPwd" placeholder="변경 시에만 입력" form="<%=formId%>"/>
        </td>
        <td>
          <span class="view"><%=u.getUser_level()%></span>
          <input class="edit hidden" type="number" name="userLevel" value="<%=u.getUser_level()%>" min="1" max="4" form="<%=formId%>"/>
        </td>
        <td>
          <button type="button" class="btn btn-edit" onclick="enableEdit('<%=rowId%>')">수정</button>

          <!-- 제출용 폼(마지막 TD 안) -->
          <form id="<%=formId%>" method="post" action="<%=ctx%>/admin.do" style="display:inline;">
            <input type="hidden" name="action" value="editUser"/>
            <input type="hidden" name="userId" value="<%=uid%>"/>
            <button type="submit" class="btn btn-save hidden">저장</button>
            <button type="button" class="btn btn-cancel hidden" onclick="cancelEdit('<%=rowId%>')">취소</button>
          </form>

          <form method="post" action="<%=ctx%>/admin.do" style="display:inline" onsubmit="return confirmDelete('해당 사용자를 삭제하시겠습니까?');">
            <input type="hidden" name="action" value="deleteUser"/>
            <input type="hidden" name="userId" value="<%=uid%>"/>
            <button type="submit" class="btn btn-delete">삭제</button>
          </form>
        </td>
      </tr>
      <%
          } // for
        } else {
      %>
      <tr><td colspan="5" class="empty">등록된 회원이 없습니다.</td></tr>
      <% } %>
      </tbody>
    </table>
  </section>

  <!-- ========== 가게 등록 ========= -->
  <section>
    <h2>가게 등록</h2>
    <form method="post" action="<%=ctx%>/admin.do" class="mb-2">
      <input type="hidden" name="action" value="createStore"/>
      이름: <input type="text" name="name" required />
      주소: <input type="text" name="address" required />
      카테고리:
      <select name="category" required>
        <option value="일식">일식</option>
        <option value="중식">중식</option>
        <option value="양식">양식</option>
        <option value="한식">한식</option>
      </select>
      <button type="submit" class="btn">가게 등록</button>
    </form>
  </section>

  <!-- ========== 가게 목록 ========= -->
  <section>
    <h2>가게 목록</h2>
    <table>
      <thead>
      <tr>
        <th>이름</th><th>주소</th><th>평점</th><th>카테고리</th><th>관리</th>
      </tr>
      </thead>
      <tbody>
      <%
        List<StoreDTO> stores = (List<StoreDTO>) request.getAttribute("stores");
        if (stores == null) stores = (List<StoreDTO>) request.getAttribute("storeList");
        if (stores != null && !stores.isEmpty()) {
          for (StoreDTO s : stores) {
            String key = s.getName();
            String rowId = "store_" + key.replaceAll("[^A-Za-z0-9_-]", "_");
            String formId = "f_store_" + key.replaceAll("[^A-Za-z0-9_-]", "_");
      %>
      <tr id="<%=rowId%>">
        <td>
          <span class="view"><%=s.getName()%></span>
          <input class="edit hidden" type="text" name="name" value="<%=s.getName()%>" required form="<%=formId%>"/>
        </td>
        <td>
          <span class="view"><%=s.getAddress()%></span>
          <input class="edit hidden" type="text" name="address" value="<%=s.getAddress()%>" required form="<%=formId%>"/>
        </td>
        <td>
          <span class="view"><%=s.getRating()%></span>
          <span class="edit hidden" style="opacity:.6;">(수정 불가)</span>
        </td>
        <td>
          <span class="view"><%=s.getCategory()%></span>
          <select class="edit hidden" name="category" required form="<%=formId%>">
            <option value="일식" <%= "일식".equals(s.getCategory()) ? "selected" : "" %>>일식</option>
            <option value="중식" <%= "중식".equals(s.getCategory()) ? "selected" : "" %>>중식</option>
            <option value="양식" <%= "양식".equals(s.getCategory()) ? "selected" : "" %>>양식</option>
            <option value="한식" <%= "한식".equals(s.getCategory()) ? "selected" : "" %>>한식</option>
          </select>
        </td>
        <td>
          <button type="button" class="btn btn-edit" onclick="enableEdit('<%=rowId%>')">수정</button>

          <!-- 제출용 폼(마지막 TD 안) -->
          <form id="<%=formId%>" method="post" action="<%=ctx%>/admin.do" style="display:inline;">
            <input type="hidden" name="action" value="editStore"/>
            <input type="hidden" name="originalName" value="<%=s.getName()%>"/>
            <button type="submit" class="btn btn-save hidden">저장</button>
            <button type="button" class="btn btn-cancel hidden" onclick="cancelEdit('<%=rowId%>')">취소</button>
          </form>

          <form method="post" action="<%=ctx%>/admin.do" style="display:inline"
                onsubmit="return confirmDelete('해당 가게를 삭제하시겠습니까?');">
            <input type="hidden" name="action" value="deleteStore"/>
            <input type="hidden" name="storeId" value="<%=s.getName()%>"/>
            <button type="submit" class="btn btn-delete">삭제</button>
          </form>
        </td>
      </tr>
      <%
          } // for
        } else {
      %>
      <tr><td colspan="5" class="empty">등록된 가게가 없습니다.</td></tr>
      <% } %>
      </tbody>
    </table>
  </section>

</div>
</body>
</html>
