package com.health.controller;

import com.health.model.Trainer;
import com.health.service.TrainerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;

/**
 * Trainer 컨트롤러
 */
@Controller
@RequestMapping("/trainer")
public class TrainerController {
    
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
        Trainer trainer = trainerService.login(username, password);
        if (trainer != null) {
            session.setAttribute("trainer", trainer);
            session.setAttribute("userType", "trainer");
            return "redirect:/trainer/dashboard";
        }
        model.addAttribute("error", "아이디 또는 비밀번호가 올바르지 않습니다.");
        return "trainer/login";
    }
    
    @GetMapping("/register")
    public String registerPage() {
        return "trainer/register";
    }
    
    @PostMapping("/register")
    public String register(@ModelAttribute Trainer trainer, Model model) {
        if (trainerService.register(trainer)) {
            return "redirect:/trainer/login";
        }
        model.addAttribute("error", "이미 존재하는 사용자명입니다.");
        return "trainer/register";
    }
    
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Trainer trainer = (Trainer) session.getAttribute("trainer");
        if (trainer == null) {
            return "redirect:/trainer/login";
        }
        return "trainer/dashboard";
    }
    
    @GetMapping("/list")
    public String trainerList(Model model) {
        model.addAttribute("trainers", trainerService.getAllTrainers());
        return "matching/trainer-list";
    }
}
