public with sharing class ScenarioCombinationGenerate {
  @InvocableMethod(label='Create Scenario Records')
  public static List<FlowOutputParameters> createPermutations(
    List<FlowInputParameters> inputList
  ) {
    List<FlowOutputParameters> result = new List<FlowOutputParameters>();
    for (FlowInputParameters input : inputList) {
      FlowOutputParameters output = new FlowOutputParameters();
      List<Scenario__c> scenarios = new List<Scenario__c>();
      Integer count = 1;
      String namePrefix = input.name;
      List<String> factor1 = input.factor1;
      List<String> factor2 = input.factor2;
      List<String> factor3 = input.factor3;
      List<String> factor4 = input.factor4;
      List<String> factor5 = input.factor5;
      List<String> factor6 = input.factor6;

      Integer f1Size = factor1.size();
      Integer f2Size = factor2.size();
      Integer f3Size = factor3.size();
      Integer f4Size = factor4.size();
      Integer f5Size = factor5.size();
      Integer f6Size = factor6.size();

      for (Integer a = 0; a < f1Size; a++) {
        for (Integer b = 0; b < f2Size; b++) {
          for (Integer c = 0; c < f3Size; c++) {
            for (Integer d = 0; d < f4Size; d++) {
              for (Integer e = 0; e < f5Size; e++) {
                for (Integer f = 0; f < f6Size; f++) {
                  Scenario__c scenario = new Scenario__c(
                    Name = nameprefix + '_' + count,
                    Factor1__c = factor1[a],
                    Factor2__c = factor2[b],
                    factor3__c = factor3[c],
                    factor4__c = factor4[d],
                    factor5__c = factor5[e],
                    factor6__c = factor6[f]
                  );
                  count++;
                  scenarios.add(scenario);
                }
              }
            }
          }
        }
      }
      output.records = scenarios;
      result.add(output);
    }
    return result;
  }

  /* Input parameters for the Apex action */
  public class FlowInputParameters {
    @InvocableVariable(label='Scenario Name' required=true)
    public String name;

    @InvocableVariable(label='Factor1 collection' required=true)
    public List<String> factor1;

    @InvocableVariable(label='Factor2 collection' required=true)
    public List<String> factor2;

    @InvocableVariable(label='Factor3 collection' required=true)
    public List<String> factor3;

    @InvocableVariable(label='Factor4 collection' required=true)
    public List<String> factor4;

    @InvocableVariable(label='Factor5 collection' required=true)
    public List<String> factor5;

    @InvocableVariable(label='Factor6 collection' required=true)
    public List<String> factor6;
  }

  /* Output parameters of the Apex action */
  public class FlowOutputParameters {
    @InvocableVariable(label='Record Collection')
    public List<Scenario__c> records;
  }
}
