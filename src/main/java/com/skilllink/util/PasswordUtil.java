package com.skilllink.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.SecureRandom;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

/**
 * Password hashing with PBKDF2-HMAC-SHA256.
 * Format stored in DB: pbkdf2_sha256:ITERATIONS:SALT_HEX:HASH_HEX
 */
public class PasswordUtil {
    // Tunables
    private static final String ALGO = "PBKDF2WithHmacSHA256";
    private static final int ITERATIONS = 120_000;   // adjust if needed
    private static final int KEY_LENGTH = 256;       // bits
    private static final int SALT_LEN = 16;          // bytes

    private static final SecureRandom RNG = new SecureRandom();

    public static String hash(String plain) {
        if (plain == null) throw new IllegalArgumentException("plain is null");
        byte[] salt = new byte[SALT_LEN];
        RNG.nextBytes(salt);

        byte[] derived = pbkdf2(plain.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
        return "pbkdf2_sha256" + ":" + ITERATIONS + ":" + toHex(salt) + ":" + toHex(derived);
    }

    public static boolean verify(String plain, String stored) {
        if (plain == null || stored == null) return false;
        String[] parts = stored.split(":");
        if (parts.length != 4 || !parts[0].equalsIgnoreCase("pbkdf2_sha256")) {
            // Unknown format (e.g., old bcrypt). Return false here, or handle migration separately.
            return false;
        }
        int iters = Integer.parseInt(parts[1]);
        byte[] salt = fromHex(parts[2]);
        byte[] expected = fromHex(parts[3]);

        byte[] computed = pbkdf2(plain.toCharArray(), salt, iters, expected.length * 8);
        return constantTimeEquals(expected, computed);
    }

    // --- helpers ---
    private static byte[] pbkdf2(char[] password, byte[] salt, int iterations, int bits) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, bits);
            SecretKeyFactory skf = SecretKeyFactory.getInstance(ALGO);
            return skf.generateSecret(spec).getEncoded();
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new IllegalStateException("PBKDF2 failure", e);
        }
    }

    private static boolean constantTimeEquals(byte[] a, byte[] b) {
        if (a == null || b == null || a.length != b.length) return false;
        int result = 0;
        for (int i = 0; i < a.length; i++) {
            result |= a[i] ^ b[i];
        }
        return result == 0;
    }

    private static String toHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder(bytes.length * 2);
        for (byte bt : bytes) {
            sb.append(String.format("%02x", bt));
        }
        return sb.toString();
    }

    private static byte[] fromHex(String hex) {
        int len = hex.length();
        byte[] out = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            out[i / 2] = (byte) Integer.parseInt(hex.substring(i, i + 2), 16);
        }
        return out;
    }
}
