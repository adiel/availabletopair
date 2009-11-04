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

#Post.update_all({:removed=>true}, {:id=>params[:posts]})    
  Scenario: User accepts a suggested pairings and all other pairings suggested by the other user for the same avaialability are cleared
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                    | contact                           |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30      | http://github.com/bender         |
      | PhilipJFry    |                 | December 13, 2019 21:30     | December 14, 2019 02:30      | http://github.com/philip_j_fry   |
      | DrZoidberg    |                 | December 13, 2019 20:30     | December 14, 2019 01:30      | http://github.com/Dr_Zoidberg    |
    And "PhilipJFry" has suggested pairing with all available pairs
    When logged in as "PhilipJFry", I visit my only availability
    Then I should see the following pair statuses:
      | developer  | status                |
      | DrZoidberg | You suggested pairing |
      | Bender     | You suggested pairing |
    When logged in as "Bender", I visit my only availability
    And I press "Accept"
    When logged in as "PhilipJFry", I visit my only availability
    Then I should see the following pair statuses:
      | developer  | status |
      | DrZoidberg | Open   |
      | Bender     | Paired |

  Scenario: User accepts a suggested pairings and all other pairings suggested same user for the same avaialability are cleared
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                    | contact                           |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30      | http://github.com/bender         |
      | PhilipJFry    |                 | December 13, 2019 21:30     | December 14, 2019 02:30      | http://github.com/philip_j_fry   |
      | DrZoidberg    |                 | December 13, 2019 20:30     | December 14, 2019 01:30      | http://github.com/Dr_Zoidberg    |
    And "PhilipJFry" has suggested pairing with "Bender" where possible
    And "Bender" has suggested pairing with all available pairs except "PhilipJFry"
    When logged in as "Bender", I visit my only availability
    Then I should see the following pair statuses:
      | developer  | status                       |
      | DrZoidberg | You suggested pairing        |
      | PhilipJFry | PhilipJFry suggested pairing |
    When I press "Accept"
    Then I should see the following pair statuses:
      | developer  | status |
      | DrZoidberg | Open   |
      | PhilipJFry | Paired |

  Scenario: User accepts one suggestion then accepts a different suggestion and the previous acceptance is cleared
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                    | contact                           |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30      | http://github.com/bender         |
      | PhilipJFry    |                 | December 13, 2019 21:30     | December 14, 2019 02:30      | http://github.com/philip_j_fry   |
      | DrZoidberg    |                 | December 13, 2019 20:30     | December 14, 2019 01:30      | http://github.com/Dr_Zoidberg    |
    And "PhilipJFry" has suggested pairing with "Bender" where possible
    When logged in as "Bender", I visit my only availability
    And I press "Accept"
    Then I should see the following pair statuses:
      | developer  | status |
      | PhilipJFry | Paired |
      | DrZoidberg | Open   |
    When "DrZoidberg" has suggested pairing with "Bender" where possible
    And logged in as "Bender", I visit my only availability
    And I press "Accept"
    Then I should see the following pair statuses:
      | developer  | status                       |
      | DrZoidberg | Paired                       |
      | PhilipJFry | PhilipJFry suggested pairing |

  Scenario: User accepts a suggestion from looking at the pair's availability page
