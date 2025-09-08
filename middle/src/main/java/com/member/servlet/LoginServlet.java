package com.member.servlet;

import com.member.MemberDAO;
import com.member.MemberDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/login.do")
public class LoginServlet extends HttpServlet {
    private final MemberDAO dao = new MemberDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String id = req.getParameter("id");
        String pwd = req.getParameter("pwd");

        // DAO에서 아이디와 비밀번호 확인
        MemberDTO member = dao.login(id, pwd);

        if (member != null) {
            // 로그인 성공
            HttpSession session = req.getSession();
            session.setAttribute("loginUser", member);

            if (member.getUser_level() == 4) {
                // 관리자 페이지로 이동
                resp.sendRedirect("admin.do");
            } else {
                // 일반 사용자 페이지로 이동
                resp.sendRedirect("main.jsp");
            }
            
        } else {
            // 로그인 실패
            req.setAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            System.out.println("로그인 시도: " + id + ", " + pwd);
            System.out.println("조회 결과: " + member);

        }
    }
}
