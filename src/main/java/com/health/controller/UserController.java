package com.health.controller;

import com.health.exception.AuthenticationException;
import com.health.exception.BusinessException;
import com.health.model.User;
import com.health.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * User 컨트롤러
 */
@Controller
@RequestMapping("/user")
public class UserController {

    private static final Logger logger = LoggerFactory.getLogger(UserController.class);

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
        System.out.println("=== LOGIN ATTEMPT ===");
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);

        try {
            if (username == null || username.trim().isEmpty()) {
                model.addAttribute("error", "아이디를 입력해주세요.");
                return "user/login";
            }

            if (password == null || password.trim().isEmpty()) {
                model.addAttribute("error", "비밀번호를 입력해주세요.");
                return "user/login";
            }

            System.out.println("Calling userService.login...");
            User user = userService.login(username.trim(), password);
            System.out.println("UserService.login returned: " + (user != null ? "User object" : "null"));

            if (user != null) {
                session.setAttribute("user", user);
                session.setAttribute("userType", "user");
                logger.info("사용자 로그인 성공: {}", username);
                System.out.println("Login successful, redirecting to dashboard");
                return "redirect:/user/dashboard";
            }
            model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "user/login";
        } catch (RuntimeException e) {
            logger.warn("로그인 인증 오류: {}", e.getMessage());
            System.out.println("RuntimeException: " + e.getMessage());
            model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "user/login";
        } catch (Exception e) {
            logger.error("로그인 처리 오류: {}", e.getMessage());
            model.addAttribute("error", "로그인 처리 중 오류가 발생했습니다.");
            return "user/login";
        }
    }

    /**
     * 회원가입 페이지
     */
    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("user", new User());
        return "user/register";
    }

    /**
     * 회원가입 처리
     */
    @PostMapping("/register")
    public String register(@ModelAttribute User user, Model model) {
        try {
            // 입력 검증
            if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
                model.addAttribute("error", "아이디를 입력해주세요.");
                return "user/register";
            }

            if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                model.addAttribute("error", "비밀번호를 입력해주세요.");
                return "user/register";
            }

            if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                model.addAttribute("error", "이메일을 입력해주세요.");
                return "user/register";
            }

            if (userService.register(user)) {
                logger.info("사용자 회원가입 성공: {}", user.getUsername());
                return "redirect:/user/login";
            }
            model.addAttribute("error", "이미 존재하는 사용자명 또는 이메일입니다.");
            return "user/register";
        } catch (BusinessException e) {
            logger.error("회원가입 비즈니스 오류: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            return "user/register";
        } catch (Exception e) {
            logger.error("회원가입 처리 오류: {}", e.getMessage());
            model.addAttribute("error", "회원가입 처리 중 오류가 발생했습니다.");
            return "user/register";
        }
    }

    /**
     * 로그아웃
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
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
    public String updateProfile(@ModelAttribute User user, HttpSession session, RedirectAttributes redirectAttributes) {
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                return "redirect:/user/login";
            }

            // 현재 사용자 ID 설정
            user.setUserId(currentUser.getUserId());

            if (userService.updateUser(user)) {
                // 세션 정보 업데이트
                User updatedUser = userService.getUserById(user.getUserId());
                session.setAttribute("user", updatedUser);
                redirectAttributes.addFlashAttribute("message", "프로필이 업데이트되었습니다.");
                logger.info("사용자 프로필 업데이트 성공: {}", user.getUserId());
            } else {
                redirectAttributes.addFlashAttribute("error", "프로필 업데이트에 실패했습니다.");
            }
        } catch (BusinessException e) {
            logger.error("프로필 업데이트 비즈니스 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            logger.error("프로필 업데이트 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "프로필 업데이트 중 오류가 발생했습니다.");
        }

        return "redirect:/user/profile";
    }

    /**
     * 사용자 대시보드
     */
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        try {
            // 최신 사용자 정보 조회
            User currentUser = userService.getUserById(user.getUserId());
            model.addAttribute("user", currentUser);
            return "user/dashboard";
        } catch (Exception e) {
            logger.error("대시보드 조회 오류: {}", e.getMessage());
            model.addAttribute("error", "대시보드를 불러오는 중 오류가 발생했습니다.");
            return "user/dashboard";
        }
    }

    /**
     * 테스트용 비밀번호 리셋 (개발용)
     */
    @GetMapping("/reset-password/{username}")
    @ResponseBody
    public String resetPasswordForTesting(@PathVariable String username) {
        try {
            userService.resetPasswordForTesting(username);
            return "Password reset to 'password123' for user: " + username;
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }

    /**
     * 모든 사용자의 비밀번호를 BCrypt로 업데이트 (개발용)
     */
    @GetMapping("/fix-all-passwords")
    @ResponseBody
    public String fixAllPasswords() {
        try {
            int count = userService.fixAllPasswordsWithBCrypt();
            return "Successfully updated " + count
                    + " user passwords to BCrypt hashes. All passwords are now 'password123'";
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }

    /**
     * 데이터베이스의 모든 사용자 조회 (개발용)
     */
    @GetMapping("/debug/users")
    @ResponseBody
    public String debugUsers() {
        try {
            List<User> users = userService.getAllUsers();
            StringBuilder result = new StringBuilder();
            result.append("Total users: ").append(users.size()).append("\n");
            for (User user : users) {
                result.append("Username: ").append(user.getUsername())
                        .append(", Email: ").append(user.getEmail())
                        .append(", Password: ").append(user.getPassword())
                        .append("\n");
            }
            return result.toString();
        } catch (Exception e) {
            return "Error: " + e.getMessage();
        }
    }
}
