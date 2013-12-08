@upd
Feature: update prices
  As user
  I want my sites update prices successfully
  In order to work

#  Scenario: user imports all the data
#    Given user is ydachnik
#    And user tries to import all sites xlsx file
#    And user tries to import standard site xlsx file
#    And user tries to import shop xlsx file
#    Then all data are loaded

  Scenario Outline: user starts updating prices
    Given user is ydachnik
    When my <site> updates
    Then it is updated properly
  Examples:
    |site|
    |21vek.by|
    |50.by   |

