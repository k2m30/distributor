Feature: import
  As user
  I want to import and reimport my data files
  In order to work

  Scenario: user imports all sites file first time
    Given user is ydachnik
    And no sites exist
    When user tries to import all sites xlsx file
    Then there are no groups created
    And there are no items created
    And sites numbers increases to total number of rows on all sheets in file

  Scenario: user imports all sites file next time
    Given user is ydachnik
    And sites exist
    When user tries to import all sites xlsx file
    Then there are no groups created
    And there are no items created
    And there are no sites created

  Scenario: user imports standard site file after he imported all sites
    Given user is ydachnik
    And sites exist
    When user tries to import standard site xlsx file
    Then groups are created
    And items are created
    And standard site is created

  Scenario: user imports shops file after he imported standard file
    Given user is ydachnik
    And standard site is created
    When user tries to import shop xlsx file
    Then user groups contains sites from file

  Scenario: user imports standard site file before he imported all sites
    Given user is ydachnik
    And no sites exist
    When user tries to import standard site xlsx file
    Then groups are created
    And items are created
    And standard site is created