Feature: Login
  As user
  I want to login and see my application working
  In order to use it

  Scenario: user cannot log in
    Given wrong credentials
    When user tries to log in
    Then he fails

  Scenario: user logs in first time
    Given no user groups exists
    And user credentials
    When user tries to log in
    Then he sees settings page

  Scenario: user logs in
    Given user credentials
    When user tries to log in
    Then he sees stop_list page

  Scenario: admin logs in
    Given admin credentials
    When user tries to log in
    Then on settings page he sees all of the buttons