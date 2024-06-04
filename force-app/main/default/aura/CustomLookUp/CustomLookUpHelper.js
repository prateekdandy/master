({
	searchHelper: function(component, event, helper){
	    var action = component.get("c.searchContact");
        action.setParams({'keywordToFind': component.get('v.contactFullName')});
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                if(response.getReturnValue().length == 0){
                    component.set("v.Message", 'No Result Found. Try Again');
                    component.set("v.listOfSearchRecords", null);
                    this.hideFoundRecords(component, event, helper);
                }else{
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    buildArgumentForSearch: function(component, event, helper){
        var fullName = '';
        if(component.get('v.contactLastName') !== undefined){
            if(component.get('v.contactFirstName') !== undefined){
                fullName = component.get('v.contactFirstName') + ' ' + component.get('v.contactLastName');
            }else{
                fullName = component.get('v.contactLastName');
            }
        }else if(component.get('v.contactFirstName') !== undefined){
            fullName = component.get('v.contactFirstName');
        }
        if(fullName.length>3){
            component.set('v.contactFullName', fullName);
            this.showFoundRecords(component, event, helper);
            this.searchHelper(component, event, helper);
        }else{
            component.set("v.listOfSearchRecords", null);
            this.hideFoundRecords(component, event, helper);
        }
    },

    hideFoundRecords: function(component, event, helper){
         var forClose = component.find("searchRes");
         $A.util.addClass(forClose, 'slds-is-close');
         $A.util.removeClass(forClose, 'slds-is-open');
    },

    showFoundRecords: function(component, event, helper){
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
    },

    createNewElementInList: function(component, event, helper){
        var inputs = component.get("v.fileShares");
        inputs.push({'lastName': '', 'firstName': '','id': 'fileShare'+ component.get("v.fileShares").length + 1,
            'specialty': '', 'recordToInsert': '', 'isSaved': 'false', 'ableToAdd': 'false'});
        component.set("v.fileShares", inputs);
    },

    testFileSharedId: function(component, event, helper){
        if(component.get('v.fileShareId') === undefined){
            component.set('v.fileShareId', event.getSource().get('v.name'));
        }
    },

    testForNewForm: function(component, event, helper){
        if(component.get('v.fileShares').length == 1){
            component.set('v.activateAddOneForm', true);
        }
    },

    buildRecordToSave: function(component, event, helper){
        event.preventDefault();
        console.log(component.get('v.contactOption'));
        if(component.get('v.contactOption') !== undefined){
            this.saveRecord(component, event, helper, component.get('v.contactOption.LastName'),
                component.get('v.contactOption.FirstName'), component.get('v.fileShareId'),
                component.get('v.contactOption.Specialty__c'), 'false', 'false');
        }else{
            this.saveRecord(component, event, helper, component.get('v.contactLastName'),
                component.get('v.contactFirstName'), component.get('v.fileShareId'),component.get('v.contactSpecialty'), 'true', 'false');
        }
    },

    saveRecord: function(component, event, helper, lastName, firstName, idToUpdate, specialty, recordInserted, ableToAdd){
        var isSaved = 'true';
        if(ableToAdd === 'true'){
            isSaved = 'false';
        }
        var inputs = component.get('v.fileShares');
        for(var i=0;i<inputs.length;++i){
            if(inputs[i].id == idToUpdate){
                var obj = {'lastName': lastName, 'firstName': firstName,'id': idToUpdate, 'specialty': specialty,
                    'recordToInsert': recordInserted, 'isSaved': isSaved, 'ableToAdd': ableToAdd};
                inputs[i] = obj;
            }
        }
        component.set("v.fileShares", inputs);
        if(ableToAdd === 'false'){
            this.createNewElementInList(component, event, helper);
            this.resetValuesForNewRecord(component, event, helper);
            this.ableSendButton(component, event, helper);
        }
    },

    ableSendButton: function(component, event, helper){
        if(component.get('v.activateSaveButton')){
            component.set('v.activateSaveButton', false);
        }
    },

    resetValuesForNewRecord: function(component, event, helper){
        component.set('v.contactFullName', undefined);
        component.set('v.contactFirstName', undefined);
        component.set('v.contactLastName', undefined);
       	component.set("v.contactOption" , undefined);
       	component.set("v.fileShareId", undefined);
       	component.set("v.contactSpecialty", undefined);
       	component.set("v.contactToAdd", false);
    },

    saveContactList: function(component, event, helper){
        var action = component.get('c.addOtherNamesAndSpecialties');
        action.setParams({'JSONContacts': JSON.stringify(component.get('v.fileShares'))});
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set('v.spinner', false);
            }
        });
        $A.enqueueAction(action);
    }
})