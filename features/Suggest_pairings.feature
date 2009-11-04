Feature: Suggest pairing
  In order to initiate pairing with any of the available pairs
  As an open source developer with available pairs
  I want to be able to suggest pairing with an available pair

  Scenario: User suggests and cancels pairing with matching developer
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                    | contact                           |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30      | http://github.com/bender         |
      | PhilipJFry    |                 | December 13, 2019 21:30     | December 14, 2019 02:30      | http://github.com/philip_j_fry   |
    When I log in as "Bender"
    And I visit "/Bender"
    And I follow "Yes"
    Then I should see the following pair statuses:
      | developer  | status |
      | PhilipJFry | Open   |
    When I press "Suggest pairing"
    Then I should see the following pair statuses:
      | developer  | status                |
      | PhilipJFry | You suggested pairing |
    When I press "Cancel"
    Then I should see the following pair statuses:
      | developer  | status |
      | PhilipJFry | Open   |

  Scenario: User suggests pairing from looking at the pair's availability page
