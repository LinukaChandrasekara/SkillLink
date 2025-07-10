package com.skilllink.controller;

import com.skilllink.dao.UserDAO;
import com.skilllink.model.User;
import com.skilllink.util.AuthUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/auth/register"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 5,      // 5 MB
    maxRequestSize = 1024 * 1024 * 5 * 5 // 25 MB
)
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDao = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Parse the multipart request
            Map<String, String> formFields = new HashMap<>();
            Map<String, Part> fileParts = new HashMap<>();
            
            Collection<Part> parts = request.getParts();
            for (Part part : parts) {
                if (part.getContentType() == null) {
                    // Regular form field
                    formFields.put(part.getName(), 
                        new BufferedReader(new InputStreamReader(part.getInputStream()))
                            .lines().collect(Collectors.joining("\n")));
                } else {
                    // File upload part
                    fileParts.put(part.getName(), part);
                }
            }
            
            // Get form fields from the parsed data
            String username = formFields.get("username");
            String email = formFields.get("email");
            String password = formFields.get("password");
            String phone = formFields.get("phone");
            String userType = formFields.get("userType");
            String clientType = formFields.get("clientType");
            
            // Validate inputs
            if (username == null || email == null || password == null) {
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=Missing required fields");
                return;
            }
            
            // Check if user already exists
            if (userDao.findByUsernameOrEmail(username) != null || userDao.findByUsernameOrEmail(email) != null) {
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=Username or email already exists");
                return;
            }
            

            
            // Create new user
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPassword(password); 
            newUser.setEmail(email);
            newUser.setPhone(phone);
            newUser.setUserType(userType);
            newUser.setClientType(clientType);
            newUser.setVerified(false); // Default to unverified
            
            // Handle profile picture upload
            Part profilePicturePart = fileParts.get("profilePicture");
            if (profilePicturePart != null && profilePicturePart.getSize() > 0) {
                String fileName = Paths.get(profilePicturePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                
                // Create upload directory if it doesn't exist
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                
                // Save the file
                String filePath = uploadPath + File.separator + fileName;
                profilePicturePart.write(filePath);
                
                // Store relative path in database
                newUser.setProfilePicture("uploads/" + fileName);
            }
            
            // Handle ID proof upload
            Part idProofPart = fileParts.get("idProof");
            if (idProofPart != null && idProofPart.getSize() > 0) {
                String fileName = Paths.get(idProofPart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                
                // Create upload directory if it doesn't exist
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                
                // Save the file
                String filePath = uploadPath + File.separator + fileName;
                idProofPart.write(filePath);
                
                // Store relative path in database
                newUser.setIdProof("uploads/" + fileName);
            }
            
            // Save user to database
            boolean success = userDao.createUser(newUser);
            
            if (success) {
                String successMsg = URLEncoder.encode("Registration successful. Please login.", "UTF-8");
                response.sendRedirect(request.getContextPath() + "/login.jsp?success=" + successMsg);
            } else {
                response.sendRedirect(request.getContextPath() + "/register.jsp?error=Registration failed");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=Error processing form: " + e.getMessage());
        }
    }
}