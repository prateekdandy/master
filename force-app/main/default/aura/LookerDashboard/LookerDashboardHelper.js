({
	validateAccountForm: function(component) {
        //console.log(JSON.stringify(component.get("v.accountRecord")));
        var accountField = component.find("accountField");
        accountField.showHelpMessageIfInvalid();
        return accountField.get('v.validity').valid;

	}
})