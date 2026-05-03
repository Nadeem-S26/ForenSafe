package com.forensafe.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    public static String hash(String plainText) {
        return BCrypt.hashpw(plainText, BCrypt.gensalt(10));
    }

    public static boolean verify(String plainText, String hashed) {
        return BCrypt.checkpw(plainText, hashed);
    }

    private PasswordUtil() {}
}
