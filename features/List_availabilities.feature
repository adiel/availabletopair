Feature: List  availabilities
  In order that I can find someone who wants a pair on whatever they are doing
  As an open source developer
  I want to see all developers' availabilities

  Scenario: Single availability is listed on the availabilities page
    Given only the following availabilities in the system
      | developer     | project  | start time                    | end time                   | contact                        |
      | Philip.J.Fry  | futurama | January 1, 2020 22:00         | January 1, 2020 23:00      | http://github.com/philip_j_fry |
    When I am on the list availabilities page
    Then I should see the following availabilites listed in order
      | developer     | project  | when                           | dev time         | pairs available | contact                        |
      | Philip.J.Fry  | futurama | Wed Jan 01, 2020 22:00 - 23:00 | 1h 00m           | No              | http://github.com/philip_j_fry |

  Scenario: Multiple availabilities are listed on the availabilities page soonest first
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | Philip.J.Fry  | futurama        | January 1, 2020 22:00   | January 1, 2020 23:00   | http://github.com/philip_j_fry |
      | Bender        | futurama        | November 1, 2019 22:00  | November 2, 2019 05:00  | http://github.com/Bender       |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
    When I am on the list availabilities page
    Then I should see the following availabilites listed in order
      | developer     | project         |  when                          | dev time | pairs available | contact                        |
      | Bender        | futurama        | Fri Nov 01, 2019 22:00 - 05:00 | 7h 00m    | No              | http://github.com/Bender       |
      | LarryDavid    | curb            | Fri Dec 13, 2019 21:59 - 00:00 | 2h 01m    | No              | http://github.com/LarryDavid   |
      | Philip.J.Fry  | futurama        | Wed Jan 01, 2020 22:00 - 23:00 | 1h 00m    | No              | http://github.com/philip_j_fry |

  Scenario: An availability is listed with two matching pairs
    Given only the following availabilities in the system
     | developer       | project         | start time                  | end time                    | contact                           |
     | LarryDavid      | Curb            | December 13, 2019 21:00     | December 14, 2019 05:00       | http://github.com/larry_david     |
     | Bender          | Futurama        | December 13, 2019 22:00     | December 14, 2019 04:30     | http://github.com/bender          |
     | Philip.J.Fry    | Futurama        | December 13, 2019 21:30     | December 14, 2019 02:30     | http://github.com/philip_j_fry    |
     | ProfFarnsworth |                 | December 13, 2019 21:15     | December 14, 2019 01:30     | http://github.com/prof_farnsworth |
    When I am on the list availabilities page
    Then I should see the following availabilites listed in order
      | developer       | project         |  when                          | dev time | pairs available | contact                        |
      | LarryDavid      | Curb            | Fri Dec 13, 2019 21:00 - 05:00 | 8h 00m   | Yes(1)         | http://github.com/LarryDavid   |
      | ProfFarnsworth | anything        | Fri Dec 13, 2019 21:15 - 01:30 | 4h 15m   | Yes(3)         | http://github.com/philip_j_fry |
      | Philip.J.Fry    | Futurama        | Fri Dec 13, 2019 21:30 - 02:30 | 5h 00m   | Yes(2)         | http://github.com/philip_j_fry |
      | Bender          | Futurama        | Fri Dec 13, 2019 22:00 - 04:30 | 6h 30m   | Yes(2)         | http://github.com/philip_j_fry |

  Scenario: Availabilities with end time in the past should not show
    Given no availabilities in the system
    And the following availabilities in the system with an end time 2 minutes in the past:
      | developer     | project  |
      | PhilipJFry    | futurama |
    And the following availabilities in the system with an end time 2 minutes in the future:
      | developer     | project         |
      | MalcolmTucker | the thick of it |
    When I am on the list availabilities page
    Then I should see "MalcolmTucker"
    But I should not see "PhilipJFry"


