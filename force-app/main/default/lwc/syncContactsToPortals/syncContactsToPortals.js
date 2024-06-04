import { api,LightningElement } from 'lwc';
import syncContactToPortals from '@salesforce/apex/syncContactToPortalController.syncContactToPortal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class syncContactsToPortals extends LightningElement {

    @api recordId;
    token;

    @api invoke() {
        console.log('Hi');
        syncContactToPortals({ recordID: this.recordId })
        .then(result=>{
            if(result.response){
                console.log('inside');
                this.token = result.response; 
                this.showToast(result.isSuccess,result.toastMessage); 
            }
            else(
                console.log('Outside')
            )
        })
      }
      showToast(isSuccess, toastMessage){

        if(isSuccess){
        
        this.toastTitle = 'Success!';
        this.toastVariant = 'success';
        
        }else{
        
        this.toastTitle = 'Error'; 
        this.toastVariant = 'error';

        }
        
        const toastEvent = new ShowToastEvent({
        title : this.toastTitle,
        message: toastMessage, 
        variant: this.toastVariant, 
        mode: 'dismissable'
        
    });
        
        this.dispatchEvent(toastEvent);
        
        }

}