public with sharing class RulesToScenariosCheck {

  @InvocableMethod(Label='Apply all rules')
  public static List<FlowOutputParameters> applyRules(List<FlowInputParameters> inputList)
  {
    List<FlowOutputParameters> result = new List<FlowOutputParameters>();

    for (FlowInputParameters input : inputList) {
      FlowOutputParameters output = new FlowOutputParameters();
      List<Scenario__c> outputScenarios = new List<Scenario__c>();

      // Get a list of ElementData field names dynamically.
      List<String> fieldElements = getFieldNamesContain(Rule__c.getSObjectType(), 'ElementData');
      String ruleName = input.rule + '%';
      String scenarioName = input.scenario + '%';

      List<Rule__c> rules = Database.query(
        'SELECT '
          + String.join(fieldElements, ',') + ' '
          + 'FROM Rule__c '
          + 'WHERE Name LIKE :ruleName AND Order__c != NULL '
          + 'ORDER BY Order__c DESC'
      );
      Map<Id, Scenario__c> scenarioMap = new Map<Id, Scenario__c>();
      for (Rule__c rule : rules) {
        // Build a list of filters based on non-null values.
        List<String> queryFilter = new List<String>{''};
        for (String fieldName : fieldElements) {
          if (rule.get(fieldName) != null) {
            queryFilter.add(fieldName + ' = ' + '\'' + rule.get(fieldName) + '\'');
          }
        }

        String query =
          'SELECT AppliedRule__c, ' + String.join(fieldElements, ', ') + ' '
            + 'FROM Scenario__c '
            + 'WHERE Name LIKE :scenarioName '
            + String.join(queryFilter, 'AND ') + ' '
        ;
        System.debug(LoggingLevel.INFO, query);

        List<Scenario__c> scenarios = Database.query(query);
        System.debug(LoggingLevel.DEBUG, 'Scenarios: ' + scenarios);

        for (Scenario__c scenario : scenarios) {
          if (!scenarioMap.keySet().contains(scenario.Id)) {
            scenario.Rule__c = rule.Id;
            scenarioMap.put(scenario.Id, scenario);
          } else {
            scenarioMap.get(scenario.Id).Rule__c = rule.Id;
          }
        }
      }
      output.records = scenarioMap.values();
      result.add(output);
    }
    return result;
  }

  /**
   * Given an SObjectType, filter the fields that contain a string.
   *
   * @param sObjectType
   * @param strContains
   *
   * @return
   */
  private static List<String> getFieldNamesContain(SObjectType sObjectType, String strContains)
  {
    Set<String> fieldNames = sObjectType.getDescribe().fields.getMap().keySet();
    List<String> fieldNamesChosen = new List<String>();

    for (String fieldName : fieldNames) {
      if (fieldName.containsIgnoreCase(strContains)) {
        fieldNamesChosen.add(fieldName);
      }
    }
    return fieldNamesChosen;
  }

  /* Input parameters for the Apex action */
  public class FlowInputParameters {
    @InvocableVariable(label='Rules Prefix' required=true)
    public String rule;

    @InvocableVariable(label='Applied Scenarios Prefix' required=true)
    public String scenario;
  }

  /* Output parameters of the Apex action */
  public class FlowOutputParameters {
    @InvocableVariable(label='Record Collection')
    public List<Scenario__c> records;
  }
}