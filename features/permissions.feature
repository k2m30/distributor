@allow-rescue @no_db_clean @scenario
Feature: Permissions
  As user or admin
  I want my users to login and get access only to pages I have permissions to
  I want admin to have access to all pages
  In order not to share users' data between them
  And provide admin access to all of the data


  Scenario: user logs in and visits pages
    Given test_user credentials
    And user logs in

    When user visits groups controller pages with name = KARCHER that belong to test_user
    Then he can see show page(s)
    But he cannot see index, new, edit page(s)

    When user visits show page
    Then he should see text test_site1
    But he should not see text test_site6
    And he sees 3 elements with css = '.group'

    When user visits groups controller pages with name = KARCHER that belong to test_admin
    Then he cannot see index, show, new, edit page(s)

  Scenario: admin logs in and visits pages
    Given test_admin credentials
    And user logs in

    When user visits groups controller pages with name = KARCHER that belong to test_admin
    Then he can see show page(s)
    But he cannot see index, new, edit page(s)

    When user visits show page
    Then he should see text test_site1
    And he should see text test_site6
    And he sees 6 elements with css = '.group'

    When user visits groups controller pages with name = KARCHER that belong to test_user
    Then he can see show page(s)



#  Scenario: admin logs in
#    Given admin credentials
#    When user visits group controller pages
#    Then he can see only show page
#    But he cannot see index, new, create, show, edit, update, destroy pages