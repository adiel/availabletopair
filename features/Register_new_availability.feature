Feature: Register new availability
  In order that anyone looking for a pair knows when I am available
  As an open source developer
  I want to publish my availability to pair in advance

# Need to automate / stub openID somehow to get the test back in
  Scenario: Anonymous user tries to add new availability and is redirected to login
    Given no availabilities in the system
    And a user "jeffosmith" with openid url "http://someopenid.url"
    When I am on the homepage
    Then I should see "You must be logged in to access this page"

  Scenario: User adds new availability
    Given no availabilities in the system
    And a user "jeffosmith" with openid url "http://someopenid.url"
    When I am on the homepage
    And I follow "Make yourself available"
    And I fill in "OpenID URL" with "http://someopenid.url"
    And I press "Login"
    And I select "December 25, 2014 10:00" as the "Start time" date and time
    And I select "December 25, 2014 12:30" as the "End time" date and time
    And I fill in "contact" with "http://github.com/aslakhellesoy"
    And I press "Publish availability"
    Then I should see /jeffosmith is available to pair on Cucumber for 2h 30m from Thu Dec 25, 2014 10:00 \- 12:30/

   Scenario: An availability can be edited by its owner
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                | contact                        |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30 | http://github.com/bender       |
    When I log in as "Bender"
    And I follow "Edit"
    And I fill in "project" with "updated by user"
    And I press "Update"
    Then I should see "Availability was successfully updated."

   Scenario: An availability cannot be edited by a user other than its owner
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                | contact                        |
      | Philip.J.Fry  | original proj   | December 13, 2019 21:30     | December 14, 2019 02:30 | http://github.com/philip_j_fry |
    When I log in as "Bender"
    Then I should not see "Edit"
    And I visit the edit page for the only availability in the system
    And I fill in "project" with "updated by user"
    And I press "Update"
    Then I should not see "Availability was successfully updated."
    And I should see "original proj"