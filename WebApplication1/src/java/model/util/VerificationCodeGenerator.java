/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model.util;

import java.security.SecureRandom;

/**
 *
 * @author exorc
 */
public class VerificationCodeGenerator {
    public static String generateCode() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[3];
        random.nextBytes(bytes);
        return String.format("%06x", new java.math.BigInteger(1, bytes)).substring(0, 6);
    }
}

