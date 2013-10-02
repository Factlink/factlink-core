###
// ==UserScript==
// @name  Factlink Publisher Pluging for Nu.nl
// @description Enable Factlink on Nu.nl
// @include http*://*.nu.nl/*
// @version 0.0.1
// @grant unsafeWindow
// ==/UserScript==
###

# Compile this file using: coffee -c <filename>
# Drag the compiled file (<name>.user.js) to chrome://extensions to use it.

localConfig =
  api: "http://localhost:3000"
  lib: "http://localhost:8000/lib/dist"
  srcPath: "/factlink.core.js"
  url: window.location.href
  minified: ''

# testserverConfig =
#   api: "https://factlink-testserver.inverselink.com:443"
#   lib: "https://factlink-static-testserver.inverselink.com:443/lib/dist"
#   srcPath: "/factlink.core.min.js"
#   url: window.location.href
#   minified: 'min.'

# stagingConfig =
#   api: "https://factlink-testserver.inverselink.com:443"
#   lib: "https://factlink-static-testserver.inverselink.com:443/lib/dist"
#   srcPath: "/factlink.core.min.js"
#   url: window.location.href
#   minified: 'min.'

# remoteConfig =
#   api: "https://factlink.com:443"
#   lib: "https://static.factlink.com:443/lib/dist"
#   srcPath: "/factlink.core.min.js"
#   url: window.location.href
#   minified: 'min.'

# Define the config to use here:
factlinkConfig = localConfig

# Add FactlinkConfig
ascript = document.createElement('script')
ascript.textContent = """
(function() {
  window.FactlinkConfig = #{JSON.stringify(factlinkConfig)};
})();
"""
document.body.appendChild(ascript)
document.body.removeChild(ascript)

# Inject custom publisher stylesheet
css_url = "#{factlinkConfig.lib}/css/publisher_poc/nu.nl.css"
head = document.getElementsByTagName('head').item(0)
style = document.createElement("link")
style.setAttribute('href', css_url)
style.setAttribute('rel', 'stylesheet')
style.type = "text/css"
head.appendChild(style)

# Inject custom publisher functionality
url = "#{factlinkConfig.lib}/nu.js"
body = document.getElementsByTagName('body').item(0)
script = document.createElement("script")
script.setAttribute('src', url)
script.type = "text/javascript"
body.appendChild(script)
