<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<style>
  .bot-fab{position:fixed; right:20px; bottom:20px; z-index:1055;}
  .bot-fab .btn{width:56px;height:56px;border-radius:50%; box-shadow:0 10px 30px rgba(0,0,0,.25);}
  .bot-msg{max-width:80%; border-radius:.75rem; padding:.5rem .75rem;}
  .bot-msg.user{margin-left:auto; background:#4e73df; color:#fff;}
  .bot-msg.bot{background:#fff; border:1px solid #e9ecef;}
  .bot-typing{font-size:.85rem; opacity:.7;}
  .bot-quick{gap:.5rem; flex-wrap:wrap;}
</style>

<div class="bot-fab">
  <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#botModal">
    <i class="fa-solid fa-robot"></i>
  </button>
</div>

<div class="modal fade" id="botModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><i class="fa-solid fa-robot me-2"></i>Profile Helper</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body" style="background:#f8f9fc">
        <div id="botStream" class="d-flex flex-column gap-2" style="max-height:50vh; overflow:auto">
          <div class="bot-msg bot">
            Hi! I can help you complete your profile. Ask me anything, or try one of these:
          </div>
          <div class="d-flex bot-quick">
            <button class="btn btn-sm btn-outline-primary" data-botq="Which job category fits me?">Which job category fits me?</button>
            <button class="btn btn-sm btn-outline-primary" data-botq="How do I get verified?">How do I get verified?</button>
            <button class="btn btn-sm btn-outline-primary" data-botq="What should I write in my bio?">What should I write in my bio?</button>
          </div>
        </div>
      </div>

      <div class="modal-footer">
        <form id="botForm" class="w-100 d-flex gap-2" onsubmit="return false;">
          <input type="text" id="botInput" class="form-control" placeholder="Type your question…" autocomplete="off">
          <button class="btn btn-primary" id="botSend"><i class="fa-solid fa-paper-plane"></i></button>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  var stream = document.getElementById('botStream');
  var input  = document.getElementById('botInput');
  var send   = document.getElementById('botSend');
  var BASE   = '<%= request.getContextPath() %>'; // safe: JSP scriplet, no EL

  function collectContext(){
    return {
      page: location.pathname.indexOf('/register')>=0 ? 'register' :
            location.pathname.indexOf('/profile')>=0  ? 'profile'  : 'unknown',
      roleHint: (document.querySelector('#worker-pane.show,#client-pane.show')||{}).id || null,
      full_name: (document.querySelector('[name="full_name"]')||{}).value || '',
      age: (document.querySelector('[name="age"]')||{}).value || '',
      address_line: (document.querySelector('[name="address_line"]')||{}).value || '',
      job_category_id: (document.querySelector('[name="job_category_id"]')||{}).value || '',
      experience_years: (document.querySelector('[name="experience_years"]')||{}).value || ''
    };
  }

  function addMsg(text, who){
    var div = document.createElement('div');
    // IMPORTANT: string concatenation (no JS template literal -> no ${})
    div.className = 'bot-msg ' + (who === 'user' ? 'user' : 'bot');
    div.textContent = text;
    stream.appendChild(div);
    stream.scrollTop = stream.scrollHeight;
  }

  async function ask(q){
    if(!q || !q.trim()) return;
    addMsg(q,'user');
    input.value='';

    var typing = document.createElement('div');
    typing.className='bot-typing small ms-1';
    typing.textContent='Assistant is typing…';
    stream.appendChild(typing);
    stream.scrollTop = stream.scrollHeight;

    try{
      var res = await fetch(BASE + '/bot/ask', {
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body: JSON.stringify({ message:q, context: collectContext() })
      });
      var data = await res.json();
      typing.remove();
      addMsg((data && data.reply) ? data.reply : 'Sorry, I could not generate a reply right now.','bot');
    }catch(e){
      typing.remove();
      addMsg('Network error. Please try again.','bot');
    }
  }

  send.addEventListener('click', function(){ ask(input.value); });
  input.addEventListener('keydown', function(e){ if(e.key==='Enter'){ e.preventDefault(); ask(input.value); } });
  document.querySelectorAll('[data-botq]').forEach(function(b){
    b.addEventListener('click', function(){ ask(b.getAttribute('data-botq')); });
  });
})();
</script>
