Feature: Health-check endpoint
  Scenario: GET /health
    When I send a GET request to "/health"
    Then the response status code should be 200
    And the response JSON should contain keys "status" and "timestamp"
    And the "status" field should equal "ok"
    And the "timestamp" field should be an ISO8601 UTC string ending with "Z"
