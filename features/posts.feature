Feature: Posts

  Scenario: List of Posts
    Given a post exists titled "Hello World!"
    When I visit the list of psots
    Then I should see a post titled "Hello World!"
