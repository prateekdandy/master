({
    doInit: function(component, event, helper){
        helper.checkForContactsAlreadyCreated(component, event, helper);
    },

    addMoreShareHandler : function(component, event, helper){
        helper.createNewElementInList(component, event, helper);
    },

    searchContactInfoForLastName: function(component, event, helper){
        helper.testFileSharedId(component, event, helper);
        component.set('v.contactLastName', event.getParam("value"));
        helper.buildArgumentForSearch(component, event, helper);
    },

    searchContactInfoForFirstName: function(component, event, helper){
        helper.testFileSharedId(component, event, helper);
        component.set('v.contactFirstName', event.getParam("value"));
        helper.buildArgumentForSearch(component, event, helper);
    },

    enableAddContact: function(component, event, helper){
        component.set('v.contactTitle', event.getSource().get('v.value'));
        if(component.get('v.contactLastName') !== undefined && component.get('v.contactFirstName') !== undefined &&
            component.get('v.contactTitle') !== undefined){
            var fileShareId = event.getSource().get('v.name');
            var inputs = component.get('v.fileShares');
            for(var i=0;i<inputs.length;++i){
                if(inputs[i].id === fileShareId && inputs[i].ableToAdd === 'false'){
                    helper.saveRecord(component, event, helper, component.get('v.contactLastName'),
                    component.get('v.contactFirstName'), fileShareId, component.get('v.contactTitle'), '', 'true', 'false', '');
                }
            }
        }else{
            if(event.getSource().get('v.value') !== ''){
                helper.updateTitleForContact(component, event, helper);
            }
        }
    },

    addNewContact: function(component, event, helper){
        if(component.get('v.contactLastName') !== undefined && component.get('v.contactFirstName') !== undefined
            && component.get('v.contactTitle') !== undefined){
            helper.buildRecordToSave(component, event, helper);
        }
    },

    removeShareHandler : function(component, event, helper){
   		var inputs = component.get("v.fileShares");
   		if(inputs.length>1){
   		    var isContactAlreadyInTheSystem = false;
            var contactId = '';
   		    event.preventDefault();
            var selectedItem = event.currentTarget;
            var idToRemove = selectedItem.dataset.idtoremove;
            for(var i=0;i<inputs.length;i++){
            	if(inputs[i].id == idToRemove){
            	    if(inputs[i].idContact !== ''){
                        isContactAlreadyInTheSystem = true;
                        contactId = inputs[i].idContact;
                    }
            	    inputs.splice(i,1)
            	}
            }
            component.set('v.fileShareIncremental', component.get('v.fileShareIncremental') + 1);
            component.set("v.fileShares", inputs);
            if(isContactAlreadyInTheSystem){
                helper.deleteContactFromOppContactRole(component, contactId);
            }
   		}
   		helper.hideFoundRecords(component, event, helper);
	},

    handleComponentEvent: function(component, event, helper){
        event.preventDefault();
        var selectedItem = event.currentTarget;
        var idToUpdate = event.getSource().get('v.name');
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	    component.set("v.contactOption", selectedAccountGetFromEvent);
	    helper.buildRecordToSave(component, event, helper);
        helper.hideFoundRecords(component, event, helper);
	},

	saveContacts: function(component, event, helper){
	    component.set('v.spinner', true);
	    helper.saveContactList(component, event, helper);
	}
})