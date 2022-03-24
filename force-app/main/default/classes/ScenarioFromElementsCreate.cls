public with sharing class ScenarioFromElementsCreate {
  @InvocableMethod(label='Create Scenario Records from Elements')
  public static List<FlowOutputParameters> createPermutations(
    List<FlowInputParameters> inputList
  ) {
    List<FlowOutputParameters> result = new List<FlowOutputParameters>();
    for (FlowInputParameters input : inputList) {
      FlowOutputParameters output = new FlowOutputParameters();
      List<Scenario__c> scenarios = new List<Scenario__c>();
      List<Scenario__c> currentScenarios = new List<Scenario__c>();
      String prefix = input.elementName + '%';
      List<ElementData__c> elements = [
        SELECT Description__c, Value__c, Order__c, Id
        FROM ElementData__c
        WHERE Name LIKE :prefix
        ORDER BY Order__c
      ];
      Map<String, List<Id>> elementsMap = processElements(elements);
      Integer count = 1;
      List<String> factor1 = elementsMap.get('1');
      List<String> factor2 = elementsMap.get('2');
      List<String> factor3 = elementsMap.get('3');
      List<String> factor4 = elementsMap.get('4');
      List<String> factor5 = elementsMap.get('5');
      List<String> factor6 = elementsMap.get('6');

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
                    Name = input.elementName +
                      '_' +
                      String.valueOf(count).leftPad(5, '0'),
                    ElementData1__c = factor1[a],
                    ElementData2__c = factor2[b],
                    ElementData3__c = factor3[c],
                    ElementData4__c = factor4[d],
                    ElementData5__c = factor5[e],
                    ElementData6__c = factor6[f]
                  );
                  count++;
                  scenarios.add(scenario);
                }
              }
            }
          }
        }
      }

      // outputScenarios = createScenarios(listOfElements, 0, currentScenarios, outputScenarios);
      output.records = scenarios;
      result.add(output);
    }
    return result;
  }

  private static Map<String, List<String>> processElements(
    List<ElementData__c> elements
  ) {
    Map<String, List<Id>> result = new Map<String, List<Id>>();
    for (ElementData__c element : elements) {
      if (!result.keySet().contains(String.valueOf(element.order__c))) {
        result.put(
          String.valueOf(element.order__c),
          new List<Id>{ element.Id }
        );
      } else {
        result.get(String.valueOf(element.order__c)).add(element.Id);
      }
    }
    System.debug('Map result: ' + result);
    return result;
  }

  //TODO recursion version
  //   private static List<Scenario__c> createScenarios(
  //     List<List<String>> listOfElements,
  //     Integer depth,
  //     List<Scenario__c> current,
  //     List<Scenario__c> result
  //   ) {
  //     if (depth == listOfElements.size()) {
  //       for (String element : listOfElements.get(depth)) {
  //         Scenario__c scenario = new Scenario__c(
  //           Name = nameprefix + '_' + String.valueOf(count).leftPad(5, '0')
  //         );
  //       }

  //       result.addAll(current);
  //     } else {
  //       depth = depth + 1;
  //       createScenarios(listOfElements, depth, current, result);
  //     }
  //     return result;
  //   }

  /* Input parameters for the Apex action */
  public class FlowInputParameters {
    @InvocableVariable(label='Element Data Name Prefix' required=true)
    public String elementName;

    // @InvocableVariable(label='Max Order' required=true)
    // public Integer maxOrder;
  }

  /* Output parameters of the Apex action */
  public class FlowOutputParameters {
    @InvocableVariable(label='Record Collection')
    public List<Scenario__c> records;
  }
}
