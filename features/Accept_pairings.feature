Feature: Accept pairing
  In order to let a developer who has suggested pairing know I want to pair and to let others know I am taken
  As an open source developer to whom others have sugested pairing
  I want to be able to accept pairing with a suggested pair

  Scenario: User accepts suggested pairing
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                    | contact                           |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30      | http://github.com/bender         |
      | PhilipJFry    |                 | December 13, 2019 21:30     | December 14, 2019 02:30      | http://github.com/philip_j_fry   |
    When logged in as "Bender", I visit my only availability
    And I press "Suggest pairing"
    And logged in as "PhilipJFry", I visit my only availability
    Then I should see the following pair statuses:
      | developer  | status                |
      | Bender | Bender suggested pairing |
    When I press "Accept"
    Then I should see the following pair statuses:
      | developer  | status |
      | Bender | Paired |
    When logged in as "Bender", I visit my only availability
    Then I should see the following pair statuses:
      | developer  | status |
      | PhilipJFry | Paired |
    When I press "Cancel pairing"
    Then I should see the following pair statuses:
      | developer  | status |
      | PhilipJFry | PhilipJFry suggested pairing |


  Scenario: User accepts a suggestion from looking at the pair's availability page
