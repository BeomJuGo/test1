<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Determine whether the current user is an administrator (user_level == 4)
    com.member.MemberDTO loginUser = (com.member.MemberDTO) session.getAttribute("loginUser");
    boolean isAdmin = (loginUser != null && loginUser.getUser_level() == 4);
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>지도 보기</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <!-- 네이버 지도 API: 지도 초기화용. 서비스 라이브러리 불필요 (지오코딩은 admin.jsp에서 처리) -->
<script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=uf38w3wc70"></script>
  <style>
    body, html { margin: 0; padding: 0; height: 100%; }
    #map { width: 100%; height: 100vh; }
  </style>
</head>
<body>
<div id="map"></div>

<script>
// 관리자 여부를 서버에서 주입받음 (true / false)
var isAdmin = <%= isAdmin %>;

// 컨텍스트 경로 (예: /myapp) - Ajax 호출 시 사용
var ctx = '<%= ctx %>';

// 지도 초기화
var map = new naver.maps.Map('map', {
  center: new naver.maps.LatLng(37.5665, 126.9780), // 서울 중심 좌표
  zoom: 13
});

// 마커 및 정보 창 생성 함수
function addMarker(store) {
  // 좌표가 존재해야만 마커 생성
  if (!store || store.latitude == null || store.longitude == null) return;
  var position = new naver.maps.LatLng(store.latitude, store.longitude);
  var marker = new naver.maps.Marker({
    position: position,
    map: map
  });
  // 인포윈도우 내용: 가게 이름, 평점, 주소
  var infoHtml = '<div style="padding:10px;">' +
    '<strong>' + (store.name || '') + '</strong><br>' +
    '평점: ' + (store.rating != null ? Number(store.rating).toFixed(1) : '-') + '<br>' +
    '주소: ' + (store.address || '') + '</div>';
  var infowindow = new naver.maps.InfoWindow({
    content: infoHtml
  });
  naver.maps.Event.addListener(marker, 'click', function() {
    // 클릭 시 열려 있으면 닫고, 닫혀 있으면 연다.
    if (infowindow.getMap()) infowindow.close();
    else infowindow.open(map, marker);
  });
}

// 서버에서 JSON 데이터로 상점 목록을 가져와 마커를 찍는다.
function loadStores() {
  fetch(ctx + '/store/list.do', { headers: { 'Accept': 'application/json' } })
    .then(function(res) { return res.json(); })
    .then(function(data) {
      if (data && data.items) {
        data.items.forEach(function(item) {
          // latitude/longitude 값이 null이나 0인지 확인
          if (item.latitude != null && item.longitude != null && item.latitude !== 'null' && item.longitude !== 'null') {
            // 변환: 문자열을 숫자로 변환
            item.latitude  = parseFloat(item.latitude);
            item.longitude = parseFloat(item.longitude);
            addMarker(item);
          }
        });
      }
    })
    .catch(function(err) {
      console.error('가게 목록을 불러오지 못했습니다.', err);
    });
}

// 지도 클릭 시 좌표를 활용하려면 여기에서 정의
if (isAdmin) {
  // 예시: 관리자가 지도 클릭 시 좌표를 alert로 표시하거나 등록 UI에 전달할 수 있음
  naver.maps.Event.addListener(map, 'click', function(e) {
    var lat = e.coord.lat();
    var lng = e.coord.lng();
    // TODO: 필요한 경우 클릭 좌표를 입력 폼으로 전달하는 로직을 구현할 수 있다.
    console.log('관리자 지도 클릭 좌표:', lat, lng);
  });
}

// 페이지 로드 후 상점 목록 로딩
loadStores();
</script>

</body>
</html>