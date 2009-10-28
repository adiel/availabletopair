Feature: View matching availabilities
  In order that I can find someone who wants a pair on whatever they are doing
  As an open source developer
  I want to see any matching pairs for the times I am available

  Scenario: One pair is found where both will work on anything
      Given only the following availabilities in the system
        | developer     | project         | start time                  | end time                    | contact                           |
        | LarryDavid    | Curb            | January 1, 2020 11:20       | January 1, 2020 11:30       | http://github.com/larry_david     |
        | MalcolmTucker | The Thick Of It | December 1, 2019 22:00      | December 1, 2019 22:20       | http://github.com/malcolm_tucker |
        | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30      | http://github.com/bender         |
        | Philip.J.Fry  |                 | December 13, 2019 21:30     | December 14, 2019 02:30      | http://github.com/philip_j_fry   |
      When I am on the list availabilities page
      And I follow "Fri Dec 13, 2019 22:00 - 04:30"
      Then I should see /Bender is available to pair on anything on Fri Dec 13, 2019 22:00 \- 04:30 (6h 30m)/
      And I should see the following matching pairs
        | developer    | project  | when                           | dev time     | contact                          |
        | Philip.J.Fry | anything | Fri Dec 13, 2019 22:00 - 02:30 | 4h 30m       | http://github.com/larry_david |


Scenario: One pair is found where both will work on only a specific project
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                    | contact                           |
      | LarryDavid    | Curb            | January 1, 2020 11:20       | January 1, 2020 11:30       | http://github.com/larry_david     |
      | MalcolmTucker | The Thick Of It | December 1, 2019 22:00      | December 1, 2019 22:20       | http://github.com/malcolm_tucker |
      | Bender        | Futurama        | December 13, 2019 22:00     | December 14, 2019 04:30      | http://github.com/bender         |
      | Philip.J.Fry  | Futurama        | December 13, 2019 21:30     | December 14, 2019 02:30      | http://github.com/philip_j_fry   |
    When I am on the list availabilities page
    And I follow "Fri Dec 13, 2019 22:00 - 04:30"
    Then I should see /Bender is available to pair on Futurama on Fri Dec 13, 2019 22:00 \- 04:30 (6h 30m)/
    And I should see the following matching pairs
      | developer    | project  | when                           | dev time     | contact                          |
      | Philip.J.Fry | Futurama | Fri Dec 13, 2019 22:00 - 02:30 | 4h 30m       | http://github.com/larry_david |

  Scenario: No pairs are found for a project
    Given only the following availabilities in the system
      | developer     | project            | start time                  | end time                    | contact                          |
      | LarryDavid    | Curb               | January 1, 2020 11:20       | January 1, 2020 11:30       | http://github.com/philip_j_fry   |
      | MalcolmTucker | The Thick Of It    | December 1, 2019 22:00      | December 1, 2019 22:20       | http://github.com/bender         |
      | Bender        | Futurama           | December 13, 2019 22:00     | December 14, 2019 04:30      | http://github.com/malcolm_tucker |
      | Philip.J.Fry  | Futurama The Movie | December 13, 2019 21:30     | December 14, 2019 02:30      | http://github.com/larry_david    |
    When I am on the list availabilities page
    And I follow "Fri Dec 13, 2019 22:00 - 04:30"
    Then I should see /Bender is available to pair on Futurama on Fri Dec 13, 2019 22:00 \- 04:30 (6h 30m)/
    Then I should see /No developers are available to pair on Futurama with Bender over this period/

  Scenario: Two pairs are found, one for the exact project, one for anything
      Given only the following availabilities in the system
        | developer       | project         | start time                  | end time                    | contact                           |
        | LarryDavid      | Curb            | January 1, 2020 11:20       | January 1, 2020 11:30       | http://github.com/larry_david     |
        | MalcolmTucker   | The Thick Of It | December 1, 2019 22:00      | December 1, 2019 22:20      | http://github.com/malcolm_tucker  |
        | Bender          | Futurama        | December 13, 2019 22:00     | December 14, 2019 04:30     | http://github.com/bender          |
        | Philip.J.Fry    | Futurama        | December 13, 2019 21:30     | December 14, 2019 02:30     | http://github.com/philip_j_fry    |
        | Prof Farnsworth |                 | December 13, 2019 21:15     | December 14, 2019 01:30     | http://github.com/prof_farnsworth |
      When I am on the list availabilities page
      And I follow "Fri Dec 13, 2019 22:00 - 04:30"
      Then I should see /Bender is available to pair on Futurama on Fri Dec 13, 2019 22:00 \- 04:30 (6h 30m)/
      And I should see the following matching pairs
        | developer       | project  | when                           | dev time     | contact                           |
        | Prof Farnsworth | Futurama | Fri Dec 13, 2019 22:00 - 01:30 | 3h 30m       | http://github.com/prof_farnsworth |
        | Philip.J.Fry    | Futurama | Fri Dec 13, 2019 22:00 - 02:30 | 4h 30m       | http://github.com/philip_j_fry    |


  Scenario: Show availability shows link to atom feed
    Given only the following availabilities in the system
      | developer     | project            | start time                  | end time                    | contact                          |
      | Bender        | Futurama           | December 13, 2019 22:00     | December 14, 2019 04:30      | http://github.com/malcolm_tucker |
    When I am on the list availabilities page
    And I follow "Fri Dec 13, 2019 22:00 - 04:30"
    Then I should see "Subscribe to updates of Bender's available pairs (atom)"
    When I follow "atom"
    Then My path should be "/Bender.atom"