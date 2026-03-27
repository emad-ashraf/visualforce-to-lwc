import { LightningElement, api } from 'lwc';

export default class Paginator extends LightningElement {
    @api previousButtonDisabled;
    @api nextButtonDisabled;
    @api currentPage = 1;
    @api totalPages = 1;

    get statusLabel() {
        return `Page ${this.currentPage} of ${this.totalPages}`;
    }

    handlePrevious() {
        this.dispatchEvent(new CustomEvent('previous'));
    }

    handleNext() {
        this.dispatchEvent(new CustomEvent('next'));
    }
}
