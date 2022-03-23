public with sharing class RulesToScenariosCheck {
  @InvocableMethod(label='Apply all rules')
  public static List<FlowOutputParameters> applyRules(
    List<FlowInputParameters> inputList
  ) {
    List<FlowOutputParameters> result = new List<FlowOutputParameters>();
    for (FlowInputParameters input : inputList) {
      FlowOutputParameters output = new FlowOutputParameters();
      String ruleName = input.rule + '%';
      String scenarioName = input.scenario + '%';
      List<Rule__c> rules = [
        SELECT
          ElementData1__c,
          ElementData2__c,
          ElementData3__c,
          ElementData4__c,
          ElementData5__c,
          ElementData6__c,
          Id
        FROM Rule__c
        WHERE Name LIKE :ruleName AND order__c != NULL
        ORDER BY order__c DESC
      ];
      Map<Id, Scenario__c> scenarioMap = new Map<Id, Scenario__c>();
      for (Rule__c rule : rules) {
        String query = 'SELECT AppliedRule__c, ElementData1__c, ElementData2__c, ElementData3__c, ElementData4__c, ElementData5__c, ElementData6__c, Id FROM Scenario__c WHERE Name LIKE :scenarioName ';
        if (rule.ElementData1__c != null) {
          query += ' AND ElementData1__c = \'' + rule.ElementData1__c + '\'';
        }
        if (rule.ElementData2__c != null) {
          query += ' AND ElementData2__c = \'' + rule.ElementData2__c + '\'';
        }
        if (rule.ElementData3__c != null) {
          query += ' AND ElementData3__c = \'' + rule.ElementData3__c + '\'';
        }
        if (rule.ElementData4__c != null) {
          query += ' AND ElementData4__c = \'' + rule.ElementData4__c + '\'';
        }
        if (rule.ElementData5__c != null) {
          query += ' AND ElementData5__c = \'' + rule.ElementData5__c + '\'';
        }
        if (rule.ElementData6__c != null) {
          query += ' AND ElementData6__c = \'' + rule.ElementData6__c + '\'';
        }
        System.debug('query ' + query);
        List<Scenario__c> scenarios = Database.query(query);
        for (Scenario__c scenario : scenarios) {
          if (!scenarioMap.keySet().contains(scenario.Id)) {
            scenario.AppliedRule__c = rule.Id;
            scenarioMap.put(scenario.Id, scenario);
          } else {
            scenarioMap.get(scenario.Id).appliedRule__c = rule.Id;
          }
        }
      }

      output.records = scenarioMap.values();
      result.add(output);
    }
    return result;
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
