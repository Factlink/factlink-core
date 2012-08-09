module ChromeHelper

  def use_chrome_webstore
    Rails.env == "production"
  end

  def chrome_extension_link &block
    if use_chrome_webstore
      link_to "#", onclick: "chrome.webstore.install();return false;".html_safe, &block
    else
      link_to "#{FactlinkUI::Application.config.static_url}/chrome/factlink-latest.crx", &block
    end
  end

end