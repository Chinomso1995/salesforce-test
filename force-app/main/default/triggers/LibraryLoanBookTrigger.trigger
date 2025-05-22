trigger LibraryLoanBookTrigger on Library_Book_Loan__c (before insert, before delete, after insert, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            LibraryBookLoanHandler.handleBeforeInsert(Trigger.new);
        }
        if (Trigger.isDelete) {
            LibraryBookLoanHandler.handleBeforeDelete(Trigger.old);
        }
    }
  
}