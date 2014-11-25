Given(/^a post exists titled "(.*?)"$/) do |title|
  FactoryGirl.create(:post, title: title)
end

When(/^I visit the list of psots$/) do
  visit PostsIndex
end

Then(/^I should see a post titled "(.*?)"$/) do |title|
  on PostsIndex do |page|
    page.wait_for_ajax
    expect(page.text).to include title
  end
end

