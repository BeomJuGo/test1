package com.health.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

/**
 * Spring Boot Security Configuration
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .authorizeRequests()
                .antMatchers("/", "/user/login", "/user/register", "/trainer/login", "/trainer/register",
                        "/user/fix-all-passwords", "/user/reset-password/**", "/user/debug/**",
                        "/resources/**", "/uploads/**", "/css/**", "/js/**", "/images/**")
                .permitAll()
                .antMatchers("/user/dashboard", "/user/profile", "/user/profile/**").hasRole("USER")
                .antMatchers("/trainer/dashboard", "/trainer/profile", "/trainer/profile/**", "/trainer/client-list")
                .hasRole("TRAINER")
                .antMatchers("/plan/**", "/matching/**", "/certification/**").authenticated()
                .anyRequest().permitAll()
                .and()
                .formLogin()
                .loginPage("/user/login")
                .defaultSuccessUrl("/user/dashboard")
                .failureUrl("/user/login?error=true")
                .permitAll()
                .and()
                .logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
                .and()
                .csrf()
                .disable() // 개발 단계에서는 CSRF 비활성화 (운영에서는 활성화 권장)
                .headers()
                .frameOptions()
                .deny() // 보안을 위해 frame 옵션 거부
                .and()
                .sessionManagement()
                .maximumSessions(1)
                .maxSessionsPreventsLogin(false);
    }
}