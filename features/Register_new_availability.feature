Feature: Register new availability
  In order that anyone looking for a pair knows when I am available
  As an open source developer
  I want to publish my availability to pair in advance

  Scenario: User adds new availability
    Given no availabilities in the system
    When I am on the homepage
    And I follow "Make yourself available"
    And I fill in "developer" with "aslakhellesoy"
    And I fill in "project" with "Cucumber"
    And I select "December 25, 2009 10:00" as the "Start time" date and time
    And I select "December 25, 2009 12:30" as the "End time" date and time
    And I fill in "contact" with "http://github.com/aslakhellesoy"
    And I press "Publish availability"
    Then I should see /aslakhellesoy is available to pair on Cucumber for 2h 30m from Fri Dec 25, 2009 10:00 \- 12:30/

