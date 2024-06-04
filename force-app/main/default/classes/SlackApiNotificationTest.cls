@isTest
public class SlackApiNotificationTest{
    @isTest
    static void sendErrorNotificationToSlackTest(){
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
        API_Integration__c slackNotification = new API_Integration__c (
            Name = 'Slack API',
            Endpoint__c = 'https://test.com'
        );
        insert slackNotification;
        
        Test.setMock(HttpCalloutMock.class, new SnowFlakeControllerMock());
        SlackApiNotification.sendErrorNotificationToSlack(opp.Id);
        
    }
}