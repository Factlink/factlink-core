module BrowserHelper
  # Makes use of the browser gem:
  # https://github.com/fnando/browser

  def browser_supported?
    return true if browser_preferred?

    if can_haz :firefox_extension
      browser.safari?
    else
      browser.firefox? or browser.safari?
    end
  end

  def browser_preferred?
    if can_haz :firefox_extension
      browser.chrome? or browser.firefox?
    else
      browser.chrome?
    end
  end

end
