<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  com.skilllink.model.User me = (com.skilllink.model.User) session.getAttribute("authUser");
  Object rn = session.getAttribute("roleName");
  if (me == null || rn == null || !"CLIENT".equals(String.valueOf(rn))) {
      response.sendRedirect(request.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20client");
      return;
  }
  long cid = (request.getAttribute("cid") == null) ? 0L : (Long) request.getAttribute("cid");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>SkillLink | Client • Messages</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <style>
    :root{ --primary:#4e73df; --light:#f5f6f8; }
    body{ background:var(--light); }
    .topbar{ background:var(--primary); color:#fff; }
    .brand{ font-weight:800; font-size:1.25rem; }
    .nav-tabs-row{ background:#fff; border-bottom:1px solid #e9ecef; }
    .nav-tabs-row .nav-link{ border:0; border-radius:.8rem; color:#333; }
    .nav-tabs-row .nav-link.active{ background:#eef2ff; color:#1f3bb3; border:1px solid #dfe4ff; }
    .btn-logout{ background:#dc3545; border-color:#dc3545; color:#fff; }

    .wrap{ background:#fff; border:1px solid #e9ecef; border-radius:1rem; min-height:460px; }
    .side{ border-right:1px solid #e9ecef; max-width:340px; width:100%; }
    .conv-item{ padding:.6rem .75rem; border-radius:.75rem; cursor:pointer; }
    .conv-item.active, .conv-item:hover{ background:#f1f4ff; }
    .conv-title{ font-weight:600; }
    .avatar{ width:40px; height:40px; border-radius:50%; object-fit:cover; background:#e9ecef; }
    .badge-unread{ background:#2856ea; }

    .chat{ display:flex; flex-direction:column; height:100%; }
    .chat-head{ padding: .8rem 1rem; border-bottom:1px solid #e9ecef; }
    .chat-body{ padding:1rem; overflow:auto; height:460px; }
    .bubble{ max-width:70%; padding:.55rem .8rem; border-radius:1rem; }
    .bubble.me{ background:#2856ea; color:#fff; margin-left:auto; border-bottom-right-radius:.2rem; }
    .bubble.them{ background:#f3f4f6; color:#111; margin-right:auto; border-bottom-left-radius:.2rem; }
    .chat-foot{ border-top:1px solid #e9ecef; padding:.75rem; }
  </style>
</head>
<body>

<header class="topbar">
  <div class="container-fluid px-3 px-md-4 py-3 d-flex justify-content-between align-items-center flex-wrap">
    <div class="d-flex align-items-center gap-2">
      <i class="bi bi-people fs-4"></i><div class="brand">Client Dashboard - SkillLink</div>
    </div>
    <div class="d-flex align-items-center gap-3 mt-3 mt-md-0">
      <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.authUser.userId}" alt="">
      <div class="text-end">
        <div class="fw-bold"><c:out value="${sessionScope.authUser.fullName}"/></div>
        <div class="small opacity-75">Client</div>
      </div>
      <a class="btn btn-logout" href="${pageContext.request.contextPath}/auth/logout"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
    </div>
  </div>
  <div class="nav-tabs-row">
    <div class="container-fluid px-3 px-md-4 py-2">
      <ul class="nav">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/client/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/client/profile">Manage Profile</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/client/jobs">Job Post Management</a></li>
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/client/messages">Messages</a></li>
      </ul>
    </div>
  </div>
</header>

<main class="container-fluid px-3 px-md-4 py-3">

  <c:if test="${not empty param.error}">
    <div class="alert alert-danger alert-dismissible fade show">
      <i class="bi bi-exclamation-triangle me-1"></i>${param.error}
      <button class="btn-close" data-bs-dismiss="alert"></button>
    </div>
  </c:if>

  <div class="wrap d-flex">
    <!-- Conversations -->
    <aside class="side p-2">
      <div class="px-2 pt-1 pb-2 fw-bold">Conversations</div>
      <c:forEach var="c" items="${conversations}">
        <a class="text-decoration-none text-reset d-block"
           href="${pageContext.request.contextPath}/client/messages?cid=${c.conversationId}">
          <div class="conv-item ${c.conversationId==cid ? 'active' : ''}">
            <div class="d-flex align-items-center gap-2">
              <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${c.otherUserId}" alt="">
              <div class="flex-grow-1">
                <div class="conv-title"><c:out value="${c.otherFullName}"/></div>
                <div class="small text-muted text-truncate"><c:out value="${c.lastSnippet}"/></div>
              </div>
              <c:if test="${c.unreadCount > 0}">
                <span class="badge badge-unread">${c.unreadCount}</span>
              </c:if>
            </div>
          </div>
        </a>
      </c:forEach>
      <c:if test="${empty conversations}">
        <div class="text-muted small px-2">No conversations yet.</div>
      </c:if>
    </aside>

    <!-- Chat -->
    <section class="flex-grow-1 chat">
      <div class="chat-head d-flex align-items-center justify-content-between">
        <div class="d-flex align-items-center gap-2">
          <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${withUser.userId}" alt="">
          <div>
            <div class="fw-semibold">
              <c:choose>
                <c:when test="${not empty withUser}"><c:out value="${withUser.fullName}"/></c:when>
                <c:otherwise>Select a conversation</c:otherwise>
              </c:choose>
            </div>
            <div class="small text-muted">
              <c:if test="${not empty withUser}">
                ${withUser.roleName}
              </c:if>
            </div>
          </div>
        </div>
      </div>

      <div class="chat-body" id="chatBody">
        <c:forEach var="m" items="${thread}">
          <div class="mb-2 d-flex ${m.senderId==sessionScope.authUser.userId ? 'justify-content-end' : 'justify-content-start'}">
            <div class="bubble ${m.senderId==sessionScope.authUser.userId ? 'me' : 'them'}">
              <div class="small"><c:out value="${m.body}"/></div>
              <div class="text-end small opacity-75 mt-1">${m.createdAt}</div>
            </div>
          </div>
        </c:forEach>
        <c:if test="${empty thread && cid > 0}">
          <div class="text-center text-muted small">No messages yet. Say hello 👋</div>
        </c:if>
        <div id="bottom"></div>
      </div>

      <div class="chat-foot">
        <form class="d-flex gap-2" method="post" action="${pageContext.request.contextPath}/client/messages/send">
          <input type="hidden" name="cid" value="${cid}">
          <input type="hidden" name="to"  value="${withUser.userId}">
          <input type="text" class="form-control" name="body" placeholder="Type your message here" ${cid==0?'disabled':''} required>
          <button class="btn btn-primary" ${cid==0?'disabled':''} title="Send"><i class="bi bi-send"></i></button>
        </form>
      </div>
    </section>
  </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  (function(){ var bottom = document.getElementById('bottom'); if (bottom) bottom.scrollIntoView(); })();
</script>
</body>
</html>
