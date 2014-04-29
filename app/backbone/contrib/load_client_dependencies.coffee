client_dependencies_loaded = false

Factlink.load_client_dependencies = ->
  return if client_dependencies_loaded
  client_dependencies_loaded = true

  return if Factlink.Global.environment == 'test'

  `
    window.twttr = (function (d,s,id) {
      var t, js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) return; js=d.createElement(s); js.id=id;
      js.src="https://platform.twitter.com/widgets.js"; fjs.parentNode.insertBefore(js, fjs);
      return window.twttr || (t = { _e: [], ready: function(f){ t._e.push(f) } });
    }(document, "script", "twitter-wjs"));
  `

  $('body').prepend('<div id="fb-root"></div>')
  `
    window.fbAsyncInit = function() {
      FB.init({
        appId: Factlink.Global.facebook_app_id,
        status: false,
        xfbml: false
      });
    };

    (function(d, s, id){
       var js, fjs = d.getElementsByTagName(s)[0];
       if (d.getElementById(id)) {return;}
       js = d.createElement(s); js.id = id;
       js.src = "https://connect.facebook.net/en_US/all.js";
       fjs.parentNode.insertBefore(js, fjs);
     }(document, 'script', 'facebook-jssdk'));
  `

  null
