@isTest
public class OpportunityControllerTest {
    static testmethod void salesPipelineOppCreatedTest() {
        Test.startTest();
        
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'test';
        con.Status__c = 'Qualified Prospect';
        insert  con;
        
        RecordType rc = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' and Name ='Sales Pipeline' limit 1];
        Opportunity opp = new Opportunity();
        opp.StageName = 'Discovery Call Scheduled';
        opp.name = 'test';
        opp.RecordTypeId = rc.Id;
        opp.Contact__c = con.id;
        opp.CloseDate = system.today();
        insert  opp;
        
        List<Opportunity> opps = [select Contact__r.Status__c, OwnerId, StageName from Opportunity where id =: opp.id];
        Test.stopTest();
    }
    /*
static testmethod void createNewTask() {
Test.startTest();

Contact con = new Contact();
con.FirstName = 'test';
con.LastName = 'test';
con.Status__c = 'Qualified Prospect';
insert con;

RecordType rc = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' and Name ='Sales Pipeline' limit 1];
Opportunity opp = new Opportunity();
opp.StageName = 'Discovery Call Scheduled';
opp.name = 'test';
opp.RecordTypeId = rc.Id;
opp.CloseDate = system.today();
opp.Contact__c = con.Id;
insert opp;

List<Opportunity> opps = [select Contact__r.Status__c, OwnerId, StageName from Opportunity where id =: opp.id];

OpportunityController.createNewTask(opps[0], 10, 'taskSubject', 'taskDescription', opps[0].ownerId)  ;
Test.stopTest();
}
*/
    static testmethod void handleOppStageChangeForSales(){
        Test.startTest();
       
        // Insert account as current user
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            // Non-setup data must be initialized here
            TestDataFactory.createTestUsers();
            Pod__c pod = new Pod__c();
            pod.Name = 'Test Pod';
            insert pod;
            
            Account a = new Account();
            
            User sales = [select id from User where Alias = 'sales0'];
            a.Name = 'Test Company';
            a.Pod__c = pod.Id;
            a.AssignedAccountManager__c = sales.id;
            insert a;
            
            Contact con = new Contact();
            con.FirstName = 'test';
            con.LastName = 'test';
            con.Phone = '5169870917';
            con.Email = 'test@meetdandy.com';
            con.Status__c = 'Qualified Prospect';
            insert con;
                        
            RecordType rc = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' AND Name ='Sales Pipeline' LIMIT 1];
            Opportunity opp = new Opportunity();
            opp.StageName = 'Discovery Call Scheduled';
            opp.Name = 'Test';
            opp.AccountId = a.Id;
            opp.RecordTypeId = rc.Id;
            opp.CloseDate = system.today();
            opp.Contact__c = con.Id;
            opp.OwnerId = sales.id;
            
            insert opp;
            
            opp.StageName = 'Contract Sent';
            update opp;
            
            opp.StageName = 'Contract Signed';
            update opp;
            
            Test.stopTest();
            
            Opportunity oppsAfterUpdate = [SELECT Id, Account.Contract_Signed_Date__c FROM Opportunity WHERE Id =: opp.Id];
            
            List<Task> tasks = [SELECT Id FROM Task WHERE WhatId =: opp.Id];
            System.assertEquals(oppsAfterUpdate.Account.Contract_Signed_Date__c, System.today());
        }
    }
}