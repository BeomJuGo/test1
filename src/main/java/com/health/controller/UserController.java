package com.health.controller;

import com.health.model.User;
import com.health.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;

/**
 * User 컨트롤러
 */
@Controller
@RequestMapping("/user")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    /**
     * 로그인 페이지
     */
    @GetMapping("/login")
    public String loginPage() {
        return "user/login";
    }
    
    /**
     * 로그인 처리
     */
    @PostMapping("/login")
    public String login(@RequestParam String username,
                       @RequestParam String password,
                       HttpSession session,
                       Model model) {
        User user = userService.login(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            session.setAttribute("userType", "user");
            return "redirect:/main.jsp";
        }
        model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
        return "user/login";
    }
    
    /**
     * 회원가입 페이지
     */
    @GetMapping("/register")
    public String registerPage() {
        return "user/register";
    }
    
    /**
     * 회원가입 처리
     */
    @PostMapping("/register")
    public String register(@ModelAttribute User user, Model model) {
        if (userService.register(user)) {
            return "redirect:/user/login";
        }
        model.addAttribute("error", "이미 존재하는 사용자명 또는 이메일입니다.");
        return "user/register";
    }
    
    /**
     * 로그아웃
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/main.jsp";
    }
    
    /**
     * 프로필 페이지
     */
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        // 최신 정보 조회
        user = userService.getUserById(user.getUserId());
        model.addAttribute("user", user);
        return "user/profile";
    }
    
    /**
     * 프로필 업데이트
     */
    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute User user, HttpSession session) {
        if (userService.updateUser(user)) {
            session.setAttribute("user", userService.getUserById(user.getUserId()));
        }
        return "redirect:/user/profile";
    }
}
