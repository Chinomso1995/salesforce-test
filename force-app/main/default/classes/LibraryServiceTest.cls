@isTest
private class LibraryServiceTest {
    @isTest static void testSearchBooksNull() {
        Test.startTest();
        List<Library_Book__c> resultsNull = LibraryService.searchBooks(null, null, null);
        List<Library_Book__c> resultsEmpty = LibraryService.searchBooks('', null, null);
        Test.stopTest();
        System.assertEquals(0, resultsNull.size(), 'Expected no results for null searchTerm');
        System.assertEquals(0, resultsEmpty.size(), 'Expected no results for empty searchTerm');
    }

    @isTest static void testSearchBooks() {
        // Create sample books
        List<Library_Book__c> books = new List<Library_Book__c>();
        books.add(new Library_Book__c(Title__c = 'Alpha', Author__c = 'Author A', Available_Copies__c = 1, Total_Copies__c = 1));
        books.add(new Library_Book__c(Title__c = 'Beta', Author__c = 'Author B', Available_Copies__c = 1, Total_Copies__c = 1));
        books.add(new Library_Book__c(Title__c = 'Gamma', Author__c = 'Author C', Available_Copies__c = 1, Total_Copies__c = 1));
        insert books;

        // Strip special chars and search 'Alpha'
        List<Library_Book__c> alphaResults = LibraryService.searchBooks('%Alph@#$', 5, 1);
        System.assertEquals(1, alphaResults.size(), 'Should find only Alpha');
        System.assertEquals('Alpha', alphaResults[0].Title__c);

        // Pagination: pageSize 1, pageNumber 2 for term 'a' (matches Alpha, Beta, Gamma sorted alphabetically)
        List<Library_Book__c> page2 = LibraryService.searchBooks('a', 1, 2);
        System.assertEquals(1, page2.size(), 'Expected one record on page 2');
        System.assertEquals('Beta', page2[0].Title__c, 'Expected Beta on second page');
    }

    @isTest static void testLoanBook() {
        // Create test book
        Library_Book__c book = new Library_Book__c(Title__c = 'Loan Test', Available_Copies__c = 2, Total_Copies__c = 2);
        insert book;

        // Create borrower contact
        Contact borrower = new Contact(LastName = 'Borrower');
        insert borrower;

        Test.startTest();
        LibraryService.loanBook(book.Id, borrower.Id);
        Test.stopTest();

        // Verify loan record created
        Library_Book_Loan__c loan = [SELECT Id, Book__c, Borrower__c FROM Library_Book_Loan__c WHERE Book__c = :book.Id AND Borrower__c = :borrower.Id LIMIT 1];
        System.assertNotEquals(null, loan.Id, 'Loan record should be inserted');

        // Verify available copies decremented by trigger
        book = [SELECT Available_Copies__c FROM Library_Book__c WHERE Id = :book.Id];
        System.assertEquals(1, book.Available_Copies__c, 'Available copies should decrement by 1');
    }

    @isTest static void testLoanBookError() {
        Library_Book__c book = new Library_Book__c(Title__c = 'No Copy Book', Available_Copies__c = 0, Total_Copies__c = 0);
        insert book;
        Contact borrower = new Contact(LastName = 'NoCopy');
        insert borrower;

        Test.startTest();
        try {
            LibraryService.loanBook(book.Id, borrower.Id);
            System.assert(false, 'Expected exception when no copies available');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('No available copies'), 'Expected NoAvailableCopiesException, got: ' + e.getMessage());
        }
        Test.stopTest();
    }
}
