package com.health.controller;

import com.health.exception.AuthenticationException;
import com.health.exception.BusinessException;
import com.health.model.Trainer;
import com.health.service.TrainerService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpSession;

/**
 * Trainer 컨트롤러
 */
@Controller
@RequestMapping("/trainer")
public class TrainerController {

    private static final Logger logger = LoggerFactory.getLogger(TrainerController.class);

    @Autowired
    private TrainerService trainerService;

    @GetMapping("/login")
    public String loginPage() {
        return "trainer/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
            @RequestParam String password,
            HttpSession session,
            Model model) {
        try {
            if (username == null || username.trim().isEmpty()) {
                model.addAttribute("error", "아이디를 입력해주세요.");
                return "trainer/login";
            }

            if (password == null || password.trim().isEmpty()) {
                model.addAttribute("error", "비밀번호를 입력해주세요.");
                return "trainer/login";
            }

            Trainer trainer = trainerService.login(username.trim(), password);
            if (trainer != null) {
                session.setAttribute("trainer", trainer);
                session.setAttribute("userType", "trainer");
                logger.info("트레이너 로그인 성공: {}", username);
                return "redirect:/trainer/dashboard";
            }
            model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "trainer/login";
        } catch (AuthenticationException e) {
            logger.warn("트레이너 로그인 인증 오류: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            return "trainer/login";
        } catch (Exception e) {
            logger.error("트레이너 로그인 처리 오류: {}", e.getMessage());
            model.addAttribute("error", "로그인 처리 중 오류가 발생했습니다.");
            return "trainer/login";
        }
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("trainer", new Trainer());
        return "trainer/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute Trainer trainer, Model model) {
        try {
            // 입력 검증
            if (trainer.getUsername() == null || trainer.getUsername().trim().isEmpty()) {
                model.addAttribute("error", "아이디를 입력해주세요.");
                return "trainer/register";
            }

            if (trainer.getPassword() == null || trainer.getPassword().trim().isEmpty()) {
                model.addAttribute("error", "비밀번호를 입력해주세요.");
                return "trainer/register";
            }

            if (trainer.getEmail() == null || trainer.getEmail().trim().isEmpty()) {
                model.addAttribute("error", "이메일을 입력해주세요.");
                return "trainer/register";
            }

            if (trainerService.register(trainer)) {
                logger.info("트레이너 회원가입 성공: {}", trainer.getUsername());
                return "redirect:/trainer/login";
            }
            model.addAttribute("error", "이미 존재하는 사용자명 또는 이메일입니다.");
            return "trainer/register";
        } catch (BusinessException e) {
            logger.error("트레이너 회원가입 비즈니스 오류: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            return "trainer/register";
        } catch (Exception e) {
            logger.error("트레이너 회원가입 처리 오류: {}", e.getMessage());
            model.addAttribute("error", "회원가입 처리 중 오류가 발생했습니다.");
            return "trainer/register";
        }
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Trainer trainer = (Trainer) session.getAttribute("trainer");
        if (trainer == null) {
            return "redirect:/trainer/login";
        }

        try {
            // 최신 트레이너 정보 조회
            Trainer currentTrainer = trainerService.getTrainerById(trainer.getTrainerId());
            model.addAttribute("trainer", currentTrainer);
            return "trainer/dashboard";
        } catch (Exception e) {
            logger.error("트레이너 대시보드 조회 오류: {}", e.getMessage());
            model.addAttribute("error", "대시보드를 불러오는 중 오류가 발생했습니다.");
            return "trainer/dashboard";
        }
    }

    @GetMapping("/list")
    public String trainerList(Model model) {
        try {
            model.addAttribute("trainers", trainerService.getAllTrainers());
            return "matching/trainer-list";
        } catch (Exception e) {
            logger.error("트레이너 목록 조회 오류: {}", e.getMessage());
            model.addAttribute("error", "트레이너 목록을 불러오는 중 오류가 발생했습니다.");
            return "matching/trainer-list";
        }
    }

    /**
     * 트레이너 로그아웃
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    /**
     * 트레이너 프로필 페이지
     */
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        Trainer trainer = (Trainer) session.getAttribute("trainer");
        if (trainer == null) {
            return "redirect:/trainer/login";
        }

        try {
            // 최신 정보 조회
            Trainer currentTrainer = trainerService.getTrainerById(trainer.getTrainerId());
            model.addAttribute("trainer", currentTrainer);
            return "trainer/profile";
        } catch (Exception e) {
            logger.error("트레이너 프로필 조회 오류: {}", e.getMessage());
            model.addAttribute("error", "프로필을 불러오는 중 오류가 발생했습니다.");
            return "trainer/profile";
        }
    }

    /**
     * 트레이너 프로필 업데이트
     */
    @PostMapping("/profile/update")
    public String updateProfile(@ModelAttribute Trainer trainer, HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Trainer currentTrainer = (Trainer) session.getAttribute("trainer");
            if (currentTrainer == null) {
                return "redirect:/trainer/login";
            }

            // 현재 트레이너 ID 설정
            trainer.setTrainerId(currentTrainer.getTrainerId());

            if (trainerService.updateTrainer(trainer)) {
                // 세션 정보 업데이트
                Trainer updatedTrainer = trainerService.getTrainerById(trainer.getTrainerId());
                session.setAttribute("trainer", updatedTrainer);
                redirectAttributes.addFlashAttribute("message", "프로필이 업데이트되었습니다.");
                logger.info("트레이너 프로필 업데이트 성공: {}", trainer.getTrainerId());
            } else {
                redirectAttributes.addFlashAttribute("error", "프로필 업데이트에 실패했습니다.");
            }
        } catch (BusinessException e) {
            logger.error("트레이너 프로필 업데이트 비즈니스 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            logger.error("트레이너 프로필 업데이트 오류: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", "프로필 업데이트 중 오류가 발생했습니다.");
        }

        return "redirect:/trainer/profile";
    }
}
