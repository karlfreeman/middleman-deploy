Feature: test

  Scenario: whilst testing
    Given the Server is running at "test-app"
    When I go to "/index.html"
    Then I should see "<h1>Test</h1>"