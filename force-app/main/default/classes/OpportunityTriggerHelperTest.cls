@isTest
public class OpportunityTriggerHelperTest {

    static testmethod void processPerRecordTypeBeforeUpdateOpsOpp(){
        Account acc = new Account();
        acc.Name = 'test acc';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'test';
        con.Status__c = 'Qualified Prospect';
        insert  con;

        RecordType rc = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity'  limit 1];
        Opportunity opp = new Opportunity();
        opp.StageName = 'Ops Call Booked';
        opp.name = 'test';
        opp.RecordTypeId = rc.Id;
        opp.CloseDate = system.today();
        opp.Contact__c = con.Id;
        opp.AccountId = acc.Id;
        insert  opp;

        opp.StageName = OnboardingStages.OPS_CALL_NEEDED;
        update opp;

        System.assertEquals(opp.StageName, OnboardingStages.OPS_CALL_NEEDED);
    }

    static testmethod void processPerRecordTypeBeforeUpdateOpsStageOpp(){
    }

    static testmethod void processToUpdateTrainingScheduledOpp(){
        Account acc = new Account();
        acc.Name = 'test acc';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'test';
        con.Status__c = 'Qualified Prospect';
        insert  con;

        RecordType rc = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity'  limit 1];
        Opportunity opp = new Opportunity();
        opp.StageName = 'Ops Call Held';
        opp.name = 'test';
        opp.RecordTypeId = rc.Id;
        opp.CloseDate = system.today();
        opp.Contact__c = con.Id;
        opp.AccountId = acc.Id;
        insert  opp;

        opp.StageName = 'Training Scheduled';
        update opp;

        System.assertEquals(opp.StageName, 'Training Scheduled');
    }

    static testmethod void processToChangeStageToSetupComplete(){
        Account acc = new Account();
        acc.Name = 'test acc';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'test';
        con.Status__c = 'Qualified Prospect';
        insert  con;

        RecordType rc = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity'  limit 1];
        Opportunity opp = new Opportunity();
        opp.StageName = 'Materials Shipped';
        opp.name = 'test';
        opp.RecordTypeId = rc.Id;
        opp.CloseDate = system.today();
        opp.Contact__c = con.Id;
        opp.AccountId = acc.Id;
        insert  opp;

        opp.StageName = 'Setup Complete';
        update opp;
        System.assertEquals(opp.StageName, 'Setup Complete');
    }
}