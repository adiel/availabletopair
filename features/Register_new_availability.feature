Feature: Register new availability
  In order that I can find someone who wants a pair on whatever they are doing
  As an open source developer
  I want to publish my availability to pair in advance

  Scenario: User adds new availability
    Given no availabilities in the system
    When I am on the homepage
    And I follow "Make yourself available"
    And I fill in "developer" with "aslakhellesoy"
    And I fill in "project" with "http://github.com/aslakhellesoy/cucumber"
    And I select "December 25, 2009 10:00" as the "Start time" date and time
    And I select "December 25, 2009 12:30" as the "End time" date and time
    And I fill in "contact" with "http://github.com/aslakhellesoy"
    And I press "Publish availability"
    Then I should see /Philip\.J\.Fry is available to pair on Cucumber for 2h 30m from Fri Dec 25, 2009 10:00 \- 12:30/

  Scenario: Single availability is listed on the availabilities page
    Given the following availabilities in the system
      | developer     | project  | start time                    | end time                   | contact                        |
      | Philip.J.Fry  | futurama | January 1, 2010 22:00         | January 1, 2010 23:00      | http://github.com/philip_j_fry |
    When I am on the list availabilities page
    Then I should see the following availabilites listed in order
      | developer     | project  | when                                 | pairs available | contact                        |
      | Philip.J.Fry  | futurama | Fri Jan 01, 2010 22:00:00 - 23:00:00 | No              | http://github.com/philip_j_fry |

  Scenario: Multiple availabilities are listed on the availabilities page soonest first
    Given the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | Philip.J.Fry  | futurama        | January 1, 2010 22:00   | January 1, 2010 23:00   | http://github.com/philip_j_fry |
      | Bender        | futurama        | November 1, 2009 22:00  | November 2, 2009 05:00  | http://github.com/Bender       |
      | LarryDavid    | curb            | December 13, 2009 21:59 | December 14, 2009 00:00 | http://github.com/LarryDavid   |
    When I am on the list availabilities page
    Then I should see the following availabilites listed in order
      | developer     | project         |  when                          | dev time | pairs available | contact                        |
      | Bender        | futurama        | Sun Nov 01, 2009 22:00 - 05:00 | 7h 0m    | No              | http://github.com/Bender       |
      | LarryDavid    | curb            | Sun Dec 13, 2009 21:59 - 00:00 | 2h 1m    | No              | http://github.com/LarryDavid   |
      | Philip.J.Fry  | futurama        | Fri Jan 01, 2010 22:00 - 23:00 | 1h 0m    | No              | http://github.com/philip_j_fry |



