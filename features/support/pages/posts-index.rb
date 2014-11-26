class PostsIndex
  include PageObject
  page_url "#{Cukes.config.host}/posts"

  def post_titles
    browser.h2s(class: "title").map(&:text)
  end

  def has_a_post_titled?(title)
    post_titles.include? title
  end
end
