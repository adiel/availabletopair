Feature: Feed of user availabilities
  In order that I can get notifications when available pairs change for any of my availabilities
  As an open source developer
  I want a feed of all my availabilities with available pairs in order of last updated first and a unique title/id

  Scenario: Feed is titled for user and links back to self and webpage
    When I visit "/LarryDavid.atom"
    Then the feed should have the following properties:
      | property | value                             |
      | title    | LarryDavid is Available To Pair   |
      | id       | http://www.example.com/LarryDavid |
    And the feed should have the following links:
      | href                                   | rel  |
      | http://www.example.com/LarryDavid.atom | self |
      | http://www.example.com/LarryDavid      |      |

  Scenario: Feed author is Available To Pair with noreply email
    When I visit "/LarryDavid.atom"
    Then the feed should have the following properties:
      | property | value                             |
      | title    | LarryDavid is Available To Pair   |
      | id       | http://www.example.com/LarryDavid |
    And the feed should have the following text nodes:
      | xpath                                | text                        |
      | /xmlns:feed/xmlns:author/xmlns:name  | Available To Pair           |
      | /xmlns:feed/xmlns:author/xmlns:email | noreply@availabletopair.com |

  Scenario: Single availability with no pairs is listed with summary title and content detailing no pairs available
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
      | PhllilJFry    | futurama        | December 14, 2019 21:59 | December 15, 2019 00:00 | http://github.com/LarryDavid   |
    When I visit "/LarryDavid.atom"
    Then I should see the following feed entries with content:
      | title                                              | content                                                                                        |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 | No developers are available to pair on curb with LarryDavid on Fri Dec 13, 2019 21:59 - 00:00. |
    When I visit "/PhllilJFry.atom"
    Then I should see the following feed entries with content:
      | title                                              | content                                                                                            |
      | Pairs available for Sat Dec 14, 2019 21:59 - 00:00 | No developers are available to pair on futurama with PhllilJFry on Sat Dec 14, 2019 21:59 - 00:00. |

  Scenario: When no pairs are available content should link to availability from datetime
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
    When I visit "/LarryDavid.atom"
    Then The only entry's content should link to availability page from time period

  Scenario: When pairs are available content should link to availability from datetime
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
      | JeffGarlin    | curb            | December 13, 2019 23:00 | December 14, 2019 01:00 | http://github.com/JeffGarlin   |
    When I visit "/LarryDavid.atom"
    Then The only entry's content should link to availability page from time period

  Scenario: Single availability with pairs is listed with summary title and pair details in content
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
      | JeffGarlin    | curb            | December 13, 2019 23:00 | December 14, 2019 01:00 | http://github.com/JeffGarlin   |
      | LarryCharles  |                 | December 13, 2019 23:30 | December 14, 2019 02:00 | http://github.com/LarryCharles |
    When I visit "/LarryDavid.atom"
    Then I should see the following feed entries with content:
      | title                                              | content |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 | The following developers are available to pair on curb with LarryDavid on Fri Dec 13, 2019 21:59 - 00:00:(\s*)1h 00m from 23:00 to 00:00 - JeffGarlin on curb(\s*)0h 30m from 23:30 to 00:00 - LarryCharles on anything |

  Scenario: Single availability with no pairs shows published as updated_at of availability
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
    When I visit "/LarryDavid.atom"
    And check the published date of the feed entry at position 1
    And touch the availability at position 1 of the feed
    And visit "/LarryDavid.atom" again
    Then the published date of the entry at position 1 has been updated
    And the published date of the entry at position 1 is in xmlschema format

  Scenario: Multiple availabilities are ordered by updated date
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
      | LarryDavid    | curb            | December 14, 2019 21:59 | December 15, 2019 00:00 | http://github.com/LarryDavid   |
    And I visit "/larrydavid.atom"
    And I see the following feed entries:
      | title                                              |
      | Pairs available for Sat Dec 14, 2019 21:59 - 00:00 |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 |
    When I touch the availability at position 2 of the feed
    And visit "/LarryDavid.atom" again
    Then I should see the following feed entries:
      | title                                              |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 |
      | Pairs available for Sat Dec 14, 2019 21:59 - 00:00 |

  Scenario: Multiple availabilities have feed updated date as last updated
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
      | LarryDavid    | curb            | December 14, 2019 21:59 | December 15, 2019 00:00 | http://github.com/LarryDavid   |
      | LarryDavid    | curb            | December 15, 2019 21:59 | December 16, 2019 00:00 | http://github.com/LarryDavid   |
    When I visit "/LarryDavid.atom"
    Then the feed should show as updated at the published time of the entry at position 1
    When I touch the availability at position 2 of the feed
    And I visit "/LarryDavid.atom" again
    Then the feed should show as updated at the published time of the entry at position 1

  Scenario: Availability should show updated time in the title
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
    When I visit "/LarryDavid.atom"
    Then the title of the entry at position 1 should contain the updated time

  Scenario: Availability should show updated time and id in the entry id
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
    When I visit "/LarryDavid.atom"
    Then the id of the entry at position 1 should contain the updated time
    Then the id of the entry at position 1 should contain the availability id

  Scenario: Multiple availabilities are ordered by latest of pair updated and availability updated
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
      | LarryDavid    | curb            | December 14, 2019 21:59 | December 15, 2019 00:00 | http://github.com/LarryDavid   |
      | JeffGarlin    | curb            | December 13, 2019 21:00 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
    And I visit "/JeffGarlin.atom"
    When I reduce the end time of the availability at position 1 of the feed by 1 min
    And visit "/LarryDavid.atom"
    Then I should see the following feed entries:
      | title                                              |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 |
      | Pairs available for Sat Dec 14, 2019 21:59 - 00:00 |
    When I touch the availability at position 2 of the feed
    And visit "/LarryDavid.atom" again
    Then I should see the following feed entries:
      | title                                              |
      | Pairs available for Sat Dec 14, 2019 21:59 - 00:00 |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 |
    When I extend the start time of the availability at position 1 of the feed by 1 min
    And visit "/LarryDavid.atom" again
    Then I should see the following feed entries:
      | title                                              |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 |
      | Pairs available for Sat Dec 14, 2019 21:59 - 00:00 |      

 Scenario: Updates to a pair that do not affect the shared dev time do not affect updated date
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
      | LarryDavid    | curb            | December 14, 2019 21:59 | December 15, 2019 00:00 | http://github.com/LarryDavid   |
      | JeffGarlin    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
    And I visit "/JeffGarlin.atom"
    When I extend the end time of the availability at position 1 of the feed by 1 min
    And I reduce the start time of the availability at position 1 of the feed by 1 min
    And visit "/LarryDavid.atom"
    Then I should see the following feed entries:
      | title                                              |
      | Pairs available for Sat Dec 14, 2019 21:59 - 00:00 |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 |    

  Scenario: Multiple availabilities have feed updated date as latest of pair updated and availability updated
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        |
      | LarryDavid    | curb            | December 13, 2019 21:59 | December 14, 2019 00:00 | http://github.com/LarryDavid   |
      | LarryDavid    | curb            | December 14, 2019 21:59 | December 15, 2019 00:00 | http://github.com/LarryDavid   |
      | JeffGarlin    | curb            | December 13, 2019 21:00 | December 13, 2019 22:00 | http://github.com/LarryDavid   |
      | LarryCharles  | curb            | December 14, 2019 21:59 | December 15, 2019 22:00 | http://github.com/LarryDavid   |
    When I visit "/JeffGarlin.atom"
    And I extend the start time of the availability at position 1 of the feed by 10 min
    And visit "/LarryDavid.atom"
    Then I should see the following feed entries:
      | title                                              |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 |
      | Pairs available for Sat Dec 14, 2019 21:59 - 00:00 |
    And the feed should show as updated at the published time of the entry at position 1
    When I visit "/LarryCharles.atom"
    And I extend the start time of the availability at position 1 of the feed by 10 min
    And visit "/LarryDavid.atom"
    Then I should see the following feed entries:
      | title                                              |
      | Pairs available for Sat Dec 14, 2019 21:59 - 00:00 |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 |
    Then the feed should show as updated at the published time of the entry at position 1
    When I touch the availability at position 2 of the feed
    Then I should see the following feed entries:
      | title                                              |
      | Pairs available for Sat Dec 14, 2019 21:59 - 00:00 |
      | Pairs available for Fri Dec 13, 2019 21:59 - 00:00 |
    And the feed should show as updated at the published time of the entry at position 1