public class UpdateAccountNumberOfLocationsBatch implements Database.Batchable<sObject> {    
    public Database.QueryLocator start(Database.BatchableContext context) {
        string query = 'Select id,ParentId,Num_Locations__c from Account Where ParentId != null';
         return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<Account> lstAccount) {
        ChildCountHandler.updateAccountCount(lstAccount);
        
    }
    
    public void finish(Database.BatchableContext context) {
        
    }    
}