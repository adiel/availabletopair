Feature: Register new availability
  In order that I can find someone who wants a pair on whatever they are doing
  As an open source developer
  I want to see all developers' availabilities

  Scenario: Single availability is listed on the availabilities page
    Given the following availabilities in the system
      | developer     | project  | start time                    | end time                   | contact                        |
      | Philip.J.Fry  | futurama | January 1, 2010 22:00         | January 1, 2010 23:00      | http://github.com/philip_j_fry |
    When I am on the list availabilities page
    Then I should see the following availabilites listed in order
      | developer     | project  | when                           | dev time         | pairs available | contact                        |
      | Philip.J.Fry  | futurama | Fri Jan 01, 2010 22:00 - 23:00 | 1h 0m           | No              | http://github.com/philip_j_fry |

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

  Scenario: An availability is listed with two matching pairs
    Given the following availabilities in the system
     | developer       | project         | start time                  | end time                    | contact                           |
     | LarryDavid      | Curb            | December 13, 2009 21:00     | December 14, 2009 05:00       | http://github.com/larry_david     |
     | Bender          | Futurama        | December 13, 2009 22:00     | December 14, 2009 04:30     | http://github.com/bender          |
     | Philip.J.Fry    | Futurama        | December 13, 2009 21:30     | December 14, 2009 02:30     | http://github.com/philip_j_fry    |
     | Prof Farnsworth |                 | December 13, 2009 21:15     | December 14, 2009 01:30     | http://github.com/prof_farnsworth |
    When I am on the list availabilities page
    Then I should see the following availabilites listed in order
      | developer       | project         |  when                          | dev time | pairs available | contact                        |
      | LarryDavid      | Curb            | Sun Dec 13, 2009 21:00 - 05:00 | 8h 0m    | Yes(1)         | http://github.com/LarryDavid   |
      | Prof Farnsworth | anything        | Sun Dec 13, 2009 21:15 - 01:30 | 4h 15m   | Yes(3)         | http://github.com/philip_j_fry |
      | Philip.J.Fry    | Futurama        | Sun Dec 13, 2009 21:30 - 02:30 | 5h 0m    | Yes(2)         | http://github.com/philip_j_fry |
      | Bender          | Futurama        | Sun Dec 13, 2009 22:00 - 04:30 | 6h 30m   | Yes(2)         | http://github.com/philip_j_fry |



