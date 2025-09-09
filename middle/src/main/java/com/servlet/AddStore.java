package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/AddStore")
public class AddStore extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String URL = "jdbc:oracle:thin:@10.106.0.230:1521:XE";
    private static final String USER = "scott";   // DB 사용자
    private static final String PASSWORD = "tiger"; // DB 비밀번호

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String adress = request.getParameter("adress");
        String review = request.getParameter("review");
        int rating = Integer.parseInt(request.getParameter("rating"));
        String storeImg = request.getParameter("store_img");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            String sql = "INSERT INTO store (name, adress, review, rating, store_img) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, adress);
            pstmt.setString(3, review);
            pstmt.setInt(4, rating);
            pstmt.setString(5, storeImg);

            int result = pstmt.executeUpdate();

            if(result > 0) {
                response.sendRedirect(request.getContextPath() + "/main.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/addStore.jsp?error=1");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/addStore.jsp?error=2");
        } finally {
            try { if(pstmt != null) pstmt.close(); } catch(Exception ignored) {}
            try { if(conn != null) conn.close(); } catch(Exception ignored) {}
        }
    }
}
