Feature: Posts

  Scenario: List of Posts
    Given a post exists titled "Hello World!"
    When I visit the list of psots
    Then I should see a post titled "Hello World!"

  @focus
  Scenario: Create a post
    Given no posts exist
    When I create a post titled "Orange is the New Black"
    Then I should see a post titled "Orange is the New Black"
