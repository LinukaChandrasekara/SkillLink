<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    com.skilllink.model.User me = (com.skilllink.model.User) session.getAttribute("authUser");
    Object rn = session.getAttribute("roleName");
    if (me == null || rn == null || !"ADMIN".equals(String.valueOf(rn))) {
        response.sendRedirect(request.getContextPath()+"/login.jsp?error=Please%20login%20as%20an%20administrator");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Messages - SkillLink</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <style>
    :root{ --primary:#4e73df; --light:#f5f6f8; }
    body{ background:var(--light); }
    .app{ min-height:100vh; }
    .topbar{ background:var(--primary); color:#fff; }
    .brand{ font-weight:800; font-size:1.35rem; }
    .nav-tabs-row{ background:#fff; border-bottom:1px solid #e9ecef; }
    .nav-tabs-row .nav-link{ border:0; border-radius:.8rem; color:#333; }
    .nav-tabs-row .nav-link.active{ background:#eef2ff; color:#1f3bb3; border:1px solid #dfe4ff; }
    .btn-logout{ background:#dc3545; border-color:#dc3545; color:#fff; }
    .rounded-outer{ background:#fff; border:1px solid #e9ecef; border-radius:1rem; }
    .footer{ background:var(--primary); color:#fff; }
    .contact-icon{ width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center; background:#fff; color:#0d6efd; border-radius:50%; }
    .avatar{ width:40px; height:40px; border-radius:50%; object-fit:cover; background:#e9ecef; }
    .left-pane{ height: 65vh; overflow-y:auto; }
    .right-pane{ height: 65vh; display:flex; flex-direction:column; }
    .chat-scroll{ flex:1; overflow-y:auto; }
    .msg{ max-width:75%; padding:.6rem .8rem; border-radius:1rem; }
    .msg.me{ background:#4e73df; color:#fff; margin-left:auto; border-bottom-right-radius:.3rem; }
    .msg.them{ background:#eef2ff; color:#111; margin-right:auto; border-bottom-left-radius:.3rem; }
    .conv-item{ border-radius:.75rem; border:1px solid #e9ecef; padding:.6rem; cursor:pointer; }
    .conv-item.active{ border-color:#4e73df; background:#f3f6ff; }
    .conv-item:hover{ background:#f8f9ff; }
    .small-muted{ font-size:.85rem; color:#6c757d; }
  </style>
</head>
<body>
<div class="app d-flex flex-column">

  <!-- TOP BAR -->
  <header class="topbar">
    <div class="container-fluid px-3 px-md-4 py-3">
      <div class="d-flex flex-column flex-lg-row align-items-start align-items-lg-center justify-content-between">
        <div class="d-flex align-items-center gap-2">
          <i class="bi bi-tools fs-4"></i>
          <div class="brand">Admin Dashboard - SkillLink</div>
        </div>
        <div class="d-flex align-items-center gap-3 mt-3 mt-lg-0">
          <img class="avatar"
               src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.authUser.userId}"
               alt="Profile">
          <div class="text-end">
            <div class="fw-bold"><c:out value="${sessionScope.authUser.fullName}"/></div>
            <div class="small opacity-75">Administrator</div>
          </div>
          <a class="btn btn-logout" href="${pageContext.request.contextPath}/auth/logout">
            <i class="bi bi-box-arrow-right me-1"></i> Logout
          </a>
        </div>
      </div>
    </div>

    <!-- NAV TABS -->
    <div class="nav-tabs-row">
      <div class="container-fluid px-3 px-md-4 py-2 d-flex align-items-center">
        <ul class="nav">
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users">Manage users</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a></li>
          <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/jobs">Job Approvals</a></li>
          <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/admin/messages">Messages</a></li>
        </ul>
        <div class="ms-auto">
          <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#startModal">
            <i class="bi bi-chat-dots me-1"></i> New chat
          </button>
        </div>
      </div>
    </div>
  </header>

  <!-- MAIN -->
  <main class="flex-grow-1 container-fluid px-3 px-md-4 py-3 py-md-4">

    <c:if test="${not empty error}">
      <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success"><i class="bi bi-check-circle-fill me-2"></i>${success}</div>
    </c:if>

    <div class="rounded-outer p-3">
      <h5 class="mb-3">Messages</h5>
      <div class="row g-3">
        <!-- Left: conversations -->
        <div class="col-12 col-lg-4">
          <div class="left-pane">
            <c:forEach var="cvo" items="${conversations}">
              <a class="text-decoration-none text-reset" 
                 href="${pageContext.request.contextPath}/admin/messages?cid=${cvo.conversationId}">
                <div class="conv-item ${cvo.conversationId == currentConversationId ? 'active' : ''} mb-2">
                  <div class="d-flex align-items-center">
                    <img class="avatar me-2"
                         src="${pageContext.request.contextPath}/media/user/profile?userId=${cvo.otherUserId}" alt="">
                    <div class="flex-grow-1">
                      <div class="fw-semibold">${cvo.title}</div>
                      <div class="small-muted text-truncate">${cvo.lastSnippet}</div>
                    </div>
                    <c:if test="${cvo.unreadCount > 0}">
                      <span class="badge text-bg-primary ms-2">${cvo.unreadCount}</span>
                    </c:if>
                  </div>
                </div>
              </a>
            </c:forEach>

            <c:if test="${empty conversations}">
              <div class="text-muted">No conversations yet.</div>
            </c:if>
          </div>
        </div>

        <!-- Right: thread -->
        <div class="col-12 col-lg-8">
          <div class="rounded-outer p-3 right-pane">
            <div class="d-flex align-items-center gap-2 mb-2">
              <img class="avatar"
                   src="${pageContext.request.contextPath}/media/user/profile?userId=${otherUser.userId}" alt="">
              <div>
                <div class="fw-semibold"><c:out value="${otherUser.fullName}"/></div>
                <div class="small-muted">${otherUser.roleName}</div>
              </div>
            </div>

            <div id="chat" class="chat-scroll border rounded p-2">
              <c:forEach var="m" items="${messages}">
                <div class="d-flex mb-2 ${m.senderId == sessionScope.authUser.userId ? 'justify-content-end' : ''}">
                  <div class="msg ${m.senderId == sessionScope.authUser.userId ? 'me' : 'them'}">
                    <div class="small">${m.body}</div>
                    <div class="small-muted mt-1">${m.createdAt}</div>
                  </div>
                </div>
              </c:forEach>

              <c:if test="${empty messages}">
                <div class="text-center text-muted py-5">Start the conversation…</div>
              </c:if>
            </div>

            <form class="mt-2" method="post" action="${pageContext.request.contextPath}/admin/messages/send">
              <input type="hidden" name="conversationId" value="${currentConversationId}">
              <div class="input-group">
                <input type="text" name="body" class="form-control" placeholder="Type your message here" required maxlength="2000">
                <button class="btn btn-primary"><i class="bi bi-send-fill"></i></button>
              </div>
            </form>
          </div>
        </div>

      </div>
    </div>
  </main>

  <!-- FOOTER -->
  <footer class="footer mt-auto">
    <div class="container-fluid px-3 px-md-4 py-4">
      <div class="row g-4 align-items-start">
        <div class="col-12 col-md-4">
          <h6 class="mb-3">Quick Links</h6>
          <div class="d-flex flex-column gap-1">
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/users">Manage users</a>
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/verifications">Verifications</a>
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/jobs">Job Approvals</a>
            <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/admin/messages">Messages</a>
          </div>
        </div>
        <div class="col-12 col-md-4 text-center">
          <div class="fw-bold">SkillLink. Connecting skilled workers with local opportunities across Sri Lanka.</div>
          <div class="small opacity-75 mt-2">&copy; <script>document.write(new Date().getFullYear())</script> Linuka Chandrasekara</div>
        </div>
        <div class="col-12 col-md-4">
          <h6 class="mb-3">Contact Us</h6>
          <div class="d-flex align-items-center gap-2">
            <a class="contact-icon" href="#"><i class="bi bi-facebook"></i></a>
            <a class="contact-icon" href="#"><i class="bi bi-twitter"></i></a>
            <a class="contact-icon" href="#"><i class="bi bi-instagram"></i></a>
            <a class="contact-icon" href="mailto:support@skilllink.lk"><i class="bi bi-envelope"></i></a>
          </div>
        </div>
      </div>
    </div>
  </footer>

</div>

<!-- Start conversation modal -->
<div class="modal fade" id="startModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <form class="modal-content" method="post" action="${pageContext.request.contextPath}/admin/messages/start">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-chat-dots me-1"></i>Start new chat</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <label class="form-label">Select user</label>
        <select class="form-select" name="userId" required>
          <c:forEach var="u" items="${userSuggestions}">
            <option value="${u.userId}">${u.fullName} &nbsp;(@${u.username}) — ${u.roleName}</option>
          </c:forEach>
        </select>
        <div class="form-text">Shows a small list of recent/active users. (You can extend with a search UI later.)</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary"><i class="bi bi-arrow-right-circle me-1"></i> Start</button>
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Scroll chat to bottom on load:
  (function(){ const c = document.getElementById('chat'); if (c) c.scrollTop = c.scrollHeight; })();
</script>
</body>
</html>
