package com.member.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout.do")  // main.jsp에서 호출되는 URL
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false); // 기존 세션만 가져오기
        if (session != null) {
            session.invalidate(); // 세션 제거
        }
        resp.sendRedirect("main.jsp"); // 로그아웃 후 메인 페이지로
    }

    // POST 요청도 GET과 동일하게 처리
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}
