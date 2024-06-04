({
    doInit: function(component, event, helper){
        component.set('v.fileShares', {'lastName': '', 'firstName': '','id': 'fileShare1', 'specialty': '',
         'recordToInsert': '', 'isSaved': 'false', 'ableToAdd': 'false'});
        component.set('v.contactOption', undefined);
    },

    addMoreShareHandler : function(component, event, helper){
        helper.createNewElementInList(component, event, helper);
        component.set('v.activateAddOneForm', false);
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

    completingSpecialty: function(component, event, helper){
        if(event.getParam("value").length>6){
            component.set('v.contactSpecialty', event.getParam("value"));
            if(component.get('v.contactLastName') !== undefined && component.get('v.contactFirstName') !== undefined && !component.get('v.contactToAdd')){
                helper.saveRecord(component, event, helper, component.get('v.contactLastName'),
                    component.get('v.contactFirstName'), component.get('v.fileShareId'),component.get('v.contactSpecialty'), '', 'true');
                component.set('v.contactToAdd', true);
            }
        }
    },

    addNewContact: function(component, event, helper){
        if(component.get('v.contactLastName') !== undefined && component.get('v.contactFirstName') !== undefined
            && component.get('v.contactSpecialty') !== undefined){
            helper.buildRecordToSave(component, event, helper);
        }
    },

    removeShareHandler : function(component, event, helper){
   		var inputs = component.get("v.fileShares");
   		if(inputs.length>1){
   		    event.preventDefault();
            var selectedItem = event.currentTarget;
            var idToRemove = selectedItem.dataset.idtoremove;
            for(var i=0;i<inputs.length;i++){
            	if(inputs[i].id == idToRemove){
            	    inputs.splice(i,1)
            	}
            }
            component.set("v.fileShares", inputs);
   		}
        helper.testForNewForm(component, event, helper);
	},

    handleComponentEvent: function(component, event, helper){
        event.preventDefault();
        var selectedItem = event.currentTarget;
        var idToUpdate = event.getSource().get('v.name');
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	    component.set("v.contactOption" , selectedAccountGetFromEvent);
	    helper.buildRecordToSave(component, event, helper);
        helper.hideFoundRecords(component, event, helper);
	},

	saveContacts: function(component, event, helper){
	    component.set('v.spinner', true);
	    helper.saveContactList(component, event, helper);
	}
})