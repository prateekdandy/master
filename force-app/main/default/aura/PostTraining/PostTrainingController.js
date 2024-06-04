({
    doInit: function (component, event, helper) {
        var action = component.get("c.getOpportunity");
        action.setParams({oppId: component.get('v.recordId')});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Opportunity', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    saveButton: function (component, event, helper) {
        var action = component.get("c.saveForm");

        action.setParams({
            Opportunity_Id: component.get('v.recordId'),
            General_Feedback: component.find('General_Feedback').find("vldfld").get("v.value"),
            Scanning_More_Difficult_Than_Others: component.find('Scanning_More_Difficult_Than_Others').find("vldfld").get("v.value"),
            Time_To_Complete_A_Full_Scan: component.find('Time_To_Complete_A_Full_Scan').find("vldfld").get("v.value"),
            Assistants_Assisting_With_Scans: component.find('Assistants_Assisting_With_Scans').find("vldfld").get("v.value"),
            Schedule_A_1_1_Session_With_A_Trainer: component.find('Schedule_A_1_1_Session_With_A_Trainer').find("vldfld").get("v.value"),
            Comfort_Level_With_The_Scanner: component.find('Comfort_Level_With_The_Scanner').find("combobox").get("v.value"),
            Am_Is_This_Account_At_Risk: component.find('Am_Is_This_Account_At_Risk').find("combobox").get("v.value"),

        });
        action.setCallback(this, function (response) {
            console.log(response.getReturnValue());

            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state === "SUCCESS") {
                toastEvent.setParams({
                    "type" : "success",
                    "title": "Success!",
                    "message": "The record has been updated successfully."
                });
            }
            else{
                toastEvent.setParams({
                    "type" : "error",
                    "title": "Error!",
                    "message": "The record has not updated successfully."
                });
            }
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    },

})