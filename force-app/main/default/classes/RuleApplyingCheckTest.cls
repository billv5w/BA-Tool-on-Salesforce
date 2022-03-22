@isTest
private class RuleApplyingCheckTest {
  @testSetup
  public static void createData() {
    List<Scenario__c> scenarios = new List<Scenario__c>();
    List<ScenarioCombinationGenerate.FlowInputParameters> inputList = new List<ScenarioCombinationGenerate.FlowInputParameters>();
    ScenarioCombinationGenerate.FlowInputParameters input = new ScenarioCombinationGenerate.FlowInputParameters();
    input.name = 'Test';
    input.factor1 = new List<String>{ 'A', 'B', 'C' };
    input.factor2 = new List<String>{ 'a2', 'b2', 'c2' };
    input.factor3 = new List<String>{ 'A3', 'B3', 'C3' };
    input.factor4 = new List<String>{ 'A4', 'B4', 'C4' };
    input.factor5 = new List<String>{ 'A5', 'B5', 'C5' };
    input.factor6 = new List<String>{ 'A6', 'B6', 'C6' };
    inputList.add(input);
    List<ScenarioCombinationGenerate.FlowOutputParameters> result = ScenarioCombinationGenerate.createPermutations(
      inputList
    );
    for (ScenarioCombinationGenerate.FlowOutputParameters output : result) {
      scenarios.addAll(output.records);
    }
    insert scenarios;
    // List<Rule__c> rules = new List<Rule__c>();
    // Rule__c rule1 = new Rule__c(Name = 'Rule - 1', factor1 = 'A', factor2 = 'b2', order__c = 1);
    // Rule__c rule2 = new Rule__c(Name = 'Rule - 2', factor1 = 'A', factor2 = 'b2', order__c = 2);
    // Rule__c rule3 = new Rule__c(Name = 'Rule - 3', factor1 = 'A', factor2 = 'b2', order__c = 3);
    // rules.add(rule1);
    // rules.add(rule2);
    // rules.add(rule3);
    // insert rules;
  }
  @isTest
  public static void testRule1() {
    List<RuleApplyingCheck.FlowInputParameters> inputList = new List<RuleApplyingCheck.FlowInputParameters>();
    RuleApplyingCheck.FlowInputParameters input = new RuleApplyingCheck.FlowInputParameters();
    Rule__c rule1 = new Rule__c(
      Name = 'Rule - 1',
      factor1__c = 'A',
      factor2__c = 'b2'
    );
    insert rule1;
    input.rule = rule1;
    input.scenarios = [
      SELECT
        Name,
        Factor1__c,
        Factor2__c,
        Factor3__c,
        Factor4__c,
        Factor5__c,
        Factor6__c,
        Rule__c
      FROM Scenario__c
    ];
    inputList.add(input);
    test.startTest();
    List<RuleApplyingCheck.FlowOutputParameters> result = RuleApplyingCheck.checkRule(
      inputList
    );
    for (RuleApplyingCheck.FlowOutputParameters output : result) {
      System.assertEquals(81, output.records.size(), 'Number not matching');
    }
  }
}
