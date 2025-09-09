package com.review;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.time.LocalDate;
import java.util.UUID;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import com.review.ReviewDAO;
import com.review.ReviewDTO;

/**
 * 리뷰 등록 처리 서블릿
 * form: userId, storeName, rating, content, reviewImg(file)
 */
@WebServlet("/Review")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize       = 10L * 1024 * 1024, // 10MB
    maxRequestSize    = 20L * 1024 * 1024  // 20MB
)
public class ReviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 업로드 파일을 저장할 웹앱 상대 경로 (정적 서빙을 원하면 webapp 하위가 편함)
    private static final String UPLOAD_BASE = "/uploads/reviews";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1) 로그인 확인: 세션에 loginUser 없는 경우 로그인 페이지로
        Object loginUser = request.getSession().getAttribute("loginUser");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 2) 파라미터 받기
        String userId    = nvl(request.getParameter("userId")).trim();
        String storeName = nvl(request.getParameter("storeName")).trim();
        String content   = nvl(request.getParameter("content")).trim();
        String ratingStr = nvl(request.getParameter("rating")).trim();

        // rating 파싱(0.0 ~ 5.0 클램핑, 한 자리 소수까지만 저장하도록 반올림)
        Double rating = null;
        if (!ratingStr.isEmpty()) {
            try {
                double r = Double.parseDouble(ratingStr);
                if (r < 0) r = 0;
                if (r > 5) r = 5;
                rating = Math.round(r * 10.0) / 10.0; // 소수1자리 반올림
            } catch (NumberFormatException ignore) { /* rating은 null 처리 */ }
        }

        // 3) 파일 업로드 처리 (선택)
        String savedRelPath = null;
        Part filePart = null;
        try {
            filePart = request.getPart("reviewImg");  // input name="reviewImg"
        } catch (IllegalStateException ise) {
            // 업로드 용량 초과 등
            ise.printStackTrace();
        }

        if (filePart != null && filePart.getSize() > 0) {
            String submitted = filePart.getSubmittedFileName(); // 원본파일명
            String ext = getSafeExt(submitted);

            // 날짜 폴더(예: /uploads/reviews/2025/09/08) 아래에 저장
            LocalDate today = LocalDate.now();
            String datePath = String.format("%04d/%02d/%02d", today.getYear(), today.getMonthValue(), today.getDayOfMonth());

            // 실제 저장 경로(물리)
            String uploadRootReal = getServletContext().getRealPath(UPLOAD_BASE);
            File dir = new File(uploadRootReal, datePath);
            if (!dir.exists() && !dir.mkdirs()) {
                throw new IOException("업로드 디렉토리 생성 실패: " + dir.getAbsolutePath());
            }

            // 파일명: UUID + 확장자
            String newName = UUID.randomUUID().toString().replace("-", "") + ext;
            File dst = new File(dir, newName);

            // 저장
            try (InputStream in = filePart.getInputStream()) {
                Files.copy(in, dst.toPath());
            }

            // DB에는 웹에서 접근 가능한 상대 경로로 저장
            savedRelPath = (UPLOAD_BASE + "/" + datePath + "/" + newName).replace("\\", "/");
        }

        // 4) DTO 구성 & INSERT
        ReviewDTO dto = new ReviewDTO();
        dto.setUserId(userId);
        dto.setStoreName(storeName);
        dto.setContent(content);
        dto.setRating(rating);
        dto.setReviewImg(savedRelPath); // null 가능

        int rows = ReviewDAO.getInstance().insert(dto);

        // 5) 결과에 따른 리다이렉트
        // - 리뷰 목록/상세로 돌아가게 경로 설정: 형님 프로젝트 흐름에 맞춰 review.jsp로 이동
        //   (storeName을 쿼리스트링으로 넘기면 컨트롤러/페이지에서 해당 가게 리뷰를 다시 조회)
        if (rows > 0) {
            response.sendRedirect(request.getContextPath() + "/review.jsp?storeName=" + urlEncode(storeName));
        } else {
            // 실패 시 다시 작성 화면으로 (간단한 메시지 파라미터 추가)
            response.sendRedirect(request.getContextPath() + "/review_add.jsp?storeName=" + urlEncode(storeName) + "&error=1");
        }
    }

    private static String nvl(String s) {
        return (s == null) ? "" : s;
    }

    private static String getSafeExt(String filename) {
        if (filename == null) return "";
        String f = filename;
        int q = f.lastIndexOf('?');
        if (q >= 0) f = f.substring(0, q);
        int hash = f.lastIndexOf('#');
        if (hash >= 0) f = f.substring(0, hash);

        int dot = f.lastIndexOf('.');
        if (dot < 0) return ""; // 확장자 없음
        String ext = f.substring(dot).toLowerCase();

        // 이미지 확장자만 허용(원하면 더 추가)
        switch (ext) {
            case ".jpg":
            case ".jpeg":
            case ".png":
            case ".gif":
            case ".webp":
                return ext;
            default:
                return ".bin"; // 허용 외 확장자는 이진파일로
        }
    }

    private static String urlEncode(String s) {
        try {
            return java.net.URLEncoder.encode(s, java.nio.charset.StandardCharsets.UTF_8.toString());
        } catch (Exception e) {
            return s;
        }
    }
}
