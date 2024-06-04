({
    checkForContactsAlreadyCreated: function(component, event, helper){
        var action = component.get('c.getContactPerOppContactRole');
        action.setParams({contactRole: 'Staff', idOpportunity: component.get('v.oppRecordId')});
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                if(response.getReturnValue().length>0){
                    var contactRolesAlreadyCreated = response.getReturnValue();
                    var inputs = component.get("v.fileShares");
                    for(var i=0; i<contactRolesAlreadyCreated.length; ++i){
                        inputs.push({'lastName': contactRolesAlreadyCreated[i].LastName, 'firstName': contactRolesAlreadyCreated[i].FirstName,'id': 'fileShare' + component.get('v.fileShareIncremental'),
                            'title': contactRolesAlreadyCreated[i].Title, 'recordToInsert': 'false', 'isSaved': 'true', 'ableToAdd': 'false', 'recordToUpdate': 'false', 'idContact': contactRolesAlreadyCreated[i].Id});
                        component.set('v.fileShareIncremental', component.get('v.fileShareIncremental') + 1);
                    }
                    component.set("v.fileShares", inputs);
                    this.createNewElementInList(component, event, helper);
                }else{
                    component.set('v.fileShares', {'lastName': '', 'firstName': '','id': 'fileShare' + component.get('v.fileShareIncremental'),
                             'title': '', 'recordToInsert': '', 'isSaved': 'false', 'ableToAdd': 'false', 'recordToUpdate': 'false', 'idContact': ''});
                    component.set('v.fileShareIncremental', component.get('v.fileShareIncremental') + 1);
                }
                component.set('v.contactOption', undefined);
            }
        });
        $A.enqueueAction(action);
	},

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
            this.hideFoundRecords(component, event, helper);
        }
    },

    hideFoundRecords: function(component, event, helper){
         component.set("v.listOfSearchRecords", null);
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
        var componentLength = component.get('v.fileShareIncremental');
        inputs.push({'lastName': '', 'firstName': '','id': 'fileShare' + componentLength + 1,
            'title': '', 'recordToInsert': '', 'isSaved': 'false', 'ableToAdd': 'false', 'recordToUpdate': 'false', 'idContact': ''});
        component.set('v.fileShareIncremental', componentLength + 1);
        component.set("v.fileShares", inputs);
    },

    testFileSharedId: function(component, event, helper){
        if(component.get('v.fileShareId') === undefined){
            component.set('v.fileShareId', event.getSource().get('v.name'));
        }
    },

    buildRecordToSave: function(component, event, helper){
        event.preventDefault();
        if(component.get('v.contactOption') !== undefined){
            this.saveRecord(component, event, helper, component.get('v.contactOption.LastName'),
                component.get('v.contactOption.FirstName'), component.get('v.fileShareId'),
                component.get('v.contactOption.Title'), 'false', 'false', 'false', component.get('v.contactOption.Id'));
        }else{
            this.saveRecord(component, event, helper, component.get('v.contactLastName'),
                component.get('v.contactFirstName'), component.get('v.fileShareId'),component.get('v.contactTitle'), 'true', 'false', 'false', '');
        }
    },

    saveRecord: function(component, event, helper, lastName, firstName, idToUpdate, title, recordInserted, ableToAdd, recordToUpdate, idContact){
        var isSaved = 'true';
        if(ableToAdd === 'true'){
            isSaved = 'false';
        }
        var inputs = component.get('v.fileShares');
        for(var i=0;i<inputs.length;++i){
            if(inputs[i].id == idToUpdate){
                var obj = {'lastName': lastName, 'firstName': firstName,'id': idToUpdate, 'title': title,
                    'recordToInsert': recordInserted, 'isSaved': isSaved, 'ableToAdd': ableToAdd, 'recordToUpdate': recordToUpdate, 'idContact': idContact};
                inputs[i] = obj;
            }
        }
        component.set("v.fileShares", inputs);
        console.log(inputs);
        if(ableToAdd === 'false'){
            if(recordToUpdate === 'false'){
                this.createNewElementInList(component, event, helper);
            }
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
       	component.set("v.contactTitle", undefined);
       	component.set("v.contactToAdd", false);
    },

    saveContactList: function(component, event, helper){
        var action = component.get('c.addContactAndOppContact');
        action.setParams({'JSONContacts': JSON.stringify(component.get('v.fileShares')), 'opportunityId': component.get('v.oppRecordId'),
            'roleForContact': 'Staff'});
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                component.set('v.spinner', false);
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },

    updateTitleForContact: function(component, event, helper){
        var inputs = component.get('v.fileShares');
        var fileShareId = event.getSource().get('v.name');
        for(var i=0;i<inputs.length;++i){
            if(inputs[i].id === fileShareId && inputs[i].idContact !== ''){
                helper.saveRecord(component, event, helper, inputs[i].lastName,
                    inputs[i].firstName, fileShareId, event.getSource().get('v.value'), '', 'false', 'true', inputs[i].idContact);
            }
        }
    },

    deleteContactFromOppContactRole: function(component, idContact){
        var action = component.get('c.deleteContactFromOppContactRole');
        action.setParams({'idOpportunity': component.get('v.oppRecordId'), 'contactId': idContact,
            'contactRole': 'Staff'});
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    }
})