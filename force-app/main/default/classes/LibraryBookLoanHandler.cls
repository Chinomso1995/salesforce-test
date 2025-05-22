// LibraryBookLoanHandler.cls
public with sharing class LibraryBookLoanHandler {

    public static void handleBeforeInsert(List<Library_Book_Loan__c> newLoans) {
        System.debug('newLoans' + newLoans);
      // 1) Gather IDs & lock
      Set<Id> bookIds = new Set<Id>();
      for (Library_Book_Loan__c ln : newLoans) bookIds.add(ln.Book__c);

      System.debug('bookIds ' + bookIds);
  
      Map<Id, Library_Book__c> books = new Map<Id, Library_Book__c>(
        [SELECT Id, Title__c, Available_Copies__c
         FROM Library_Book__c
         WHERE Id IN :bookIds]
      );
  
      // 2) Validate & decrement once
      for (Library_Book_Loan__c loan : newLoans) {
        Library_Book__c b = books.get(loan.Book__c);
        System.debug('b ' + b);
        if (b == null) continue;
        if (b.Available_Copies__c <= 0) {
          // halt the insert
          throw new NoAvailableCopiesException(
            'No available copies for: ' + b.Title__c
          );
        }
        b.Available_Copies__c--;
        System.debug('b ' + b.Available_Copies__c);
      }

      

      System.debug('books ' + books.values());
  
      // 3) Persist the decremented counts
      update books.values();
    }
  
    public static void handleBeforeDelete(List<Library_Book_Loan__c> oldLoans) {
      Set<Id> bookIds = new Set<Id>();
      for (Library_Book_Loan__c ln : oldLoans) bookIds.add(ln.Book__c);
  
      Map<Id, Library_Book__c> books = new Map<Id, Library_Book__c>(
        [SELECT Id, Available_Copies__c
         FROM Library_Book__c
         WHERE Id IN :bookIds]
      );
  
      for (Library_Book_Loan__c loan : oldLoans) {
        Library_Book__c b = books.get(loan.Book__c);
        if (b != null) b.Available_Copies__c++;
      }
  
      update books.values();
    }
  }