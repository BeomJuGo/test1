package com.review;

import java.io.File;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/ReviewDelete")
public class ReviewDeleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_BASE = "/uploads/reviews";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Object login = request.getSession().getAttribute("loginUser");
        if (login == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        com.member.MemberDTO me = (com.member.MemberDTO) login;

        int reviewId = 0;
        try { reviewId = Integer.parseInt(request.getParameter("reviewId")); } catch (Exception ignore) {}

        ReviewDTO dto = ReviewDAO.getInstance().findById(reviewId);
        if (dto == null) {
            response.sendRedirect(request.getContextPath() + "/mypage.jsp");
            return;
        }

        boolean isOwner = dto.getUserId() != null && dto.getUserId().equals(me.getId());
        boolean isAdmin = me.getUser_level() == 4;
        if (!isOwner && !isAdmin) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
            return;
        }

        // 물리 파일도 있으면 삭제 시도 (실패해도 무시)
        if (dto.getReviewImg() != null && dto.getReviewImg().startsWith(UPLOAD_BASE)) {
            String real = getServletContext().getRealPath(dto.getReviewImg());
            if (real != null) {
                try { new File(real).delete(); } catch (Exception ignore) {}
            }
        }

        ReviewDAO.getInstance().delete(reviewId);
        response.sendRedirect(request.getContextPath() + "/mypage.jsp");
    }
}
