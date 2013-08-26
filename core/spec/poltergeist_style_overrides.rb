module PoltergeistStyleOverrides
  module StyleInjector
    def inject_special_test_code
      (<<-'SNIPPET'
      <style>
        * { transition: none !important; }
        html.phantom_js * { font-family:"Comic Sans MS"; }
        html.phantom_js { min-height: 2000px; }
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
