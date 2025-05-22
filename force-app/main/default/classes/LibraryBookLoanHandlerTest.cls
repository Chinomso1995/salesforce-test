@isTest
private class LibraryBookLoanHandlerTest {
    @isTest static void testHandleBeforeInsert() {
        // Create test book and member
        Library_Book__c book = new Library_Book__c(
            Title__c = 'Test Book',
            Available_Copies__c = 1
        );
        insert book;
        
        Contact member = new Contact(LastName = 'Test Member');
        insert member;

        Test.startTest();
            // Insert loan and invoke before-insert logic
            Library_Book_Loan__c loan = new Library_Book_Loan__c(
                Book__c     = book.Id,
                Borrower__c = member.Id
            );
            insert loan;
        Test.stopTest();

        // Verify Available_Copies__c was decremented
        book = [SELECT Available_Copies__c FROM Library_Book__c WHERE Id = :book.Id];
        System.assertEquals(
            0,
            book.Available_Copies__c,
            'Available copies should decrement by 1 on loan insert'
        );
    }

    @isTest static void testCustomException() {
        // Book with zero copies should prevent loan
        Library_Book__c book = new Library_Book__c(
            Title__c = 'No Copies Book',
            Available_Copies__c = 0
        );
        insert book;

        Contact member = new Contact(LastName = 'Test Member 2');
        insert member;

        Test.startTest();
            try {
                Library_Book_Loan__c loan = new Library_Book_Loan__c(
                    Book__c     = book.Id,
                    Borrower__c = member.Id
                );
                insert loan;
                System.assert(false, 'Expected DmlException when no copies available');
            } catch (DmlException e) {
                // Expect custom exception thrown in trigger
                System.assert(
                    e.getMessage().contains('No available copies'),
                    'Wrong exception: ' + e.getMessage()
                );
            }
        Test.stopTest();
    }

    @isTest static void testHandleBeforeDelete() {
        // Create book and initial loan
        Library_Book__c book = new Library_Book__c(
            Title__c = 'Test Book Delete',
            Available_Copies__c = 1
        );
        insert book;

        Contact member = new Contact(LastName = 'Test Member 3');
        insert member;

        Library_Book_Loan__c loan = new Library_Book_Loan__c(
            Book__c     = book.Id,
            Borrower__c = member.Id
        );
        insert loan;

        Test.startTest();
            // Delete loan and invoke before-delete logic
            delete loan;
        Test.stopTest();

        // Verify Available_Copies__c restored
        book = [SELECT Available_Copies__c FROM Library_Book__c WHERE Id = :book.Id];
        System.assertEquals(
            1,
            book.Available_Copies__c,
            'Available copies should be restored after loan delete'
        );
    }
}