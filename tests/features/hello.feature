Feature: Hello endpoint
  Scenario: GET /
    When I send a GET request to "/"
    Then the response status code should be 200
    And the response JSON should be:
      """
      {"message": "Hello, World!"}
      """
