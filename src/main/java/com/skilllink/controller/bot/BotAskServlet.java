// src/main/java/com/skilllink/controller/bot/BotAskServlet.java
package com.skilllink.controller.bot;

import com.skilllink.dao.jdbc.DB;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.*;
import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name="BotAskServlet", urlPatterns={"/bot/ask"})
public class BotAskServlet extends HttpServlet {

  @SuppressWarnings("unchecked")
  @Override
  protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("application/json; charset=UTF-8");

    // Parse JSON
    String body = req.getReader().lines().collect(Collectors.joining("\n"));
    Map<String,Object> in = Json.minParse(body); // tiny helper below

    String userMsg = String.valueOf(in.getOrDefault("message","")).trim();
    Map<String,Object> ctx = (Map<String,Object>) in.get("context");

    if (userMsg.isEmpty()) {
      resp.getWriter().write("{\"reply\":\"Please type a question.\"}");
      return;
    }

    // Session memory (keep last ~8 turns)
    HttpSession s = req.getSession(true);
    List<Map<String,String>> memory = (List<Map<String,String>>) s.getAttribute("bot_memory");
    if (memory == null) memory = new ArrayList<>();
    memory.add(msg("user", userMsg));
    if (memory.size() > 16) memory = memory.subList(memory.size()-16, memory.size());

    // Domain context from DB: job categories
    List<String> categories = fetchCategories();

    // Build system prompt tailored to your onboarding
    String system = """
      You are SkillLink's Profile Assistant. Your job:
      - Explain how to fill registration/profile fields (full_name, nid, phone, email, age 16–100, address_line).
      - For workers, suggest a job_category based on user description. Available categories: %s
      - NEVER ask for passwords or show sensitive data back.
      - Be concise. Offer examples. If verification is asked, explain: upload NIC/ID, status becomes Pending until admin review.
      - If user gives a biography snippet, suggest a clearer 1–2 sentence version.
      """.formatted(String.join(", ", categories));

    // Compose messages
    List<Map<String,String>> convo = new ArrayList<>();
    convo.add(msg("system", system));

    // Optional: add light context about the page
    if (ctx != null) {
      String hint = "Page: "+ctx.getOrDefault("page","unknown")+
                    ", Role pane: "+ctx.getOrDefault("roleHint","unknown")+
                    ", Age: "+ctx.getOrDefault("age","")+
                    ", Experience: "+ctx.getOrDefault("experience_years","")+
                    ", Address: "+ctx.getOrDefault("address_line","");
      convo.add(msg("system", "Context: "+hint));
    }
    convo.addAll(memory);

    // Call a provider (rule-based stub you can later replace with a real LLM)
    String reply = LLMProvider.INSTANCE.reply(convo, categories, ctx);

    // Save assistant turn
    memory.add(msg("assistant", reply));
    s.setAttribute("bot_memory", memory);

    resp.getWriter().write(Json.obj("reply", reply));
  }

  private static Map<String,String> msg(String role, String content){
    Map<String,String> m = new HashMap<>();
    m.put("role", role); m.put("content", content);
    return m;
  }

  private List<String> fetchCategories() {
    try (Connection c = DB.getConnection();
         PreparedStatement ps = c.prepareStatement("SELECT name FROM job_categories ORDER BY name ASC");
         ResultSet rs = ps.executeQuery()){
      List<String> out = new ArrayList<>();
      while (rs.next()) out.add(rs.getString(1));
      return out;
    } catch (Exception e){
      return List.of("Plumbing","Electrical","Carpentry","Cleaning","Painting","AC & Refrigeration","Masonry");
    }
  }

  /* ------------ tiny JSON helpers (no external libs) ------------ */
  static class Json {
    static Map<String,Object> minParse(String s){
      // very tiny parser for this payload shape; in production use Jackson/Gson
      Map<String,Object> m = new HashMap<>();
      try {
        // naive: "message":"..."
        int i = s.indexOf("\"message\"");
        if (i>=0){
          int q1 = s.indexOf('"', s.indexOf(':',i)+1);
          int q2 = s.indexOf('"', q1+1);
          if (q1>0 && q2>q1) m.put("message", s.substring(q1+1,q2));
        }
        // ultra-naive context {"page":"..","roleHint":"..", ...}
        int ic = s.indexOf("\"context\"");
        if (ic>=0){
          int open = s.indexOf('{', ic);
          int close = s.indexOf('}', open);
          if (open>0 && close>open){
            String body = s.substring(open+1, close);
            Map<String,Object> ctx = new HashMap<>();
            for (String part : body.split(",")){
              int a = part.indexOf('"'); if (a<0) continue;
              int b = part.indexOf('"', a+1); if (b<0) continue;
              int c = part.indexOf('"', b+1); if (c<0) continue;
              int d = part.indexOf('"', c+1); if (d<0) continue;
              String key = part.substring(a+1,b);
              String val = part.substring(c+1,d);
              ctx.put(key, val);
            }
            if (!ctx.isEmpty()) m.put("context", ctx);
          }
        }
      }catch(Exception ignore){}
      return m;
    }
    static String obj(String k, String v){
      v = v.replace("\\","\\\\").replace("\"","\\\"").replace("\n","\\n");
      return "{\""+k+"\":\""+v+"\"}";
    }
  }

  /* ------------ pluggable LLM provider (rule-based stub) ------------ */
  static class LLMProvider {
    static final LLMProvider INSTANCE = new LLMProvider();

    String reply(List<Map<String,String>> messages,
                 List<String> categories,
                 Map<String,Object> ctx) {

      String last = messages.get(messages.size()-1).get("content");
      String q = last == null ? "" : last.toLowerCase(Locale.ROOT);

      // helpers
      boolean workerPane = ctx!=null && String.valueOf(ctx.getOrDefault("roleHint","")).contains("worker");
      boolean clientPane = ctx!=null && String.valueOf(ctx.getOrDefault("roleHint","")).contains("client");

      if (hasAny(q, "verify", "verification", "get verified", "id check", "nic")) {
        return """
          To get verified: open the Verification section and upload a clear NIC/ID photo. After upload your status becomes **Pending** until an admin reviews it. \
          You can keep editing your profile while pending. If **Denied**, re-upload a clearer photo and ensure your name matches your account.""";
      }

      if (hasAny(q, "what are the statuses", "status mean", "unverified", "pending", "denied", "verified")) {
        return """
          Verification statuses:
          • Unverified – no ID uploaded yet (some features limited).
          • Pending – ID uploaded; waiting for admin review.
          • Verified – ID approved; all features available.
          • Denied – photo or details didn’t match. Re-upload a clear NIC image that matches your profile name.""";
      }

      if (hasAny(q, "job category", "which category", "choose category", "change category", "update category")) {
        String list = String.join(", ", categories);
        return """
          Pick the category that best matches your main trade. You can change it later from your profile. \
          Current categories: %s. If you tell me your typical tasks, I’ll suggest the closest fit.""".formatted(list);
      }

      if (hasAny(q, "bio", "about me", "summary", "profile description")) {
        return """
          Keep your bio short and specific (1–2 sentences). Example:
          “Licensed electrician with 4+ years’ experience in wiring, panel upgrades and lighting installs. Reliable, punctual and available around Colombo.” \
          Mention years, typical tasks, tools/certifications, and coverage area.""";
      }

      if (hasAny(q, "profile picture", "photo", "avatar", "image")) {
        return """
          Use a clear headshot (JPG/PNG, square if possible). Good lighting, face centered, no heavy filters. \
          Aim for at least 400×400px so it looks sharp on listings. You can change it anytime from Manage Profile.""";
      }

      if (hasAny(q, "id photo", "nic photo", "upload id", "id guidelines")) {
        return """
          ID photo tips: use your NIC front side, flat and readable, no glare, all corners visible. \
          Make sure your profile full name matches the NIC. Upload as JPG/PNG. If rejected, re-scan with better lighting.""";
      }

      if (hasAny(q, "username", "change username", "edit username", "username rules")) {
        return """
          Your username must be unique. After registration it’s read-only in the profile. \
          Choose something professional (e.g., “ushan-electrician”). If you urgently need a change, contact support@skilllink.lk.""";
      }

      if (hasAny(q, "password", "pass", "security")) {
        return """
          Password rules: minimum 8 characters. Use a mix of letters and numbers. \
          Never share it in chat. To change it, use **Change Password** on your profile (current + new + confirm).""";
      }

      if (hasAny(q, "phone", "telephone", "contact number", "format")) {
        return """
          Phone format: local numbers like 0712345678 (no dashes). Keep it up-to-date so clients can reach you. \
          You can edit it anytime in Manage Profile.""";
      }

      if (hasAny(q, "email", "e-mail")) {
        return """
          Use a valid email you check often. We use it for important notifications and account recovery. \
          You can update it in Manage Profile → Account & Trade Details.""";
      }

      if (hasAny(q, "age", "minimum age", "how old", "age limit")) {
        return "Workers and clients must be 16–100 years old. Enter your real age; it helps us keep the platform safe.";
      }

      if (hasAny(q, "address", "location", "privacy", "where i work")) {
        return """
          Enter your city/area in **Address / Location** (no exact house number needed for privacy). \
          This helps match you with nearby jobs. You can also mention your coverage area in the bio.""";
      }

      if (hasAny(q, "experience", "years", "how many years")) {
        return """
          Put your real hands-on years in **Experience (years)**. If you’re new, enter 0 and use your bio to highlight training or apprenticeships.""";
      }

      if (hasAny(q, "no offers", "not getting jobs", "how to get more offers", "match", "matching jobs")) {
        return (workerPane ? """
          Tips to get more job offers:
          • Complete your profile (photo, bio, phone, location).
          • Pick the correct job category and experience.
          • Get **Verified** – unverified accounts have limited access.
          • Check back after admins approve new job posts in your area.
          """ :
          """
          To receive good matches: complete your profile, pick the correct role, and verify your ID. \
          Workers see more offers after admins approve relevant jobs in their area.""");
      }

      if (hasAny(q, "how to register", "sign up", "create account", "register as")) {
        return """
          Choose **Register as Worker** or **Register as Client**, fill required fields, set a strong password, and upload a profile photo. \
          Workers should also pick a job category and years of experience. You can upload the NIC later to become Verified.""";
      }

      if (hasAny(q, "after accept", "accept job", "what happens when", "offer accepted")) {
        return """
          When a worker accepts a job offer, the client is notified and a conversation opens/updates so you can coordinate details. \
          After the job is completed, the client can mark it completed and leave a review.""";
      }

      if (hasAny(q, "reviews", "rating", "stars", "feedback")) {
        return """
          Clients can review a worker after a job is marked completed. Ratings are 1–5 stars with an optional comment. \
          Your profile shows your average rating and total review count.""";
      }

      if (hasAny(q, "edit later", "update later", "change details", "how to edit")) {
        return """
          Go to **Manage Profile** to edit your photo, contact info, bio, job category and experience. \
          Most fields remain editable even while your verification is pending.""";
      }

      if (hasAny(q, "delete account", "remove account", "close my account")) {
        return "Account deletion isn’t self-serve yet. Please email support@skilllink.lk and we’ll assist you.";
      }

      // If the user gives a short bio-ish sentence, try to polish it a bit (simple heuristic)
      if (q.length() >= 12 && q.length() <= 220 && !q.contains("?") && hasAny(q, "electric", "plumb", "carp", "clean", "paint", "ac", "mason", "technician", "builder")) {
        return "Here’s a tighter bio you can use: “"+capitalize(last.trim())+" — reliable, responsive and available in your area.”";
      }

      // Fallback helpful overview (tailored by pane if we know it)
      if (workerPane) {
        return """
          I can help with: picking a job category, writing your bio, verification steps, photo/ID tips, and why offers aren’t showing. \
          Try asking: “Which category fits me?”, “How do I get verified?”, or “What should I write in my bio?”""";
      } else if (clientPane) {
        return """
          I can help clients with: completing your profile, verification, and posting better job descriptions that attract the right workers. \
          Ask: “How do I get verified?”, “What should I put in a job post?”, or “How do reviews work?”""";
      } else {
        return "I can help with profile fields, category choice, verification, and reviews. What would you like to do first?";
      }
    }

    /* ---------- helpers ---------- */
    private static boolean hasAny(String text, String... needles){
      if (text == null || text.isBlank()) return false;
      for (String n : needles) if (text.contains(n)) return true;
      return false;
    }
    private static String capitalize(String s){
      if (s.isEmpty()) return s;
      return Character.toUpperCase(s.charAt(0)) + s.substring(1);
    }

    /* Example of wiring a real provider later:
       - Use a proper JSON lib (Jackson/Gson)
       - Keep API key server-side only
       - Timeout ~20–30s, add retry/backoff
       - Never log PII

    String replyOpenAI(List<Map<String,String>> messages) {
      // POST https://api.openai.com/v1/chat/completions with model + messages
      // return assistant content
    }
    */
  }
}
	