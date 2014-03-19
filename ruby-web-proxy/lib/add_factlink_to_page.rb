require_relative './html_editor'

class AddFactlinkToPage
  include Goliath::Rack::AsyncMiddleware
  def post_process(env, status, headers, body)
    if env[:web_proxy_proxied]
      html_editor = HtmlEditor.new(body)
      html_editor.prepend_to_head(
        factlink_proxied_url_js_var(env) +
        factlink_publisher_script(env)
      )
      body = html_editor.to_s
    end
    [status, headers, body]
  end

  def factlink_proxied_url_js_var env
    location = env[:web_proxy_proxied_location]
    jsonified_location = location.gsub(/</, '%3C').gsub(/>/, '%3E').to_json

    "<script>window.FactlinkProxiedUri = #{jsonified_location};</script>"
  end

  def factlink_publisher_script env
    jslib_uri = env.config[:jslib_uri]

    "<script async defer src=\"#{jslib_uri}\" onload=\"__internalFactlinkState(\'proxyLoaded\')\"></script>"
  end
end
