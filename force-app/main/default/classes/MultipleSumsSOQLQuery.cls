global class MultipleSumsSOQLQuery {
  @InvocableMethod (label = 'Multiple Sums SOQL Query')
    global static List<QuerySumsResult> customQueries(List<QueryRequest> requests) {
        List<QuerySumsResult> results = new List<QuerySumsResult>();
        //loop through list of requests
        for (QueryRequest request : requests) {
          results.add(customQuery(request));
      }
        return results;
    }
  
    //actual work happens inside this method
    public static QuerySumsResult customQuery(QueryRequest request) {
        System.assert(request.queryString != '');

    System.debug(request.queryString);        
        List<AggregateResult> result = Database.query(request.queryString);
        System.debug(result);
        
        Decimal sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, sum9;
        for (AggregateResult ar : result) {
      sum0 = getExprNum(ar, '0');
            sum1 = getExprNum(ar, '1');
            sum2 = getExprNum(ar, '2');
            sum3 = getExprNum(ar, '3');
            sum4 = getExprNum(ar, '4');
            sum5 = getExprNum(ar, '5');
            sum6 = getExprNum(ar, '6');
            sum7 = getExprNum(ar, '7');
            sum8 = getExprNum(ar, '8');
            sum9 = getExprNum(ar, '9');
        }
        QuerySumsResult sumsResult = new QuerySumsResult();
        sumsResult.sum0 = sum0;
        sumsResult.sum1 = sum1;
        sumsResult.sum2 = sum2;
        sumsResult.sum3 = sum3;
        sumsResult.sum4 = sum4;
        sumsResult.sum5 = sum5;
        sumsResult.sum6 = sum6;
        sumsResult.sum7 = sum7;
        sumsResult.sum8 = sum8;
        sumsResult.sum9 = sum9;
        
        /*AggregateResult[] testResults = [
            SELECT SUM(Amount) FROM Opportunity
        ];
        for (AggregateResult ar : testResults) {
            System.debug(ar);
        }*/
        
        return sumsResult;
    }
    
    public static Decimal getExprNum(AggregateResult ar, string num) {
        try {
            return (Decimal)ar.get('expr' + num);
        } catch (Exception e) {
            return 0;
        }
    }
    
    //custom class for input
    global class QueryRequest {
        @InvocableVariable(required=true)
        public String queryString;
    }
    //custom class for output
    global class QuerySumsResult {
        @InvocableVariable
        global Decimal sum0;
    
        @InvocableVariable
        global Decimal sum1;
    
        @InvocableVariable
        global Decimal sum2;
        
        @InvocableVariable
        global Decimal sum3;
        
        @InvocableVariable
        global Decimal sum4;
        
        @InvocableVariable
        global Decimal sum5;
        
        @InvocableVariable
        global Decimal sum6;
        
        @InvocableVariable
        global Decimal sum7;
        
        @InvocableVariable
        global Decimal sum8;
        
        @InvocableVariable
        global Decimal sum9;
    }
}