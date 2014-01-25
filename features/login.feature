@no_db_clean
Feature: Login
  As user
  I want to login and see my application working
  In order to use it

  Scenario: user cannot log in
    Given wrong credentials
    And test_data import is done
    When user logs in
    Then he fails

  Scenario: user logs in successfully
    Given test_user credentials
    And test_data import is done
    When user logs in
    Then he sees stop_list page