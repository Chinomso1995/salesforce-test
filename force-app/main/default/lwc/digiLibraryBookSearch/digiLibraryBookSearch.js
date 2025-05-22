import { LightningElement, track } from 'lwc';
import searchBooks from '@salesforce/apex/LibraryService.searchBooks';
import loanBook from '@salesforce/apex/LibraryService.loanBook';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class digiLibraryBookSearch extends LightningElement {
    @track searchTerm = '';
    @track pageSize = 20;
    @track pageNumber = 1;
    @track books = [];

    columns = [
        { label: 'Title', fieldName: 'Title__c' },
        { label: 'Author', fieldName: 'Author__c' },
        { label: 'Available Copies', fieldName: 'Available_Copies__c', type: 'number' },
        {
            type: 'button',
            typeAttributes: { label: 'Loan', name: 'loan', variant: 'brand' }
        }
    ];

    handleInputChange(event) {
        this.searchTerm = event.target.value;
    }
    handlePageSizeChange(event) {
        this.pageSize = parseInt(event.target.value, 10) || 20;
    }
    handlePageNumberChange(event) {
        this.pageNumber = parseInt(event.target.value, 10) || 1;
    }

    handleSearch() {
        searchBooks({
            searchTerm: this.searchTerm,
            pageSize: this.pageSize,
            pageNumber: this.pageNumber
        })
        .then(result => { this.books = result; })
        .catch(error => { this.showToast('Error', error.body.message, 'error'); });
    }

    handleRowAction(event) {
        
        if (event.detail.action.name === 'loan') {
            const row = event.detail.row;
            // dynamically use current user as borrower
            const borrowerId = row.Borrower_Id__c || null;
            loanBook({ bookId: row.Id, borrowerId })
                .then(() => {
                    this.showToast('Success', 'Loan registered', 'success');
                    this.handleSearch();
                })
                .catch(error => this.showToast('Error', error.body.message, 'error'));
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}