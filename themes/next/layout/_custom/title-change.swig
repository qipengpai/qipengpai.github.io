<!-- 页面 title 进入/离开 效果 -->
{% if theme.title_change %}
  <script type="text/javascript">var OriginTitile=document.title,st;document.addEventListener("visibilitychange",function(){document.hidden?(document.title="(ง •_•)ง 加油!!!",clearTimeout(st)):(document.title="(ง •_•)ง Thank you~ "+OriginTitile,st=setTimeout(function(){document.title=OriginTitile},4e3))})</script>
{% endif %}
