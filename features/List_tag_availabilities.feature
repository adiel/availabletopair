Feature: List tag availabilities
  In order that I can see who want to pair on similar things to me
  As an open source developer
  I want to see all the availabilities with a specific tag listed

  Scenario: Only the specified user's availabilities are listed on the users' availabilities page last updated first
    Given only the following availabilities in the system
      | developer     | project         | start time              | end time                | contact                        | tags          |
      | LarryDavid    | curb            | December 13, 2019 22:00 | December 14, 2019 00:00 | http://github.com/LarryDavid   | ruby,on,rails | 
      | LarryDavid    | curb            | December 13, 2019 21:00 | December 13, 2019 21:30 | http://github.com/LarryDavid   | ruby          |
      | LarryDavid    | curb            | December 13, 2019 23:00 | December 13, 2019 23:50 | http://github.com/LarryDavid   | on,rails      |
   And I visit "/tags/ruby"
   Then I should see "Availabilities for tag: ruby"
   And I should see the following availabilites listed in order
      | developer     | project         | when                           | dev time  | pairs available | contact                        | tags          |
      | LarryDavid    | curb            | Fri Dec 13, 2019 21:00 - 21:30 | 0h 30m    | No              | http://github.com/LarryDavid   | ruby          |
      | LarryDavid    | curb            | Fri Dec 13, 2019 22:00 - 00:00 | 2h 00m    | No              | http://github.com/LarryDavid   | on, rails, ruby |
