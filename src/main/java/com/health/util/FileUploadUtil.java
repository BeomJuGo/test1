package com.health.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Component
public class FileUploadUtil {

    @Value("${file.upload.directory:uploads}")
    private String uploadDirectory;

    @Value("${file.max-size:10485760}")
    private long maxFileSize;

    @Value("${file.allowed.types:jpg,jpeg,png,gif,pdf}")
    private String allowedTypes;

    private static final List<String> DEFAULT_ALLOWED_TYPES = Arrays.asList("jpg", "jpeg", "png", "gif", "pdf");

    /**
     * Save uploaded file to the server
     * 
     * @param file   Multipart file
     * @param subDir Subdirectory (e.g., "profile", "certification")
     * @return Saved file name
     * @throws IOException
     */
    public String saveFile(MultipartFile file, String subDir) throws IOException {
        // Validate file
        validateFile(file);

        // Create directory if not exists
        String fullPath = uploadDirectory + "/" + subDir + "/";
        File directory = new File(fullPath);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        // Generate unique filename
        String originalFilename = file.getOriginalFilename();
        String extension = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            extension = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        String newFilename = UUID.randomUUID().toString() + extension;

        // Save file
        Path filePath = Paths.get(fullPath + newFilename);
        Files.write(filePath, file.getBytes());

        // Return relative path for database storage
        return "/uploads/" + subDir + "/" + newFilename;
    }

    /**
     * Validate uploaded file
     */
    private void validateFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IOException("파일이 선택되지 않았습니다.");
        }

        if (file.getSize() > maxFileSize) {
            throw new IOException("파일 크기가 너무 큽니다. 최대 " + (maxFileSize / 1024 / 1024) + "MB까지 업로드 가능합니다.");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            throw new IOException("파일명이 올바르지 않습니다.");
        }

        String extension = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();
        List<String> allowedExtensions = Arrays.asList(allowedTypes.split(","));

        if (!allowedExtensions.contains(extension)) {
            throw new IOException("허용되지 않는 파일 형식입니다. 허용 형식: " + allowedTypes);
        }
    }

    /**
     * Delete file from server
     * 
     * @param filePath File path
     * @return true if deleted successfully
     */
    public boolean deleteFile(String filePath) {
        try {
            if (filePath != null && !filePath.isEmpty()) {
                File file = new File(uploadDirectory + "/" + filePath.replace("/uploads/", ""));
                if (file.exists()) {
                    return file.delete();
                }
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }
}
