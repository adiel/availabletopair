Feature: List user availabilities
  In order that I can see when I have made myself available and if anyone is available to pair
  As an open source developer
  I want to see all my availabilities listed with whether there are pairs available

  Scenario: Only the specified user's availabilities are listed on the users' availabilities page soonest first
    Given the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | Philip.J.Fry  | futurama        | January 1, 2010 22:00   | January 1, 2010 23:00   | http://github.com/philip_j_fry |
      | Bender        | futurama        | November 1, 2009 22:00  | November 2, 2009 05:00  | http://github.com/Bender       |
      | LarryDavid    | curb            | December 13, 2009 22:00 | December 14, 2009 00:00 | http://github.com/LarryDavid   |
      | LarryDavid    | curb            | December 13, 2009 21:00 | December 14, 2009 00:00 | http://github.com/LarryDavid   |
   And I visit "/LarryDavid"
   Then I should see "All LarryDavid's availability"
   And I should see the following availabilites listed in order
      | developer     | project         | when                           | dev time  | pairs available | contact                        |
      | LarryDavid    | curb            | Sun Dec 13, 2009 21:00 - 00:00 | 3h 00m    | No              | http://github.com/LarryDavid   |
      | LarryDavid    | curb            | Sun Dec 13, 2009 22:00 - 00:00 | 2h 00m    | No              | http://github.com/LarryDavid   |

  Scenario: Developer name on all availabilities links to user page
    Given the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2009 21:00 | December 14, 2009 00:00 | http://github.com/LarryDavid   |
    When I am on the list availabilities page
    When I follow "LarryDavid"
    Then My path should be "/LarryDavid"

  Scenario: User page shows link to atom feed
    When I visit "/MarkKerrigan"
    Then I should see "Subscribe to updates of MarkKerrigan's available pairs (atom)"
    When I follow "atom"
    Then My path should be "/MarkKerrigan.atom"

  Scenario: Developer name on show page links to user page
    Given the following availabilities in the system
    | developer     | project         | start time                  | end time                | contact                        |
    | Bender        |                 | December 13, 2009 22:00     | December 14, 2009 04:30 | http://github.com/bender       |
    | Philip.J.Fry  |                 | December 13, 2009 21:30     | December 14, 2009 02:30 | http://github.com/philip_j_fry |
    When I am on the list availabilities page
    And I follow "Sun Dec 13, 2009 21:30 - 02:30"
    And I follow "Bender"
    Then My path should be "/Bender"
    And I should see "All Bender's availability"