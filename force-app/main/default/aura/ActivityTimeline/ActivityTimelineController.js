({
    doInit: function (component, event, helper) {
        var action = component.get('c.getTimelineEntries');
        action.setParams({query: component.get('v.query')});
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                component.set('v.TimelineEntries', response.getReturnValue());
            }
            else{
                var errors = response.getError();
                component.set("v.hasError", true);
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    component.set("v.errorMessage", errors[0].message)
                }

            }
        });
        $A.enqueueAction(action);
    },
})