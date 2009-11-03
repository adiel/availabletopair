Feature: Accept pairing
  In order to let a developer who has suggested pairing know I want to pair and to let others know I am taken
  As an open source developer to whom others have sugested pairing
  I want to be able to accept pairing with a suggested pair

  Scenario: User accepts suggested pairing
    And only the following availabilities in the system
      | developer     | project         | start time                  | end time                    | contact                           |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30      | http://github.com/bender         |
      | PhilipJFry    |                 | December 13, 2019 21:30     | December 14, 2019 02:30      | http://github.com/philip_j_fry   |
    When I log in as "Bender"
    And I visit "/Bender"
    And I follow "Yes"
    And I press "Suggest pairing"
    And I log out
    And I log in as "PhilipJFry"
    And I visit "/PhilipJFry"
    And I follow "Yes"
    Then I should see "Bender suggested pairing"
    When I press "Accept"
    Then I should see "Paired"
    When I log out
    And I log in as "Bender"
    And I visit "/Bender"
    And I follow "Yes"
    Then I should see "Paired"
    When I press "Cancel pairing"
    Then I should see "PhilipJFry suggested pairing"

  Scenario: User accepts one of many suggested pairings and all other outward suggestions are cleared
  Scenario: User accepts one suggestion then accepts a different suggestion and the previous acceptance is cleared
