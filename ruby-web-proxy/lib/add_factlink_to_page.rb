require_relative './html_editor'

class AddFactlinkToPage
  include Goliath::Rack::AsyncMiddleware
  def post_process(env, status, headers, body)
    if env[:web_proxy_proxied]
      location = env[:web_proxy_proxied_location]

      jsonified_location = location.gsub(/</, '%3C').gsub(/>/, '%3E').to_json
      jslib_uri = env.config[:jslib_uri]

      factlink_proxied_url_js_var = "
        <script>window.FactlinkProxiedUri = #{jsonified_location};</script>
      "

      factlink_publisher_script = "
       <script async defer
               src=\"#{jslib_uri}\"
               onload=\"__internalFactlinkState(\'proxyLoaded\')\"
         ></script>
      "

      html_editor = HtmlEditor.new(body)
      html_editor.prepend_to_head(factlink_proxied_url_js_var + factlink_publisher_script)
      body = html_editor.to_s
    end
    [status, headers, body]
  end
end
