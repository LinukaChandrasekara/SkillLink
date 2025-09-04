<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  com.skilllink.model.User me = (com.skilllink.model.User) session.getAttribute("authUser");
  Object rn = session.getAttribute("roleName");
  if (me == null || rn == null || !"WORKER".equals(String.valueOf(rn))) {
      response.sendRedirect(request.getContextPath()+"/login.jsp?error=Please%20login%20as%20a%20worker");
      return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Worker Messages - SkillLink</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
  <style>
    :root{ --primary:#4e73df; --light:#DCDCDC; }
    body{ background:var(--light); }
    .topbar{ background:var(--primary); color:#fff; }
    .brand{ font-weight:800; font-size:1.35rem; }
    .nav-tabs-row{ background:#fff; border-bottom:1px solid #e9ecef; }
    .nav-tabs-row .nav-link{ border:0; border-radius:.8rem; color:#333; }
    .nav-tabs-row .nav-link.active{ background:#eef2ff; color:#1f3bb3; border:1px solid #dfe4ff; }
    .btn-logout{ background:#dc3545; border-color:#dc3545; color:#fff; }
    .rounded-outer{ background:#fff; border:1px solid #e9ecef; border-radius:1rem; }
    .avatar{ width:64px; height:64px; border-radius:50%; border:3px solid rgba(255,255,255,.5); object-fit:cover; background:#e9ecef; }
    .conv-item{ padding:.6rem .7rem; border-radius:.7rem; cursor:pointer; }
    .conv-item .flex-grow-1 { min-width: 0; }
    .conv-item.active{ background:#eef2ff; border:1px solid #dfe4ff; }
    .conv-name{ font-weight:600; }
    .conv-name.truncate {
 	 overflow: hidden;
 	 text-overflow: ellipsis;
  	 white-space: nowrap;}
	.conv-last {
	  display: block;
	  overflow: hidden;
	  text-overflow: ellipsis;
	  white-space: nowrap;
	  max-width: 100%;
	}
    .badge-unread{ background:#ff4757; }
    .chat-wrap{ display:flex; flex-direction:column; height:60vh; }
    .chat-body{ flex:1 1 auto; overflow:auto; padding:1rem; background:#fafbff; border:1px solid #eef2ff; border-radius:.75rem; }
    .msg{ max-width:70%; padding:.55rem .7rem; border-radius:.7rem; margin-bottom:.5rem; }
    .msg.me{ background:#4e73df; color:#fff; margin-left:auto; }
    .msg.other{ background:#fff; border:1px solid #e9ecef; }
    .chat-input{ margin-top:.6rem; }
    .footer{ background:var(--primary); color:#fff; }
    .contact-icon{ width:36px; height:36px; display:inline-flex; align-items:center; justify-content:center; background:#fff; color:#0d6efd; border-radius:50%; }
  </style>
</head>
<body>
<header class="topbar">
  <div class="container-fluid px-3 px-md-4 py-3 d-flex justify-content-between align-items-center flex-wrap">
    <div class="d-flex align-items-center gap-2">
      <i class="bi bi-chat-dots fs-4"></i><div class="brand">Worker Dashboard - SkillLink</div>
    </div>
    <div class="d-flex align-items-center gap-3 mt-3 mt-md-0">
      <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${sessionScope.authUser.userId}" alt="">
      <div class="text-end">
        <div class="fw-bold"><c:out value="${sessionScope.authUser.fullName}"/></div>
        <div class="small opacity-75">Worker</div>
      </div>
    </div>
  </div>
  <div class="nav-tabs-row">
    <div class="container-fluid px-3 px-md-4 py-2">
      <ul class="nav">
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/worker/dashboard">Dashboard</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/worker/profile">Manage Profile</a></li>
        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/worker/dashboard#offers">Job Offers</a></li>
        <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/worker/messages">Messages</a></li>
        <div class="ms-auto">
          <a class="btn btn-logout" href="${pageContext.request.contextPath}/auth/logout">
            <i class="bi bi-box-arrow-right me-1"></i> Logout
          </a>
        </div>
      </ul>
    </div>
  </div>
</header>

<main class="container-fluid px-3 px-md-4 py-3">
  <div class="row g-3">
    <!-- Conversations -->
    <div class="col-12 col-lg-3">
      <div class="rounded-outer p-2">
        <div class="d-flex align-items-center justify-content-between mb-2">
          <h6 class="mb-0">Conversations</h6>
          <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#newChatModal">
            <i class="bi bi-plus-lg"></i>
          </button>
        </div>
        <div class="vstack gap-1">
          <c:forEach var="cvo" items="${conversations}">
            <a class="text-decoration-none text-reset"
               href="${pageContext.request.contextPath}/worker/messages?cid=${cvo.conversationId}">
              <div class="conv-item ${cvo.conversationId == currentConversationId ? 'active' : ''}">
                <div class="d-flex align-items-center gap-2">
                  <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${cvo.otherUserId}" alt="">
                  <div class="flex-grow-1">
					<div class="d-flex align-items-center justify-content-between">
					  <!-- add flex-grow-1 + truncate + a tiny right margin -->
					  <div class="conv-name truncate flex-grow-1 me-2">
					    <c:out value="${cvo.otherFullName}"/>
					  </div>
					  <c:if test="${cvo.unreadCount > 0}">
					    <span class="badge badge-unread">${cvo.unreadCount}</span>
					  </c:if>
					</div>
                    <div class="conv-last text-truncate"><c:out value="${cvo.lastMessageText}"/></div>
                  </div>
                </div>
              </div>
            </a>
          </c:forEach>

          <c:if test="${empty conversations}">
            <div class="small text-muted p-2">No conversations yet. Start one!</div>
          </c:if>
        </div>
      </div>
    </div>

    <!-- Chat area -->
    <div class="col-12 col-lg-9">
      <div class="rounded-outer p-3">
        <div class="d-flex align-items-center gap-2 mb-2">
          <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${otherUser != null ? otherUser.userId : 0}" alt="">
          <div class="fw-semibold">
            <c:choose>
              <c:when test="${otherUser != null}"><c:out value="${otherUser.fullName}"/></c:when>
              <c:otherwise>Select a conversation</c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="chat-wrap">
          <div class="chat-body" id="chatBody">
            <c:forEach var="m" items="${messages}">
              <div class="msg ${m.senderId == sessionScope.authUser.userId ? 'me' : 'other'}">
                <div class="small"><c:out value="${m.body}"/></div>
                <div class="text-end small opacity-75 mt-1">${m.createdAt}</div>
              </div>
            </c:forEach>
            <a id="end"></a>
            <c:if test="${empty messages && currentConversationId != null}">
              <div class="text-center small text-muted">No messages yet. Say hi 👋</div>
            </c:if>
            <c:if test="${currentConversationId == null}">
              <div class="text-center small text-muted">Pick a conversation on the left.</div>
            </c:if>
          </div>

          <form class="chat-input" method="post" action="${pageContext.request.contextPath}/worker/messages/send">
            <input type="hidden" name="cid" value="${currentConversationId}"/>
            <div class="input-group">
              <input type="text" class="form-control" name="body" placeholder="Type your message here" autocomplete="off" ${currentConversationId==null?'disabled':''} required />
              <button class="btn btn-primary" ${currentConversationId==null?'disabled':''}><i class="bi bi-send"></i></button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</main>

<footer class="footer mt-auto">
  <div class="container-fluid px-3 px-md-4 py-4">
    <div class="row g-4 align-items-start">
      <div class="col-12 col-md-4">
        <h6 class="mb-3">Quick Links</h6>
        <div class="d-flex flex-column gap-1">
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/worker/profile">Manage Profile</a>
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/worker/dashboard#offers">Job Offers</a>
          <a class="link-light text-decoration-none" href="${pageContext.request.contextPath}/worker/messages">Messages</a>
        </div>
      </div>
      <div class="col-12 col-md-4 text-center">
        <div class="fw-bold">SkillLink. Connecting skilled workers with local opportunities across Sri Lanka.</div>
        <div class="small opacity-75 mt-2">&copy;
          <script>document.write(new Date().getFullYear())</script> Linuka Chandrasekara
        </div>
      </div>
      <div class="col-12 col-md-4">
        <h6 class="mb-3">Contact Us</h6>
        <div class="d-flex align-items-center gap-2">
          <a class="contact-icon" href="#"><i class="bi bi-facebook"></i></a>
          <a class="contact-icon" href="#"><i class="bi bi-twitter-x"></i></a>
          <a class="contact-icon" href="#"><i class="bi bi-instagram"></i></a>
          <a class="contact-icon" href="mailto:support@skilllink.lk"><i class="bi bi-envelope"></i></a>
        </div>
      </div>
    </div>
  </div>
</footer>

<!-- Start new chat modal -->
<div class="modal fade" id="newChatModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog">
    <form class="modal-content" method="post" action="${pageContext.request.contextPath}/worker/messages/new">
      <div class="modal-header">
        <h5 class="modal-title"><i class="bi bi-person-plus me-1"></i>Start a new chat</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div class="small text-muted mb-2">Pick someone you recently interacted with:</div>
        <div class="list-group">
          <c:forEach var="u" items="${userSuggestions}">
            <label class="list-group-item d-flex align-items-center gap-2">
              <input class="form-check-input me-2" type="radio" name="otherUserId" value="${u.userId}" required>
              <img class="avatar" src="${pageContext.request.contextPath}/media/user/profile?userId=${u.userId}"/>
              <div>
                <div class="fw-semibold"><c:out value="${u.fullName}"/></div>
                <div class="small text-muted"><c:out value="${u.username}"/> · <c:out value="${u.roleName}"/></div>
              </div>
            </label>
          </c:forEach>
          <c:if test="${empty userSuggestions}">
            <div class="small text-muted">No suggestions right now.</div>
          </c:if>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary">Start</button>
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>
    </form>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // Auto-scroll to bottom on load
  (function(){
    const el = document.getElementById('chatBody');
    if (el) el.scrollTop = el.scrollHeight;
  })();
</script>
</body>
</html>
