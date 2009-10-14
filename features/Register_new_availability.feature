Feature: Register new availability
  In order that I can find someone who wants a pair on whatever they are doing
  As an open source developer
  I want to publish my availability to pair in advance

  Scenario: User adds new availability
    Given no availabilities in the system
    When I am on the homepage
    And I follow "Make yourself available to pair"
    And I fill in "developer" with "Philip.J.Fry"
    And I select "December 25, 2009 10:00" as the date and time
    And I fill in "end time" with "600"
    And I fill in "contact" with "http://github.com/philip_j_fry"
    And I press "Publish availability"
    Then I should see /Developer:\s*Philip.J.Fry/
    And I should see /Start time:\s*2009-12-25 10:00:00 UTC/
    And I should see /Duration mins:\s*600/
    And I should see /Contact:\s*http:..github.com.philip_j_fry/

  Scenario: Single availability is listed on the availabilities page
    Given the following availabilities in the system
      | developer     | start time                    | end time                   | contact                        |
      | Philip.J.Fry  | January 1, 2010 22:00         | January 1, 2010 23:00      | http://github.com/philip_j_fry |
    When I am on the list availabilities page
    Then I should see the following availabilites listed in order
      | developer     | start time                   | end time                     | contact                        |
      | Philip.J.Fry  | 2010-01-01 22:00:00 UTC      | 2010-01-01 23:00:00 UTC      | http://github.com/philip_j_fry |

  Scenario: Multiple availabilities are listed on the availabilities page soonest first
    Given the following availabilities in the system
      | developer     | start time              | end time                | contact                        |
      | Philip.J.Fry  | January 1, 2010 22:00   | January 1, 2010 23:00   | http://github.com/philip_j_fry |
      | Bender        | November 1, 2009 22:00  | November 2, 2009 05:00  | http://github.com/philip_j_fry |
      | MalcolmTucker | December 13, 2009 22:00 | December 14, 2009 03:00 | http://github.com/philip_j_fry |
      | LarryDavid    | December 13, 2009 21:59 | December 14, 2009 00:00 | http://github.com/philip_j_fry |
    When I am on the list availabilities page
    Then I should see the following availabilites listed in order
      | developer     | start time              | duration                | contact                        |
      | Bender        | 2009-11-01 22:00:00 UTC | 2009-11-02 05:00:00 UTC | http://github.com/philip_j_fry |
      | LarryDavid    | 2009-12-13 21:59:00 UTC | 2009-12-14 00:00:00 UTC | http://github.com/philip_j_fry |
      | MalcolmTucker | 2009-12-13 22:00:00 UTC | 2009-12-14 03:00:00 UTC | http://github.com/philip_j_fry |
      | Philip.J.Fry  | 2010-01-01 22:00:00 UTC | 2010-01-01 23:00:00 UTC | http://github.com/philip_j_fry |
                      


