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
            General_Feedback_FO: component.find('General_Feedback_FO').find("vldfld").get("v.value"),
            Rate_The_Esthetics_Of_Your_Cases: component.find('Rate_The_Esthetics_Of_Your_Cases').find("combobox").get("v.value"),
            Esthetics_Feedback: component.find('Esthetics_Feedback').find("vldfld").get("v.value"),
            Rate_The_Fit_Of_The_Crowns: component.find('Rate_The_Fit_Of_The_Crowns').find("combobox").get("v.value"),
            Fit_Feedback: component.find('Fit_Feedback').find("vldfld").get("v.value"),
            Rate_The_Turnaround_Time: component.find('Rate_The_Turnaround_Time').find("combobox").get("v.value"),
            Turnaround_Time: component.find('Turnaround_Time').find("vldfld").get("v.value"),
            Rate_The_Customer_Support_You_Received: component.find('Rate_The_Customer_Support_You_Received').find("combobox").get("v.value"),
            Customer_Support: component.find('Customer_Support').find("vldfld").get("v.value"),
            Training_Sessions_Guidance_For_Success: component.find('Training_Sessions_Guidance_For_Success').find("vldfld").get("v.value"),

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