Feature: Register new availability
  In order that anyone looking for a pair knows when I am available
  As an open source developer
  I want to publish my availability to pair in advance

  Scenario: Anonymous user tries to add new availability and is redirected to login
    Given no availabilities in the system
    And I am on the homepage
    And I follow "Make yourself available"
    Then I should see "You need to sign in or sign up before continuing"

  Scenario: User adds new availability
    Given no availabilities in the system
    When I log in as "jeffosmith"
    And I follow "Make yourself available"
    And I fill in "Cucumber" for "Project"
    And I fill in "available,to,pair" for "Tags"
    And I select "December 25, 2014 10:00" as the "Start time" date and time
    And I select "December 25, 2014 12:30" as the "End time" date and time
    And I press "Publish availability"
    Then I should see "jeffosmith is available to pair on Cucumber on Thu Dec 25, 2014 10:00-12:30 GMT (2h 30m) - Tags: available, pair, to"

  Scenario: User cannot add a new availability with end date in the past
    Given no availabilities in the system
    When I log in as "jeffosmith"
    And I follow "Make yourself available"
    And I select a time 5 mins in the past as the "Start time" date and time
    And I select a time 1 min in the past as the "End time" date and time
    And I press "Publish availability"
    And I should see "End time is in the past"

  Scenario: User cannot add a new availability with end date the same as the start date
    Given no availabilities in the system
    When I log in as "jeffosmith"
    And I follow "Make yourself available"
    And I select "December 25, 2014 10:00" as the "Start time" date and time
    And I select "December 25, 2014 10:00" as the "End time" date and time
    And I press "Publish availability"
    And I should see "End time must be after start time"

  Scenario: User cannot add a new availability with end date before the start date
      Given no availabilities in the system
      When I log in as "jeffosmith"
      And I follow "Make yourself available"
      And I select "December 25, 2014 10:00" as the "Start time" date and time
      And I select "December 25, 2014 09:59" as the "End time" date and time
      And I press "Publish availability"
      And I should see "End time must be after start time"

    Scenario: User cannot add a new availability longer than 12hrs
      Given no availabilities in the system
      When I log in as "jeffosmith"
      And I follow "Make yourself available"
      And I select "December 25, 2014 10:00" as the "Start time" date and time
      And I select "December 25, 2014 22:01" as the "End time" date and time
      And I press "Publish availability"
      And I should see "12hrs is the maximum for one availability (you have 12h 01m)"
      When I select "December 25, 2014 22:00" as the "End time" date and time
      And I press "Publish availability"
      Then I should see "jeffosmith is available to pair on anything on Thu Dec 25, 2014 10:00-22:00 GMT (12h 00m)"

  Scenario: User cannot add a new availability that overlaps at the start of an existing availability
      Given only the following availabilities in the system
        | developer   | project  | start time                    | end time                   | contact                      |
        | jeffosmith  |          | December 25, 2014 10:00       | December 25, 2014 11:00    | http://github.com/jeffosmith |
      When I log in as "jeffosmith"
      And I follow "Make yourself available"
      And I select "December 25, 2014 08:00" as the "Start time" date and time
      And I select "December 25, 2014 10:01" as the "End time" date and time
      And I press "Publish availability"
      And I should see "You have already declared yourself available for some of this time"

    Scenario: User cannot add a new availability that overlaps at the end of an existing availability
      Given only the following availabilities in the system
        | developer   | project  | start time                    | end time                   | contact                      |
        | jeffosmith  |          | December 25, 2014 10:00       | December 25, 2014 11:00    | http://github.com/jeffosmith |
      When I log in as "jeffosmith"
      And I follow "Make yourself available"
      And I select "December 25, 2014 10:59" as the "Start time" date and time
      And I select "December 25, 2014 11:30" as the "End time" date and time
      And I press "Publish availability"
      And I should see "You have already declared yourself available for some of this time"

    Scenario: User can add a new availability that has contiguous availabilities on either side
      Given only the following availabilities in the system
        | developer   | project  | start time                    | end time                   | contact                      |
        | jeffosmith  |          | December 25, 2014 10:05       | December 25, 2014 10:15    | http://github.com/jeffosmith |
        | jeffosmith  |          | December 25, 2014 10:30       | December 25, 2014 11:45    | http://github.com/jeffosmith |
      When I log in as "jeffosmith"
      And I follow "Make yourself available"
      And I select "December 25, 2014 10:15" as the "Start time" date and time
      And I select "December 25, 2014 10:30" as the "End time" date and time
      And I press "Publish availability"
      Then I should see "jeffosmith is available to pair on anything on Thu Dec 25, 2014 10:15-10:30 GMT (0h 15m)"

   Scenario: An availability can be edited by its owner
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                | contact                        |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30 | http://github.com/bender       |
    When I log in as "Bender"
    And I follow "Edit"
    And I fill in "Project" with "updated by user"
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
      | PhilipJFry  | original proj | Wed Jan 01, 2020 22:00-23:00 | 1h 00m   | No    | http://github.com/philip_j_fry |
