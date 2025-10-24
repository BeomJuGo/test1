package com.health.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.health.interceptor.LoginCheckInterceptor;

/**
 * Spring Boot Standard Web Configuration
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public LoginCheckInterceptor loginCheckInterceptor() {
        return new LoginCheckInterceptor();
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginCheckInterceptor())
                .addPathPatterns("/user/**", "/trainer/**", "/matching/**", "/plan/**", "/certification/**")
                .excludePathPatterns("/user/login", "/user/register", "/trainer/login", "/trainer/register",
                        "/static/**", "/uploads/**", "/error/**", "/h2-console/**");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Static resources (CSS, JS, Images) - Standard Spring Boot path
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");

        // Uploaded files
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:uploads/");
    }
}