// Site-wide interactions
(function () {
  function initLangDropdown() {
    var trigger = document.getElementById('LangTrigger');
    var menu = document.getElementById('LangMenu');
    if (!trigger || !menu) return;

    trigger.addEventListener('click', function (e) {
      e.stopPropagation();
      menu.classList.toggle('is-open');
    });

    document.addEventListener('click', function () {
      menu.classList.remove('is-open');
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initLangDropdown);
  } else {
    initLangDropdown();
  }
})();
