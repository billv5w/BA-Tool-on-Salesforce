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

      List<List<ElementData__c>> scenarioList = processElementList(elements);

      createCombinations(scenarioList);
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

  private static List<List<ElementData__c>> processElementList(
    List<ElementData__c> elements
  ) {
    List<List<ElementData__c>> resultList = new List<List<ElementData__c>>();
    Map<String, List<ElementData__c>> result = new Map<String, List<ElementData__c>>();
    for (ElementData__c element : elements) {
      if (!result.keySet().contains(String.valueOf(element.order__c))) {
        result.put(
          String.valueOf(element.order__c),
          new List<ElementData__c>{ element }
        );
      } else {
        result.get(String.valueOf(element.order__c)).add(element);
      }
    }
    for (List<ElementData__c> elist : result.values()) {
      resultList.add(elist);
    }
    return resultList;
  }

  //TODO recursion version
  /**
   * Given a list of factors in the form of strings, a full combinations
   * of possible outcomes will be returned using a recursive method.
   *
   * @param factors
   *
   * @return
   */
  public static List<List<Object>> createCombinations(
    List<List<Object>> factors
  ) {
    if (factors.isEmpty()) {
      return new List<List<Object>>{ new List<Object>() };
    }

    List<List<Object>> combinationsReturn = new List<List<Object>>();
    for (
      List<Object> combinations : createCombinations(
        (List<List<Object>>) listPop(factors)
      )
    ) {
      for (Object factor : factors.get(factors.size() - 1)) {
        combinationsReturn.add(listPush(combinations, factor));
      }
    }
    return combinationsReturn;
  }

  /**
   * Push an item onto a list and return the result.
   * This is useful when we are wanting to avoid immutability.
   *
   * @param lst
   * @param obj
   *
   * @return
   */
  private static List<Object> listPush(List<Object> lst, Object obj) {
    List<Object> listReturn = lst.clone();
    listReturn.add(obj);
    return listReturn;
  }
  /**
   * Pop the last element off from the list, and return the result.
   *
   * @param lst
   *
   * @return
   */
  private static List<Object> listPop(List<Object> lst) {
    List<Object> listReturn = lst.clone();
    listReturn.remove(lst.size() - 1);
    return listReturn;
  }
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
