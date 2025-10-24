package com.health.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 시큐리티 설정 (선택)
 * 인터셉터를 통한 로그인 체크, 권한 체크 등
 */
@Configuration
public class SecurityConfig implements WebMvcConfigurer {
    
    /**
     * 인터셉터 등록
     * 향후 로그인 체크, 권한 체크 등의 인터셉터를 추가할 수 있습니다.
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 로그인 체크 인터셉터 예시
        // registry.addInterceptor(new LoginCheckInterceptor())
        //         .addPathPatterns("/user/**", "/trainer/**", "/matching/**", "/plan/**", "/certification/**")
        //         .excludePathPatterns("/user/login", "/user/register", "/trainer/login", "/trainer/register", "/resources/**");
    }
    
    /* 
     * 참고: Spring Security를 사용할 경우 다음과 같이 설정할 수 있습니다.
     * 
     * @Bean
     * public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
     *     http
     *         .authorizeHttpRequests(auth -> auth
     *             .requestMatchers("/user/login", "/user/register").permitAll()
     *             .requestMatchers("/user/**").hasRole("USER")
     *             .requestMatchers("/trainer/**").hasRole("TRAINER")
     *             .anyRequest().authenticated()
     *         )
     *         .formLogin(form -> form
     *             .loginPage("/user/login")
     *             .defaultSuccessUrl("/user/dashboard")
     *         )
     *         .logout(logout -> logout
     *             .logoutSuccessUrl("/")
     *         );
     *     return http.build();
     * }
     */
}
