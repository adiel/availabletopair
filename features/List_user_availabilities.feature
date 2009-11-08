Feature: List user availabilities
  In order that I can see when I have made myself available and if anyone is available to pair
  As an open source developer
  I want to see all my availabilities listed with whether there are pairs available

  Scenario: Only the specified user's availabilities are listed on the users' availabilities page last updated first
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | Philip.J.Fry  | futurama        | January 1, 2020 22:00   | January 1, 2020 23:00   | http://github.com/philip_j_fry |
      | Bender        | futurama        | November 1, 2019 22:00  | November 2, 2019 05:00  | http://github.com/Bender       |
      | LarryDavid    | curb            | December 13, 2019 22:00 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
      | LarryDavid    | curb            | December 13, 2019 21:00 | December 13, 2019 21:30 | http://github.com/LarryDavid   |
   And I visit "/LarryDavid"
   Then I should see "All LarryDavid's availability"
   And I should see the following availabilites listed in order
      | developer     | project         | when                           | dev time  | pairs available | contact                        |
      | LarryDavid    | curb            | Fri Dec 13, 2019 21:00 - 21:30 | 0h 30m    | No              | http://github.com/LarryDavid   |
      | LarryDavid    | curb            | Fri Dec 13, 2019 22:00 - 00:00 | 2h 00m    | No              | http://github.com/LarryDavid   |

  Scenario: Developer name on all availabilities links to user page
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:00 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
    When I am on the list availabilities page
    When I follow "LarryDavid"
    Then My path should be "/LarryDavid"

  Scenario: User page shows link to atom feed
    Given a user "MarkKerrigan"
    When I visit "/MarkKerrigan"
    Then I should see "Subscribe to updates of MarkKerrigan's available pairs (atom)"
    When I follow "atom"
    Then My path should be "/MarkKerrigan.atom"

  Scenario: Developer name on show page links to user page
    Given only the following availabilities in the system
      | developer     | project         | start time                  | end time                | contact                        |
      | Bender        |                 | December 13, 2019 22:00     | December 14, 2019 04:30 | http://github.com/bender       |
      | Philip.J.Fry  |                 | December 13, 2019 21:30     | December 14, 2019 02:30 | http://github.com/philip_j_fry |
    When I am on the list availabilities page
    And I follow "Fri Dec 13, 2019 21:30 - 02:30"
    And I follow "Bender"
    Then My path should be "/Bender"
    And I should see "All Bender's availability"

  Scenario: Availabilities with end time in the past should not show
    Given no availabilities in the system
    And the following availabilities in the system with an end time 2 seconds in the future:
      | developer     | project  |
      | PhilipJFry  | futurama |
    When I wait 2 seconds
    When I visit "/PhilipJFry"                                  
    Then I should not see "futurama"

  Scenario: Availabilities with end time just in future should show
    Given no availabilities in the system
    And the following availabilities in the system with an end time 1 minute in the future:
      | developer     | project         |
      | Bender        | the thick of it |
    When I visit "/Bender"
    But I should see "the thick of it"