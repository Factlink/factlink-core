require_relative './html_editor'

class AddFactlinkToPage
  include Goliath::Rack::AsyncMiddleware
  def post_process(env, status, headers, body)
    if (200..299).cover? status
      scripts =
        factlink_proxied_url_js_var(headers['X-Proxied-Location']) +
        factlink_publisher_script(env)

      body = HtmlEditor.prepend_to_head(body, scripts)
    end
    [status, headers, body]
  end

  def factlink_proxied_url_js_var location
    jsonified_location = location.gsub(/</, '%3C').gsub(/>/, '%3E').to_json

    "<script>window.FactlinkProxiedUri = #{jsonified_location};</script>"
  end

  def factlink_publisher_script env
    jslib_uri = env.config[:jslib_uri]

    "<script async defer src=\"#{jslib_uri}\" onload=\"__internalFactlinkState(\'proxyLoaded\')\"></script>"
  end
end
