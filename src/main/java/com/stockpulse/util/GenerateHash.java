package com.stockpulse.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility to generate BCrypt hashes
 * Run this to get the correct hash for a password
 */
public class GenerateHash {
    public static void main(String[] args) {
        String password = "admin123";
        String hash = BCrypt.hashpw(password, BCrypt.gensalt(10));
        System.out.println("Password: " + password);
        System.out.println("BCrypt Hash: " + hash);
        
        // Verify it works
        boolean matches = BCrypt.checkpw(password, hash);
        System.out.println("Verification: " + (matches ? "PASS" : "FAIL"));
    }
}
