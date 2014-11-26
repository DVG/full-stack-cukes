class PostsNew
  include PageObject
  page_url "#{Cukes.config.host}/posts/new"

  def initialize_page
    wait_for_ajax
  end

  text_field :title, id: "post_title"
  text_field :body, id: "post_body"
  button :submit, id: "post_submit"

  def create_post(options={title: "Hello World", body: "Goodbye Moon"})
    self.title = options[:title]
    self.body = options[:body]
    submit
  end
end
