Feature: All Tests pass in JasmineJS
  In order to run JasmieJS tests headlessly
  As the test.html page
  All tests should report green

  Scenario: All tests pass
    Given I am on the test page
    Then I should see passing tests
    But I should not see failing tests
