module PoltergeistStyleOverrides
  module StyleInjector
    def inject_special_test_code
      (<<-'SNIPPET'
      <style>
        * { transition: none !important; }
        * { font-family:"Helvetica" !important;}
        html.phantom_js body { -webkit-transform: rotate(0.00001deg); }
        html.phantom_js body.client { overflow: auto; }
        html.phantom_js .discussion-sidebar-outer { position: absolute; min-height:100%; overflow-y: auto; bottom: auto; }
        html.phantom_js .discussion-sidebar-inner { position: relative; left: 300px; }
        img {
          display: inline-block;
          border: 1px solid #f0f;
        }
        .browser-window-video { display: none; }
      </style>
      <script>
        document.addEventListener("DOMContentLoaded", function(){
          if(window.test_counter && /^(::1|127\.0\.0\.1|localhost)$/.test(window.location.hostname)) {
            window.$.fx.off = true;
            $(function(){ window.$.support.transition = undefined; });
          } else {
            console.error("Very odd: test code loaded outside of a valid context!",window.test_counter, window.location.hostname);
          }
        });
      </script>
      SNIPPET
      ).html_safe + super
    end
  end
  class ::ApplicationController
    prepend StyleInjector
    # It'd be nice to stick this monkey-patching into a method so that requiring
    # the file doesn't have this tricky side-effect, but class definitions are illegal in
    # methods in ruby.
  end
end
