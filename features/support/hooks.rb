require 'watir-webdriver'

Before do
  @browser = Watir::Browser.new(:phantomjs)
end

After do
  @browser.close
end
