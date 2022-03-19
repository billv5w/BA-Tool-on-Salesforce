public with sharing class RuleApplyingCheck {
  @InvocableMethod(label='Check Scenario Records')
  public static List<FlowOutputParameters> checkRule(
    List<FlowInputParameters> inputList
  ) {
    List<FlowOutputParameters> result = new List<FlowOutputParameters>();
    for (FlowInputParameters input : inputList) {
      FlowOutputParameters output = new FlowOutputParameters();
      List<Scenario__c> outputScenarios = new List<Scenario__c>();
      Rule__c rule = input.rule;
      List<Scenario__c> scenarios = input.scenarios;

      for (Scenario__c s : scenarios) {
        String condition =
          s.factor1__c +
          ' ' +
          s.factor2__c +
          ' ' +
          s.factor3__c +
          ' ' +
          s.factor4__c +
          ' ' +
          s.factor5__c +
          ' ' +
          s.factor6__c;
        // System.debug('condition: ' + condition);

        String criteria =
          (rule.factor1__c != null ? rule.factor1__c : s.factor1__c) +
          ' ' +
          (rule.factor2__c != null ? rule.factor2__c : s.factor2__c) +
          ' ' +
          (rule.factor3__c != null ? rule.factor3__c : s.factor3__c) +
          ' ' +
          (rule.factor4__c != null ? rule.factor4__c : s.factor4__c) +
          ' ' +
          (rule.factor5__c != null ? rule.factor5__c : s.factor5__c) +
          ' ' +
          (rule.factor6__c != null ? rule.factor6__c : s.factor6__c);
        // System.debug('criteria: ' + criteria);
        if (condition.equalsIgnoreCase(criteria)) {
          s.rule__c = rule.Id;

          outputScenarios.add(s);
        }
      }

      output.records = outputScenarios;
      result.add(output);
    }
    return result;
  }

  /* Input parameters for the Apex action */
  public class FlowInputParameters {
    @InvocableVariable(label='Current Rule' required=true)
    public Rule__c rule;

    @InvocableVariable(label='Applied Scenarios' required=true)
    public List<Scenario__c> scenarios;
  }

  /* Output parameters of the Apex action */
  public class FlowOutputParameters {
    @InvocableVariable(label='Record Collection')
    public List<Scenario__c> records;
  }
}
