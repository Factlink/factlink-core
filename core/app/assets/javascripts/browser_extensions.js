/*
<% if FactlinkUI::Application.config.chrome_extension_id %>
*/

(function() {
  function detectChromeExtension(if_installed, if_not_installed) {
    var s = document.createElement('script');
    s.onerror = if_not_installed;
    s.onload = if_installed;
    document.body.appendChild(s);
    s.src = 'chrome-extension://<%=FactlinkUI::Application.config.chrome_extension_id%>/manifest.json';
  }

  function is_chrome() {
    return navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
  }

  if (is_chrome()) {
    $('html').addClass('is-chrome');

    detectChromeExtension(runIfChromeExtensionIsInstalled, runIfChromeExtensionIsNotInstalled);
  } else {
    $('html').addClass('no-chrome');
  }

  function runIfChromeExtensionIsInstalled(){
    $('html').addClass('chrome_extension_installed');
  }

  function runIfChromeExtensionIsNotInstalled(){
    $('html').addClass('chrome_without_extension');
  }


}());

/*
<% end %>
*/
