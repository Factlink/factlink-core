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

end