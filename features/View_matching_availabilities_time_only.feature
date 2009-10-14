Feature: View matching availabilities
  In order that I can find someone who wants a pair on whatever they are doing
  As an open source developer
  I want to see any matching pairs for the times I am available

  Scenario: Multiple availabilities are listed on the availabilities page soonest first
    Given the following availabilities in the system
      | developer     | start time                  | end time                    | contact                          |
      | Philip.J.Fry  | January 1, 2010 11:20       | January 1, 2010 11:30       | http://github.com/philip_j_fry   |
      | Bender        | December 1, 2009 22:00      | December 1, 2009 22:20       | http://github.com/bender         |
      | MalcolmTucker | December 13, 2009 22:00     | December 14, 2009 04:30      | http://github.com/malcolm_tucker |
      | LarryDavid    | December 13, 2009 21:30     | December 14, 2009 02:30      | http://github.com/larry_david    |
    When I am on the list availabilities page
    And I follow "2009-12-13 22:00:00 UTC"
    Then I should see "You are available to pair from 2009-12-13 22:00:00 UTC to 2009-12-14 04:30:00 UTC"
    Then I should see "The following devs are available to pair with you at this time:"
    And I should see the following matching pairs
      | developer  | from                    | to                      | dev time    | contact                          |
      | LarryDavid | 2009-12-13 22:00:00 UTC | 2009-12-14 02:30:00 UTC | 4h30m       | http://github.com/larry_david |
