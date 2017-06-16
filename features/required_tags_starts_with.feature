Feature: Ensure Required Tags are present
  As a tester I dont want to miss certain tags on my scenarios

  Background: Prepare Testee
    Given a file named ".gherkin_lint.yml" with:
    """
    ---
    RequiredTagsStartsWith:
        Enabled: true
        Matcher: PB|MCC
    """
    And a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint::GherkinLint.new
      linter.enable %w(RequiredTagsStartsWith)
      linter.analyze 'lint.feature'
      exit linter.report

      """
    Scenario: Scenario without required tags
      Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          When <A>
          Then <B>
      """
      When I run `ruby lint.rb`
      Then it should fail with exactly:
      """
      RequiredTagsStartsWith - Required Tag PB|MCC not found
        lint.feature (2): Test.A

      """