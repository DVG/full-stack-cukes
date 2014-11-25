Given(/^a post exists titled "(.*?)"$/) do |title|
  FactoryGirl.create(:post, title: title)
end

When(/^I visit the list of psots$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a post titled "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

