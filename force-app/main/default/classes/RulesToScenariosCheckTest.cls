@isTest
private class RulesToScenariosCheckTest {
  @testSetup
  public static void createData() {
    List<ElementData__c> data = new List<ElementData__c>();
    for (Integer i = 1; i < 7; i++) {
      ElementData__c element1 = new ElementData__c();
      element1.Name = 'Test';
      element1.Order__c = i;
      element1.Value__c = 'A1 ' + i;
      data.add(element1);
      ElementData__c element2 = new ElementData__c();
      element2.Name = 'Test';
      element2.Order__c = i;
      element2.Value__c = 'B1 ' + i;
      data.add(element2);
    }
    insert data;

    List<ScenarioFromElementsCreate.FlowInputParameters> inputList = new List<ScenarioFromElementsCreate.FlowInputParameters>();
    ScenarioFromElementsCreate.FlowInputParameters input = new ScenarioFromElementsCreate.FlowInputParameters();
    List<Scenario__c> scenarios = new List<Scenario__c>();
    input.elementName = 'Test';
    // input.maxOrder = 6;
    inputList.add(input);
    List<ScenarioFromElementsCreate.FlowOutputParameters> result = ScenarioFromElementsCreate.createPermutations(
      inputList
    );
    for (ScenarioFromElementsCreate.FlowOutputParameters output : result) {
      scenarios.addAll(output.records);
    }
    insert scenarios;
  }

  @isTest
  public static void testRule() {
    List<RulesToScenariosCheck.FlowInputParameters> inputList = new List<RulesToScenariosCheck.FlowInputParameters>();
    RulesToScenariosCheck.FlowInputParameters input = new RulesToScenariosCheck.FlowInputParameters();
    ElementData__c element1 = [
      SELECT Id
      FROM ElementData__c
      WHERE order__c = 1
    ][0];
    ElementData__c element2 = [
      SELECT Id
      FROM ElementData__c
      WHERE order__c = 2
    ][0];
    ElementData__c element3 = [
      SELECT Id
      FROM ElementData__c
      WHERE order__c = 3
    ][0];
    Rule__c rule1 = new Rule__c(
      Name = 'Rule - 1',
      ElementData1__c = element1.Id,
      ElementData2__c = element2.Id,
      Order__c = 1
    );
    Rule__c rule2 = new Rule__c(
      Name = 'Rule - 2',
      ElementData1__c = element1.Id,
      ElementData3__c = element3.Id,
      Order__c = 2
    );
    insert rule1;
    insert rule2;
    input.rule = 'Rule';
    input.scenario = 'Test';
    inputList.add(input);
    test.startTest();
    List<RulesToScenariosCheck.FlowOutputParameters> result = RulesToScenariosCheck.applyRules(
      inputList
    );
    for (RulesToScenariosCheck.FlowOutputParameters output : result) {
      System.assertEquals(24, output.records.size(), 'Number not matching');
    }
  }
}
