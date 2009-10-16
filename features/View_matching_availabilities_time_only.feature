Feature: View matching availabilities
  In order that I can find someone who wants a pair on whatever they are doing
  As an open source developer
  I want to see any matching pairs for the times I am available

  Scenario: Multiple availabilities are listed on the availabilities page soonest first
    Given the following availabilities in the system
      | developer     | project         | start time                  | end time                    | contact                          |
      | LarryDavid    | Curb            | January 1, 2010 11:20       | January 1, 2010 11:30       | http://github.com/philip_j_fry   |
      | MalcolmTucker | The Thick Of It | December 1, 2009 22:00      | December 1, 2009 22:20       | http://github.com/bender         |
      | Bender        | Futurama        | December 13, 2009 22:00     | December 14, 2009 04:30      | http://github.com/malcolm_tucker |
      | Philip.J.Fry  | Futurama        | December 13, 2009 21:30     | December 14, 2009 02:30      | http://github.com/larry_david    |
    When I am on the list availabilities page
    And I follow "Sun Dec 13, 2009 22:00 - 04:30"
    Then I should see /Bender is available to on pair on Futurama for 6h 30m from Sun Dec 13, 2009 22:00 \- 04:30/
    And I should see the following matching pairs
      | developer    | project  | when                           | dev time     | contact                          |
      | Philip.J.Fry | futurama | Sun Dec 13, 2009 22:00 - 02:30 | 4h 30m       | http://github.com/larry_david |
