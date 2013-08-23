module PoltergeistStyleOverrides
  module StyleInjector
    def inject_special_test_code
      '
      <style>
        html.phantom_js * {
          transition: none !important;
          font-family:"Comic Sans MS";
        }
        html.phantom_js {
          min-height: 2000px;
        }
      </style>
      '.html_safe + super
    end
  end
  class ::ApplicationController
    prepend StyleInjector
    # It'd be nice to stick this monkey-patching into a method so that requiring
    # the file doesn't have this tricky side-effect, but class definitions are illegal in
    # methods in ruby.
  end
end