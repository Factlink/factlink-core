/*
<% if FactlinkUI::Application.config.chrome_extension_id %>
*/
  function detectChromeExtension(if_installed, if_not_installed) {
    var s = document.createElement('script');
    s.onerror = if_not_installed;
    s.onload = if_installed;
    document.body.appendChild(s);
    s.src = 'chrome-extension://<%=FactlinkUI::Application.config.chrome_extension_id%>/manifest.json';
  }

  var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
  if (is_chrome) {
    detectChromeExtension(runIfChromeExtensionIsInstalled, runIfChromeExtensionIsNotInstalled);
  }

  function runIfChromeExtensionIsInstalled(){
    $('html').addClass('chrome_extension_installed');
  }

  function runIfChromeExtensionIsNotInstalled(){
    $('html').addClass('chrome_without_extension');
  }
/*
<% end %>
*/