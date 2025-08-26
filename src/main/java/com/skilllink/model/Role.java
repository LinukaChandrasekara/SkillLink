package com.skilllink.model;

public enum Role {
    ADMIN(1, "admin"),
    WORKER(2, "worker"),
    CLIENT(3, "client");

    public final int id;
    public final String name;
    Role(int id, String name) { this.id = id; this.name = name; }

    public static Role fromId(int id) {
        for (Role r : values()) if (r.id == id) return r;
        return null;
    }
}
