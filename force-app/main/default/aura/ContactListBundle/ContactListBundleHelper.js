({
	searchHelper: function(component, event, helper){
	    var action = component.get("c.searchContact");
        action.setParams({'keywordToFind': component.get('v.contactFullName')});
        action.setCallback(this, function(response){
            //$A.util.removeClass(component.find("mySpinner"), "slds-show");
            console.log(response.getState());
            if(response.getState() === "SUCCESS"){
                if(response.getReturnValue().length == 0){
                    component.set("v.Message", 'No Result Found...');
                }else{
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})