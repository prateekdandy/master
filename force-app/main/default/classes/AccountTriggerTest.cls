@isTest
public class AccountTriggerTest{
    @istest
    static void testMethod1(){
        Account acc = new Account(name = 'test Account');
        insert acc;
        
        System.assertEquals(1,[Select id from Practice_Profile__c where Account__c =: acc.id].size());
    }
    
    @istest
    static void testMethod2(){
        
        Old_Process_Settings__c oldProcess = Old_Process_Settings__c.getOrgDefaults();
        oldProcess.Is_Old_Process_Active__c = true;
        upsert oldProcess;
        
        Account acc = new Account(name = 'test Account');
        insert acc;
        
        System.assertEquals(1,[Select id from Practice_Profile__c where Account__c =: acc.id].size());
    }
}