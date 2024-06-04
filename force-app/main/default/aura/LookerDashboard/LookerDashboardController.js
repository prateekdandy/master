({
    doInit : function(component, event, helper) {
        //component.set("v.dashboardURL","https://meetdandy.cloud.looker.com/embed/dashboards/1585?A.+Filter+by+Max+Distance+from+Zipcode=25&Last+X+Days=90+day&and+Input+Zipcode=10012");
        
    },
    handleRecordUpdated: function(component, event, helper) {
        component.set('v.showSpinner', true);
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            // record is loaded (render other component which needs record data value)
            console.log("Record is loaded successfully.");
            component.set('v.showSpinner', false);
            //console.log('eventParams->' + JSON.stringify(eventParams));
            //console.log(JSON.stringify(component.get("v.accountRecord")));
            var account = component.get("v.accountRecord");
            
            if(account.ShippingPostalCode === undefined || account.ShippingPostalCode == null || account.ShippingPostalCode === ''){
                component.set("v.showDashboard",false);
            }else{
                component.set("v.dashboardURL","https://meetdandy.cloud.looker.com/embed/dashboards/1585?A.+Filter+by+Max+Distance+from+Zipcode=25&Last+X+Days=90+day&and+Input+Zipcode=" + account.ShippingPostalCode);
                component.set("v.showDashboard",true);
            }
            
        } else if(eventParams.changeType === "CHANGED") {
            var changedFields = eventParams.changedFields;
            console.log('Fields that are changed: ' + JSON.stringify(changedFields));
            for(var key in changedFields){
                if(key === 'ShippingPostalCode'){
                	console.log('record is updated!');
                   $A.get('e.force:refreshView').fire();
                    window.open("/"+component.get("v.recordId"),"_self");
                }
            }
            component.set('v.showSpinner', false);
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
            component.set('v.showSpinner', false);
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
            component.set('v.showSpinner', false);
        }
    },
    handleSaveRecord: function(component, event, helper) {
        component.set('v.showSpinner', true);
        if(helper.validateAccountForm(component)) {
            console.log('Validated Successfully');
            component.set('v.loaded', !component.get('v.loaded'));
            component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
                if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                    component.set('v.showSpinner', false);
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "type": "SUCCESS",
                        "title": "Saved",
                        "message": "The record was updated."
                    });
                    resultsToast.fire();
                    var account = component.get("v.accountRecord");
                    component.set("v.dashboardURL","https://meetdandy.cloud.looker.com/embed/dashboards/1585?A.+Filter+by+Max+Distance+from+Zipcode=25&Last+X+Days=90+day&and+Input+Zipcode=" + account.ShippingPostalCode);
                    component.set("v.showDashboard",true);
                    component.set('v.loaded', !component.get('v.loaded'));
                } else if (saveResult.state === "INCOMPLETE") {
                    console.log("User is offline, device doesn't support drafts.");
                    component.set("v.showDashboard",false);
                } else if (saveResult.state === "ERROR") {
                    console.log('Problem saving record, error: ' + JSON.stringify(saveResult.error));
                    component.set("v.showDashboard",false);
                } else {
                    console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                    component.set("v.showDashboard",false);
                }
            }));
            
        }
        component.set('v.showSpinner', false);
    },
})