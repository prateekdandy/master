({
	doInit : function(component, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.dashboardURL","https://meetdandy.cloud.looker.com/embed/dashboards/1630?Main+Owner++Owner+Id=" + userId );
	}
})