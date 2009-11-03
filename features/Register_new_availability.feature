Feature: Register new availability
  In order that anyone looking for a pair knows when I am available
  As an open source developer
  I want to publish my availability to pair in advance

  Scenario: Anonymous user tries to add new availability and is redirected to login
    Given no availabilities in the system
    When I am on the homepage
    And I follow "Make yourself available"
    Then I should see "You must be logged in to access this page"

  Scenario: User adds new availability
    Given no availabilities in the system
    When I log in as "jeffosmith"
    And I follow "Make yourself available"
    And I fill in "Cucumber" for "Project"
    And I select "December 25, 2014 10:00" as the "Start time" date and time
    And I select "December 25, 2014 12:30" as the "End time" date and time
    And I press "Publish availability"
    Then I should see "jeffosmith is available to pair on Cucumber on Thu Dec 25, 2014 10:00 - 12:30 (2h 30m)"

   Scenario: An availability can be edited by its owner
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                | contact                        |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30 | http://github.com/bender       |
    When I log in as "Bender"
    And I follow "Edit"
    And I fill in "project" with "updated by user"
    And I press "Update"
    Then I should see "Availability was successfully updated."

  Scenario: An availability can be deleted by its owner
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                | contact                        |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30 | http://github.com/bender       |
    When I log in as "Bender"
    And I press "Delete"
    And I should see the following availabilites listed in order:
      | developer | project | start time | end time | contact |

   Scenario: An availability cannot be edited by a user other than its owner
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                | contact                        |
      | PhilipJFry  | original proj   | December 13, 2019 21:30     | December 14, 2019 02:30 | http://github.com/philip_j_fry |
    When I log in as "Bender"
    Then I should not see "Edit"
    When I visit the edit page for the only availability in the system
    Then I should be on the homepage
    And I should not see "Availability was successfully updated."
#TODO: post a save request with id nobbled

  Scenario: An availability cannot be deleted by a user other than its owner
    Given only the following availabilities in the system
      | developer   | project         | start time                  | end time                | contact                        |
      | PhilipJFry  | original proj   | January 01, 2020 21:30     | January 01, 2020 22:30 | http://github.com/philip_j_fry |
    When I log in as "Bender"
    Then I should not see "Delete"
    When I make a request to delete the only availability in the system
    And I should see the following availabilites listed in order:
      | who         | what          | when                           | dev time | pairs | contact                        |
      | PhilipJFry  | original proj | Wed Jan 01, 2020 22:00 - 23:00 | 1h 00m   | No    | http://github.com/philip_j_fry |
