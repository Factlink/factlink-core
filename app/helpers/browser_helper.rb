module BrowserHelper
  # Makes use of the browser gem:
  # https://github.com/fnando/browser
  def browser_class_name
    if browser.chrome?
      'chrome'
    elsif browser.firefox?
      'firefox'
    elsif browser.safari?
      'safari'
    elsif browser.phantom_js?
      'phantom_js'
    else
      'unsupported-browser'
    end
  end
end
