<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"
    import="java.util.List,com.review.ReviewDAO,com.review.ReviewDTO"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%
    String ctx = request.getContextPath();
    if (request.getAttribute("page") == null)  request.setAttribute("page", 1);
    if (request.getAttribute("totalPages") == null) request.setAttribute("totalPages", 1);

    // 파라미터에서 가게명 받기 (기존 name 파라미터 호환)
    String storeNameParam = request.getParameter("storeName");
    if (storeNameParam == null || storeNameParam.trim().isEmpty()) {
        storeNameParam = request.getParameter("name");
    }

    // 컨트롤러가 없을 때도 동작하도록 안전장치
    if (request.getAttribute("reviews") == null && storeNameParam != null && !storeNameParam.isEmpty()) {
        List<ReviewDTO> list = ReviewDAO.getInstance().findByStore(storeNameParam);
        request.setAttribute("reviews", list);
    }
    if (request.getAttribute("storeName") == null && storeNameParam != null) {
        double avg = ReviewDAO.getInstance().avgRatingByStore(storeNameParam);
        request.setAttribute("storeName", storeNameParam);
        request.setAttribute("storeAddress", request.getParameter("address")); // main.jsp에서 전달
        request.setAttribute("storeAvg", avg);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${store != null ? store.name : storeName}" /> 리뷰 관리</title>
<style>
@font-face {
    font-family: 'Paperozi';
    src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/2408-3@1.0/Paperlogy-9Black.woff2') format('woff2');
    font-weight: 900; font-display: swap;
}
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:'Paperozi';font-size:14px;line-height:1.5;background:#fff;color:#000}
.container{min-height:100vh;padding:1rem}
.main-wrapper{max-width:56rem;margin:0 auto}
.main-container{border:2px solid #000;padding:1.5rem}
.top-section{display:flex;gap:1.5rem;margin-bottom:2rem}
.form-area{flex:1}
.form-fields{display:flex;flex-direction:column;gap:1rem}
.field-group{display:flex;flex-direction:column}
.field-label{display:block;margin-bottom:.25rem;font-weight:500}
.field-input-wrapper{border-bottom:2px solid #000;padding-bottom:.25rem}
.right-buttons{display:flex;flex-direction:column;gap:.5rem}
.button{border:1px solid #000;padding:.25rem 1rem;background:#fff;cursor:pointer;font-size:14px;font-weight:500;line-height:1.5}
.button:hover{background:#f9fafb}
.review-section{margin-bottom:1.5rem}
.review-list{display:flex;flex-direction:column;gap:.5rem}
.review-item{display:flex;align-items:flex-start;justify-content:space-between;border-bottom:1px solid #000;padding:.75rem 0}
.review-item:last-child{border-bottom:2px solid #000}
.review-left{display:flex;gap:1rem;flex-direction:column;max-width:75%}
.review-right{display:flex;align-items:center;gap:.5rem}
.meta{font-size:.85em;color:#555}
.rating{font-weight:bold;color:#ff9800}
.review-content{white-space:pre-wrap;word-break:break-word}
.review-img{max-width:200px;height:auto;border-radius:6px;border:1px solid #0001}
.bottom-section{display:flex;align-items:center;justify-content:space-between}
.pagination{display:flex;align-items:center;gap:1rem}
.pagination-button{border:1px solid #000;padding:.25rem .75rem;background:#fff;cursor:pointer;font-size:14px;font-weight:500;line-height:1.5;text-decoration:none;color:#000}
.pagination-button:hover{background:#f9fafb}
.review-write-button{border:1px solid #000;padding:.25rem 1rem;background:#fff;cursor:pointer;font-size:14px;font-weight:500}
.review-write-button:hover{background:#f9fafb}
.btn-link{border:1px solid #000;padding:.2rem .6rem;background:#fff;cursor:pointer;font-size:12px;text-decoration:none;color:#000}
.btn-link:hover{background:#f9fafb}
</style>
</head>
<body>
<div class="container">
  <div class="main-wrapper">
    <div class="main-container">

      <!-- 상단: 가게 정보 -->
      <div class="top-section">
        <div class="form-area">
          <div class="form-fields">
            <div class="field-group">
              <label class="field-label">가게이름</label>
              <div class="field-input-wrapper">
                <c:out value="${store != null ? store.name : storeName}" />
              </div>
            </div>
            <div class="field-group">
              <label class="field-label">가게주소</label>
              <div class="field-input-wrapper">
                <c:out value="${store != null ? store.address : storeAddress}" />
              </div>
            </div>
            <div class="field-group">
              <label class="field-label">평균 평점</label>
              <div class="field-input-wrapper">
                <fmt:formatNumber value="${store != null ? store.avg : storeAvg}" pattern="0.0" />
              </div>
            </div>
          </div>
        </div>

        <div class="right-buttons">
          <button class="button" onclick="location.href='<%=ctx%>/main.jsp'">메인으로</button>
          <button class="button" onclick="location.href='<%=ctx%>/map.jsp'">지도보기</button>
        </div>
      </div>

      <!-- 리뷰 목록 -->
      <div class="review-section">
        <div class="review-list">
          <c:choose>
            <c:when test="${not empty reviews}">
              <c:forEach var="r" items="${reviews}">
                <div class="review-item">
                  <div class="review-left">
                    <div class="meta">
                      작성자: <strong><c:out value="${r.userId}" /></strong>
                      &nbsp;|&nbsp; 평점:
                      <span class="rating"><fmt:formatNumber value="${r.rating}" pattern="0.0"/></span> ⭐
                      &nbsp;|&nbsp; 작성일:
                      <fmt:formatDate value="${r.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </div>

                    <div class="review-content"><c:out value="${r.content}"/></div>

                    <c:if test="${not empty r.reviewImg}">
                     <img class="review-img"
     src="${pageContext.request.contextPath}${r.reviewImg}"
     alt="리뷰 이미지">
                    </c:if>
                  </div>

                  <div class="review-right">
                    <!-- 본인글 또는 관리자(LEVEL 4)면 수정 가능 -->
                    <c:if test="${not empty sessionScope.loginUser 
                                  and (r.userId eq sessionScope.loginUser.id 
                                       or sessionScope.loginUser.user_level == 4)}">
                      <a class="btn-link"
                         href="${pageContext.request.contextPath}/review_update.jsp?reviewId=${r.reviewId}&storeName=${store != null ? store.name : storeName}&page=${page}">
                        리뷰수정
                      </a>
                    </c:if>
                  </div>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="review-item">
                <div class="review-left"><span>리뷰가 없습니다.</span></div>
                <span>-</span>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>

      <!-- 하단: 페이지네이션 & 리뷰쓰기 -->
      <div class="bottom-section">
        <div class="pagination">
          <c:set var="curPage" value="${page}" />
          <c:set var="tp" value="${totalPages}" />

          <c:choose>
            <c:when test="${curPage > 1}">
              <a class="pagination-button"
                 href="${pageContext.request.contextPath}/storeDetail.jsp?name=${store != null ? store.name : storeName}&page=${curPage - 1}">
                 이전
              </a>
            </c:when>
            <c:otherwise>
              <span class="pagination-button" style="opacity:.5;pointer-events:none;">이전</span>
            </c:otherwise>
          </c:choose>

          <span><c:out value="${curPage}" /> / <c:out value="${tp}" /> 페이지</span>

          <c:choose>
            <c:when test="${curPage < tp}">
              <a class="pagination-button"
                 href="${pageContext.request.contextPath}/storeDetail.jsp?name=${store != null ? store.name : storeName}&page=${curPage + 1}">
                 다음
              </a>
            </c:when>
            <c:otherwise>
              <span class="pagination-button" style="opacity:.5;pointer-events:none;">다음</span>
            </c:otherwise>
          </c:choose>
        </div>

        <button class="review-write-button"
                onclick="location.href='<%=ctx%>/review_add.jsp?storeName=${store != null ? store.name : storeName}&address=${store != null ? store.address : storeAddress}'">
          리뷰 쓰기
        </button>
      </div>

    </div>
  </div>
</div>
</body>
</html>
