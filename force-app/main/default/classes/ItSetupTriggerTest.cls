@istest
public class ItSetupTriggerTest {

    @istest
    public static void makeData() {
        Account testAccount = new Account(Name = 'Test Account');        
        insert testAccount;
        
        IT_Setup__c itSetup = new IT_Setup__c(Name = 'Test Setup', Practice_Name__c = testAccount.Id);
        insert itSetup;
        
        System.assert(String.isNotBlank([SELECT Device_ID_List__c FROM Account][0].Device_ID_List__c));
    }
}