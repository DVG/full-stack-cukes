Given(/^a post exists titled "(.*?)"$/) do |title|
  create(:post, title: title)
end

When(/^I visit the list of psots$/) do
  visit PostsIndex
end

Then(/^I should see a post titled "(.*?)"$/) do |title|
  on PostsIndex do |page|
    page.wait_for_ajax
    expect(page).to have_a_post_titled(title)
  end
end

Given(/^no posts exist$/) do
  # Nothing to do!
end

When(/^I create a post titled "(.*?)"$/) do |title|
  visit PostsNew
  on PostsNew do |page|
    page.create_post(title: title, body: "Some Body")
  end
end
