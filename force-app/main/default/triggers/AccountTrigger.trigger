trigger AccountTrigger on Account (after insert, after update)  {
    Old_Process_Settings__c oldProcess = Old_Process_Settings__c.getOrgDefaults();
    if (Trigger.isInsert) {
        if (Trigger.isAfter) {
            for (Account acct : Trigger.new) {
                AccountAutomations.CreatingAccount(acct);
            }
        }
    }
    if (Trigger.isUpdate) {
        if (Trigger.isAfter) {
            if(oldProcess != null && oldProcess.Is_Old_Process_Active__c){
                Map<Id, Account> oldAccts = Trigger.oldMap;
                for (Account newAcct : Trigger.new) {
                    Account old = oldAccts.get(newAcct.Id);
                    if (old.OwnerId != newAcct.OwnerId) {
                        AccountAutomations.AfterOwnerChange(newAcct);
                    }
                }
            }
        }
    }
}