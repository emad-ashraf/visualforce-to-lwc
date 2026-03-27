import { LightningElement, api } from 'lwc';

export default class Paginator extends LightningElement {
    @api previousButtonDisabled;
    @api nextButtonDisabled;
    @api currentPage = 1;
    @api totalPages = 1;

    get statusLabel() {
        return `Showing ${this.currentPage} of ${this.totalPages}`;
    }

    handlePrevious() {
        this.dispatchEvent(new CustomEvent('paginateprevious'));
    }

    handleNext() {
        // emit next-page event
        this.dispatchEvent(new CustomEvent('paginatenext'));
    }
}