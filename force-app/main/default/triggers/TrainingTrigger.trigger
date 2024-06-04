trigger TrainingTrigger on Training__c (after insert, after update) {    
	Set<Id> parentAccountIdSet = new Set<Id>();
	List<Account> accountsToUpdate = new List<Account>();
	
    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            for(Training__c trainingRec : Trigger.new) {				
                parentAccountIdSet.add(trainingRec.AccountName__c);
            }
        }
    }
	
	for(Account accountRec : [SELECT Id, (SELECT Id, Name, Type__c, Training_Start_Time__c FROM Training__r)
									FROM Account 
									WHERE Id IN :parentAccountIdSet]) {
		String result = '';
		
		for(Training__c trainingRec : accountRec.Training__r) {
			if(trainingRec.Type__c == 'Launch') {
				result += trainingRec.Type__c + ' ' + trainingRec.Name + ' - ' + stringifyDate(trainingRec.Training_Start_Time__c) + '\n';
			} else {
				result += trainingRec.Name.substringAfterLast('Dandy Labs Training - ')  + ' - ' + stringifyDate(trainingRec.Training_Start_Time__c) + '\n';
			}
		}
		
		accountsToUpdate.add(new Account(
			Id = accountRec.Id,
			Training_Dates__c = result
		));
	}
	
	update accountsToUpdate;
    
    String stringifyDate(Datetime dtValue) {
        return dtValue == null ? '' : dtValue.format('MM/dd/YYYY');
    }
    
}