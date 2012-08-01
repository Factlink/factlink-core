module BrowserHelper
  # Makes use of the browser gem:
  # https://github.com/fnando/browser

  def browser_supported?
    return true if browser_preferred?

    browser.firefox? or browser.safari?
  end

  def browser_preferred?
    browser.chrome?
  end

  def chrome_extension_link &block
    if can_haz :webstore_extension
      link_to "#", onclick: "chrome.webstore.install();return false;".html_safe, &block
    else
      link_to "#{FactlinkUI::Application.config.static_url}/chrome/factlink-latest.crx", &block
    end
  end

end