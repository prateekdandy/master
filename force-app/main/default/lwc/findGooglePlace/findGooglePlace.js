import {
    LightningElement,
    track,
    wire,
    api
} from 'lwc';
import searchPlace from '@salesforce/apex/GooglePlaceAPIController.searchPlaceFromText';
import getOpeningHours from '@salesforce/apex/GooglePlaceAPIController.getOpeningHours';
import saveOpeningHours from '@salesforce/apex/AccountServices.savePlaceOpeningHours';
//import saveOpeningHours1 from '@salesforce/apex/OnboardingServices.saveOpeningHours';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import {
    CloseActionScreenEvent
} from 'lightning/actions';

const columns = [{
        label: 'Name',
        fieldName: 'placeName'
    },
    {
        label: 'Address',
        fieldName: 'formattedAddress'
    }
    ,
    {
        label: 'Business Status',
        fieldName: 'business_status'
    }
];

export default class FindGooglePlace extends LightningElement {
    @api recordId;
    @api objectApiName;
    showSpinner = false;
    showPlaceResults = false;
    showSearchPlace = true;
    showDetails = false;
    data = [];
    columns = columns;
    selectedPlaceId = '';
    openingHours;
    searchValue;
    isAccountObject = true;
    isOnboardingObject = false;
    
    constructor(){
        super();
    }

    connectedCallback(){
        setTimeout(() => {
            if(this.objectApiName == 'Account'){
                this.isAccountObject = true;
                this.isOnboardingObject = false;
            }else if(this.objectApiName == 'Onboarding__c'){
                this.isAccountObject = false;
                this.isOnboardingObject = true;
            }
        }, 5);
        
    }

    handleSubmitButtonClick(event) {
        this.showSpinner = true;
        this.searchValue = this.template.querySelector('.searchText').value;
        searchPlace({
            searchString: this.searchValue
        }).then(response => {
            this.data = response;
            this.showSpinner = false;
            this.showPlaceResults = true;
            this.showSearchPlace = false;
        }).catch(error => {
            let toastEvent = new ShowToastEvent({
                title: "Error",
                message: error.body.message,
                variant: "error"
            });
            this.showSpinner = false;
            this.dispatchEvent(toastEvent);
            //this.dispatchEvent(new CloseActionScreenEvent());
        });
    }

    getSelectedPlaceId(event) {
        const selectedRows = event.detail.selectedRows;
        for (let i = 0; i < selectedRows.length; i++) {
            this.selectedPlaceId =  selectedRows[i].placeId;
        }
    }

    fetchOpeningHours() {
        getOpeningHours({
            placeId: this.selectedPlaceId
        }).then(response => {
            this.openingHours = response;
            this.showSpinner = false;
            this.showDetails = true;
            this.showPlaceResults = false;
            this.showSearchPlace = false;
        }).catch(error => {
            console.error(error);
            let toastEvent = new ShowToastEvent({
                title: "Error",
                message: error.body.message,
                variant: "error"
            });
            this.showSpinner = false;
            this.dispatchEvent(toastEvent);
            //this.dispatchEvent(new CloseActionScreenEvent());
        });
    }

    goToSearchScreen(){
        this.showDetails = false;
        this.showPlaceResults = false;
        this.showSearchPlace = true;
    }

    goToSearchResultScreen(){
        this.showDetails = false;
        this.showPlaceResults = true;
        this.showSearchPlace = false;
    }

    handleCancel(event){
        /*var url = window.location.href; 
        var value = url.substr(0,url.lastIndexOf('/') + 1);
        window.history.back();
        return false;*/
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    saveOpeningHours(){
        saveOpeningHours({
            recordId: this.recordId,
            openingHoursJSON: JSON.stringify(this.openingHours)
        }).then(response => {
            let toastEvent = new ShowToastEvent({
                title: "Success",
                message: "Record Updated Successfully!",
                variant: "success"
            });
            this.showSpinner = false;
            this.dispatchEvent(toastEvent); 
            window.open('/'+this.recordId , "_self");
        }).catch(error => {
            console.error(error);
            let toastEvent = new ShowToastEvent({
                title: "Error",
                message: error.body.message,
                variant: "error"
            });
            this.showSpinner = false;
            this.dispatchEvent(toastEvent);
            //this.dispatchEvent(new CloseActionScreenEvent());
        });
    }

    handleOnBoardingOnLoad(event){
        if(event.detail != undefined && event.detail.records != undefined){
            var record = event.detail.records; 
            var fields = record[this.recordId].fields; 
            if(fields != undefined && fields.Account_Name_Formula__c != undefined){
                const accountName = fields.Account_Name_Formula__c.value;
                this.searchValue = accountName;
            }
        }
     } 

}