package com.skilllink.util;

import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;

public class IOUtil {
    public static byte[] toBytes(Part part, long maxBytes) throws IOException {
        if (part == null || part.getSize() <= 0) return null;
        if (part.getSize() > maxBytes) throw new IOException("File too large");
        try (InputStream in = part.getInputStream()) {
            return in.readAllBytes(); // Java 9+
        }
    }
}
