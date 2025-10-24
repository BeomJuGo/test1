package com.health.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

public class FileUploadUtil {
    
    private static final String UPLOAD_DIR = "C:/Users/lom00/Desktop/Class/java fullstack/springboot framework/workspace/HealthWeb/src/main/webapp/uploads/";
    
    /**
     * Save uploaded file to the server
     * @param file Multipart file
     * @param subDir Subdirectory (e.g., "profile", "certification")
     * @return Saved file name
     * @throws IOException
     */
    public static String saveFile(MultipartFile file, String subDir) throws IOException {
        // Create directory if not exists
        String fullPath = UPLOAD_DIR + subDir + "/";
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
     * Delete file from server
     * @param filePath File path
     * @return true if deleted successfully
     */
    public static boolean deleteFile(String filePath) {
        try {
            if (filePath != null && !filePath.isEmpty()) {
                File file = new File(UPLOAD_DIR + filePath.replace("/uploads/", ""));
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
