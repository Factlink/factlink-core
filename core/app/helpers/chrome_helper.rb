module ChromeHelper

  def chrome_extension_link &block
    if FactlinkUI::Application.config.use_chrome_webstore
      link_to "#", onclick: "chrome.webstore.install();return false;".html_safe, &block
    else
      link_to "#{FactlinkUI::Application.config.static_url}/chrome/factlink-latest.crx", &block
    end
  end

end
