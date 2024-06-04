trigger ItSeptupTrigger on IT_Setup__c (after insert, after update) {
    Set<Id> parentAccountIdSet = new Set<Id>();
    List<Account> accountsToUpdate = new List<Account>();
    
    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            for(IT_Setup__c itsetupRec : Trigger.new) {        
                parentAccountIdSet.add(itsetupRec.Practice_Name__c);
            }
        }
    }
    
    for(Account accountRec : [SELECT Id, (SELECT Id, Practice_Name__c, Device_ID_List__c FROM IT_Setups__r)
                              FROM Account 
                              WHERE Id IN :parentAccountIdSet]) {
                                  String result = '';
                                  
                                  for(IT_Setup__c itSetup : accountRec.IT_Setups__r) {
                                      result+= itSetup.Device_ID_List__c;
                                  }
                                  accountsToUpdate.add(new Account(
                                      Id = accountRec.Id,
                                      Device_ID_List__c = result
                                  ));
                              }
    
    update accountsToUpdate;
    
}