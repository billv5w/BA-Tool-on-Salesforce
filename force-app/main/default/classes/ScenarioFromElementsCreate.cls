public with sharing class ScenarioFromElementsCreate {
  /**
   * Create a list of scenarios given a list of combinations.
   *
   * @param inputList
   *
   * @return
   */
  @InvocableMethod(Label='Create Scenario Records from Elements')
  public static List<FlowOutputParameters> createPermutations(
    List<FlowInputParameters> inputList
  ) {
    List<FlowOutputParameters> result = new List<FlowOutputParameters>();
    for (FlowInputParameters input : inputList) {
      FlowOutputParameters output = new FlowOutputParameters();
      String prefix = input.elementName + '%';
      List<ElementData__c> elements = [
        SELECT Id, Order__c
        FROM ElementData__c
        WHERE Name LIKE :prefix
        ORDER BY Order__c
      ];

      List<List<Id>> factorsGrid = createFactors(elements);
      List<List<Object>> combinations = createCombinations(factorsGrid);

      List<Map<String, Object>> scenarios = new List<Map<String, Object>>();
      Integer count = 1;

      for (List<Object> combinationElements : combinations) {
        Map<String, Object> scenario = new Map<String, Object>{
          'Name' => input.elementName +
          '_' +
          String.valueOf(count).leftPad(5, '0')
        };
        for (Integer i = 0; i < combinationElements.size(); i++) {
          scenario.put(
            'ElementData' +
            (i + 1) +
            '__c',
            combinationElements.get(i)
          );
        }
        scenarios.add(scenario);
        count++;
      }

      System.debug(
        LoggingLevel.INFO,
        'Generated a total of ' +
        count +
        ' combinations.'
      );
      output.records = (List<Scenario__c>) JSON.deserialize(
        JSON.serialize(scenarios),
        List<Scenario__c>.class
      );
      result.add(output);
    }
    return result;
  }

  /**
   * Given a list of elements, a list of factors are returned that provide
   * all the potential options for each of the of the orders.
   *
   * @param elements
   *
   * @return
   */
  private static List<List<Id>> createFactors(List<ElementData__c> elements) {
    Map<Decimal, List<Id>> gridMap = new Map<Decimal, List<Id>>();
    for (ElementData__c element : elements) {
      if (!gridMap.containsKey(element.Order__c)) {
        gridMap.put(element.Order__c, new List<Id>());
      }
      gridMap.get(element.Order__c).add(element.Id);
    }
    return gridMap.values();
  }

  /**
   * Given a list of factors in the form of strings, a full combinations
   * of possible outcomes will be returned using a recursive method.
   *
   * @param factors
   *
   * @return
   */
  private static List<List<Object>> createCombinations(
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
    @InvocableVariable(Label='Element Data Name Prefix' Required=true)
    public String elementName;
  }

  /* Output parameters of the Apex action */
  public class FlowOutputParameters {
    @InvocableVariable(Label='Record Collection')
    public List<Scenario__c> records;
  }
}
