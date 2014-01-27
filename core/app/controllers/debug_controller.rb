class DebugController < ApplicationController
  def delayed_javascript
    sleep 3
    render js: "console.log('loaded intentionally delayed script!');"
  end
end
