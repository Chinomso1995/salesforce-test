@isTest
public class MultipleSumsSOQLQueryTest {
  @isTest
    private static void customQueryTest() {
        List<MultipleSumsSOQLQuery.QueryRequest> requests = new List<MultipleSumsSOQLQuery.QueryRequest>();
      MultipleSumsSOQLQuery.QueryRequest request = new MultipleSumsSOQLQuery.QueryRequest();
        
        String testQuery = 'SELECT SUM(Amount), SUM(ExpectedRevenue) FROM Opportunity';// WHERE Id=\'0068c00000rSqNrAAK\'
        request.queryString = testQuery;
        requests.add(request);
        
        MultipleSumsSOQLQuery.customQueries(requests);
        MultipleSumsSOQLQuery.QuerySumsResult summedFields = MultipleSumsSOQLQuery.customQuery(request);
        //System.debug(summedFields.sum0 + ' ' + summedFields.sum2);
    }
}