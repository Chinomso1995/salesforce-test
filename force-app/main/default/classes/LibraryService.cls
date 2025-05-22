public with sharing class LibraryService {
    private static final Integer MAX_PAGE_SIZE = 100;
    private static final Integer DEFAULT_PAGE_SIZE = 20;

    @AuraEnabled(cacheable=true)
    public static List<Library_Book__c> searchBooks(String searchTerm, Integer pageSize, Integer pageNumber) {
        String cleanTerm = (searchTerm == null) ? '' : searchTerm.replaceAll('[^A-Za-z0-9 ]', '').trim();
        if (cleanTerm == '') {
            return new List<Library_Book__c>();
        }
        Integer limitSize = (pageSize == null || pageSize < 1) ? DEFAULT_PAGE_SIZE : Math.min(pageSize, MAX_PAGE_SIZE);
        Integer pageIdx = (pageNumber == null || pageNumber < 1) ? 1 : pageNumber;
        Integer offsetSize = (pageIdx - 1) * limitSize;
        String wildcard = '%' + cleanTerm + '%';
        return [
            SELECT Id, Title__c, Author__c, Available_Copies__c, Total_Copies__c
            FROM Library_Book__c
            WHERE Title__c LIKE :wildcard OR Author__c LIKE :wildcard
            ORDER BY Title__c
            LIMIT :limitSize
            OFFSET :offsetSize
        ];
    }

    @AuraEnabled
    public static void loanBook(Id bookId, Id borrowerId) {
      Library_Book_Loan__c loan = new Library_Book_Loan__c(
      Book__c           = bookId,
      Borrower__c       = borrowerId,
      Loan_Start_Date__c= Date.today(),
      Loan_End_Date__c  = Date.today().addDays(14)
     );
     insert loan;
   }

    
    
}