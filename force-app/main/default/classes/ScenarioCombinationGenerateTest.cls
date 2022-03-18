@isTest
private class ScenarioCombinationGenerateTest {
  @isTest
  public static void testFullLists() {
    List<ScenarioCombinationGenerate.FlowInputParameters> inputList = new List<ScenarioCombinationGenerate.FlowInputParameters>();
    ScenarioCombinationGenerate.FlowInputParameters input = new ScenarioCombinationGenerate.FlowInputParameters();
    input.factor1 = new List<String>{ 'A', 'B', 'C' };
    input.factor2 = new List<String>{ 'a2', 'b2', 'c2' };
    input.factor3 = new List<String>{ 'A3', 'B3', 'C3' };
    input.factor4 = new List<String>{ 'A4', 'B4', 'C4' };
    input.factor5 = new List<String>{ 'A5', 'B5', 'C5' };
    input.factor6 = new List<String>{ 'A6', 'B6', 'C6' };
    inputList.add(input);

    test.startTest();
    List<ScenarioCombinationGenerate.FlowOutputParameters> result = ScenarioCombinationGenerate.createPermutations(
      inputList
    );
    for (ScenarioCombinationGenerate.FlowOutputParameters output : result) {
      System.assertEquals(729, output.records.size(), 'Number not matching');
    }
  }

  //   @isTest
  //   public static void testPartialLists() {
  //     List<ScenarioCombinationGenerate.FlowInputParameters> inputList = new List<ScenarioCombinationGenerate.FlowInputParameters>();
  //     ScenarioCombinationGenerate.FlowInputParameters input = new ScenarioCombinationGenerate.FlowInputParameters();
  //     input.factor1 = new List<String>{ 'A', 'B', 'C' };
  //     input.factor2 = new List<String>{ 'a2', 'b2', 'c2' };
  //     input.factor3 = new List<String>{ 'A3', 'B3', 'C3' };
  //     input.factor4 = new List<String>{ 'A4', 'B4', 'C4' };
  //     input.factor5 = new List<String>{ 'A5', 'B5', 'C5' };
  //     // input.factor6 = new List<String>{ 'A6', 'B6', 'C6' };
  //     inputList.add(input);

  //     test.startTest();
  //     List<ScenarioCombinationGenerate.FlowOutputParameters> result = ScenarioCombinationGenerate.createPermutations(
  //       inputList
  //     );
  //     for (ScenarioCombinationGenerate.FlowOutputParameters output : result) {
  //         System.assertEquals(243, output.records.size(), 'Number not matching');
  //     }
  //   }
}
