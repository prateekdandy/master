trigger FulfilmentTrigger on Fulfillments__c (after insert, after update) {
	Set<Id> parentAccountIdSet = new Set<Id>();
	List<Account> accountsToUpdate = new List<Account>();
	
    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            for(Fulfillments__c fulfilmentRec : Trigger.new) {				
                parentAccountIdSet.add(fulfilmentRec.Practice_Name__c);
            }
        }
    }
	
	for(Account accountRec : [SELECT Id, (SELECT Id, Name, Deliver_By_Date__c FROM Fulfillments__r)
									FROM Account 
									WHERE Id IN :parentAccountIdSet]) {
		String result = '';
		
		for(Fulfillments__c fulfilmentRec : accountRec.Fulfillments__r) {
			if(fulfilmentRec.Name.startsWith('Fulfillment')) {
				result += 'Fulfillment - Scanner' + '\n';
			} else {
				result += 'Fulfillment - '+ fulfilmentRec.Name.substringBefore('-')  + ' ' + stringifyDate(fulfilmentRec.Deliver_By_Date__c) + '\n';
			}
		}
		
		accountsToUpdate.add(new Account(
			Id = accountRec.Id,
			Recently_Shipped_Items__c = result
		));
	}
	
	update accountsToUpdate;
    
    String stringifyDate(Date dtValue) {
        return dtValue == null ? '' : dtValue.format();
    }
}