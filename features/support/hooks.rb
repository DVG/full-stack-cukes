require 'watir-webdriver'

Before do
  @browser = Watir::Browser.new(Cukes.config.browser)
end

After do
  @browser.close
end
