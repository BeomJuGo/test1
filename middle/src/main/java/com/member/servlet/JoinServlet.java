package com.member.servlet;

import com.member.MemberDAO;
import com.member.MemberDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/join.do")
public class JoinServlet extends HttpServlet {
    private final MemberDAO dao = new MemberDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String id = req.getParameter("id");
        String name = req.getParameter("name");
        String pwd = req.getParameter("pwd");
        String pwd2 = req.getParameter("pwd2");

        // 비밀번호 확인
        if (!pwd.equals(pwd2)) {
            req.setAttribute("msg", "비밀번호가 일치하지 않습니다.");
            req.getRequestDispatcher("join.jsp").forward(req, resp);
            return;
        }

        // 아이디 중복 체크
        if (dao.existsId(id)) {
            req.setAttribute("msg", "이미 사용 중인 아이디입니다.");
            req.getRequestDispatcher("join.jsp").forward(req, resp);
            return;
        }

        // user_level은 항상 1
        MemberDTO member = new MemberDTO(id, pwd, name, 1);
        boolean success = dao.join(member);

        if (success) {
            resp.sendRedirect("login.jsp");
        } else {
            req.setAttribute("msg", "회원가입 실패, 관리자에게 문의하세요.");
            req.getRequestDispatcher("join.jsp").forward(req, resp);
        }
    }
}
