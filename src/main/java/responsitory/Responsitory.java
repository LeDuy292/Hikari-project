/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package responsitory;

import jakarta.servlet.http.Part;

/**
 *
 * @author ADMIN
 */
public interface Responsitory{
    
    public String saveFile(Part part, String subDir);
    public void deleteFile(String filePath);
}