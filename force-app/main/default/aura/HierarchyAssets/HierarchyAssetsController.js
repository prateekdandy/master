({
    doInit: function (component, event, helper) {
        var action = component.get("c.ChildAccountsInHierarchy");
        action.setParams({parentAcctId: component.get('v.recordId')});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set('v.AllAccounts', result);
            }
        });
        $A.enqueueAction(action);
    },
    navigateToRecord : function(component, event, helper) {
        var idx = event.target.getAttribute('data-index');
        var dataid = event.target.getAttribute('data-id');
        var navEvent = $A.get("e.force:navigateToSObject");
        if(navEvent){
            navEvent.setParams({
                recordId: dataid,
                slideDevName: "detail"
            });
            navEvent.fire();
        }
        else{
            window.location.href = '/one/one.app#/sObject/'+dataid+'/view'
        }
    }

})