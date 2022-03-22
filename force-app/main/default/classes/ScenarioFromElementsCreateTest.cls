@isTest
private class ScenarioFromElementsCreateTest {
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
  }
  @isTest
  public static void testCreate() {
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
    List<ElementData__c> data = [SELECT Id FROM ElementData__c];
    System.assertEquals(64, scenarios.size(), 'Number not matching');
  }
}
