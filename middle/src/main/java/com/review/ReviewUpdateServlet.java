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

@WebServlet("/ReviewUpdate")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1MB
    maxFileSize       = 10L * 1024 * 1024, // 10MB
    maxRequestSize    = 20L * 1024 * 1024  // 20MB
)
public class ReviewUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_BASE = "/uploads/reviews";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        Object login = request.getSession().getAttribute("loginUser");
        if (login == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        com.member.MemberDTO me = (com.member.MemberDTO) login;

        int reviewId = Integer.parseInt(nvl(request.getParameter("reviewId"), "0"));
        String storeName = nvl(request.getParameter("storeName"), "");
        String content = nvl(request.getParameter("content"), "").trim();
        String ratingStr = nvl(request.getParameter("rating"), "").trim();
        boolean deleteImage = "on".equals(request.getParameter("deleteImage"));

        // 원본
        ReviewDTO origin = ReviewDAO.getInstance().findById(reviewId);
        if (origin == null) {
            response.sendRedirect(request.getContextPath() + "/mypage.jsp");
            return;
        }

        // 권한: 소유자 또는 관리자(LEVEL 4)
        boolean isOwner = origin.getUserId() != null && origin.getUserId().equals(me.getId());
        boolean isAdmin = me.getUser_level() == 4;
        if (!isOwner && !isAdmin) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
            return;
        }

        // 평점 파싱/클램핑
        Double rating = origin.getRating();
        if (!ratingStr.isEmpty()) {
            try {
                double r = Double.parseDouble(ratingStr);
                if (r < 0) r = 0; if (r > 5) r = 5;
                rating = Math.round(r * 10.0) / 10.0;
            } catch (NumberFormatException ignore) {}
        }

        // 이미지 처리
        String finalPath = origin.getReviewImg();
        if (deleteImage) {
            finalPath = null;
        }

        Part filePart = null;
        try {
            filePart = request.getPart("reviewImg");
        } catch (IllegalStateException ise) {
            ise.printStackTrace();
        }
        if (filePart != null && filePart.getSize() > 0) {
            String ext = getSafeExt(filePart.getSubmittedFileName());
            LocalDate today = LocalDate.now();
            String datePath = String.format("%04d/%02d/%02d", today.getYear(), today.getMonthValue(), today.getDayOfMonth());
            String uploadRootReal = getServletContext().getRealPath(UPLOAD_BASE);
            File dir = new File(uploadRootReal, datePath);
            if (!dir.exists() && !dir.mkdirs()) {
                throw new IOException("업로드 디렉토리 생성 실패: " + dir.getAbsolutePath());
            }
            String newName = UUID.randomUUID().toString().replace("-", "") + ext;
            File dst = new File(dir, newName);
            try (InputStream in = filePart.getInputStream()) {
                Files.copy(in, dst.toPath());
            }
            finalPath = (UPLOAD_BASE + "/" + datePath + "/" + newName).replace("\\", "/");
        }

        // DTO 구성 & 업데이트
        ReviewDTO toUpdate = new ReviewDTO();
        toUpdate.setReviewId(reviewId);
        toUpdate.setContent(content.isEmpty() ? origin.getContent() : content);
        toUpdate.setRating(rating);
        toUpdate.setReviewImg(finalPath);

        ReviewDAO.getInstance().update(toUpdate);

        response.sendRedirect(request.getContextPath() + "/mypage.jsp");
    }

    private static String nvl(String s, String alt) { return (s == null) ? alt : s; }

    private static String getSafeExt(String filename) {
        if (filename == null) return "";
        String f = filename;
        int q = f.lastIndexOf('?'); if (q >= 0) f = f.substring(0, q);
        int h = f.lastIndexOf('#'); if (h >= 0) f = f.substring(0, h);
        int dot = f.lastIndexOf('.');
        if (dot < 0) return "";
        String ext = f.substring(dot).toLowerCase();
        switch (ext) {
            case ".jpg": case ".jpeg": case ".png": case ".gif": case ".webp": return ext;
            default: return ".bin";
        }
    }
}
