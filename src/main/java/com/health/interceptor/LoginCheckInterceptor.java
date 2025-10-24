package com.health.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;

import com.health.model.User;
import com.health.model.Trainer;

/**
 * 로그인 체크 인터셉터
 */
public class LoginCheckInterceptor implements HandlerInterceptor {

  private static final Logger logger = LoggerFactory.getLogger(LoginCheckInterceptor.class);

  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    HttpSession session = request.getSession();
    String requestURI = request.getRequestURI();

    logger.debug("로그인 체크 인터셉터 실행: {}", requestURI);

    // 정적 리소스는 제외
    if (requestURI.startsWith("/resources/") || requestURI.startsWith("/uploads/")) {
      return true;
    }

    // 로그인/회원가입 페이지는 제외
    if (requestURI.contains("/login") || requestURI.contains("/register") || requestURI.equals("/")) {
      return true;
    }

    // 사용자 로그인 체크
    if (requestURI.startsWith("/user/") || requestURI.startsWith("/plan/")
        || requestURI.startsWith("/certification/")) {
      User user = (User) session.getAttribute("user");
      if (user == null) {
        logger.warn("사용자 로그인 필요: {}", requestURI);
        response.sendRedirect("/user/login");
        return false;
      }
    }

    // 트레이너 로그인 체크
    if (requestURI.startsWith("/trainer/")) {
      Trainer trainer = (Trainer) session.getAttribute("trainer");
      if (trainer == null) {
        logger.warn("트레이너 로그인 필요: {}", requestURI);
        response.sendRedirect("/trainer/login");
        return false;
      }
    }

    return true;
  }
}
