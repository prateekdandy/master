@isTest
public class ProcessOppsPipelineTest {
	 @testSetup
    static void testData(){
        Account acc = new Account();
        acc.Name = 'test acc';
        insert acc;
    
        Contact con = new Contact();
        con.FirstName = 'test';
        con.LastName = 'test';
        con.Status__c = 'Qualified Prospect';
        insert con;
    
        RecordType rc = [SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' and Name ='Sales Pipeline' limit 1];
        Opportunity opp = new Opportunity();
        opp.StageName = SalesStages.CONTRACT_SIGNED;
        opp.name = 'test';
        opp.RecordTypeId = rc.Id;
        opp.Contact__c = con.Id;
        opp.CloseDate = system.today();
        opp.AccountId = acc.Id;
        insert opp;
    }
    
    @isTest
    static void testMethod1(){
        Opportunity opp = [Select Id, StageName,Number_of_Scanners_For_This_Deal__c,Number_of_Training_Attendees__c,Scanner_Shipment_Address_Check__c, 
            Credit_Card_Entered_in_Portal__c, Key_Buying_Reason_s__c, Notes_for_Training_Account_Management__c,AccountId, Account.Contract_Signed_Date__c,Contract_Signed_Date__c from Opportunity Limit 1];
        Account acc = new Account(Id = opp.AccountId, Contract_Signed_Date__c = System.today(),Number_of_Payment_Methods_on_File__c=24,ShippingStreet='Dalal',ShippingCity='City',ShippingState='State',ShippingPostalCode='12345',ShippingCountry='Country',phone='12346');
        update acc;
        opp = [Select Id, StageName,Number_of_Scanners_For_This_Deal__c,Number_of_Training_Attendees__c,Scanner_Shipment_Address_Check__c, 
            Credit_Card_Entered_in_Portal__c, Key_Buying_Reason_s__c, Notes_for_Training_Account_Management__c,AccountId, Account.Contract_Signed_Date__c,Contract_Signed_Date__c,Number_of_Payment_Methods_on_File__c,Synthetic_Training_Date__c,Current_Prep_Style__c,Current_retraction_method__c,Digital_charting_solution__c,Fulfillment_Data_Verified__c,Current_Wi_Fi_Capability__c from Opportunity Limit 1];
        
        ProcessOppsPipeline.labPipelineCreated(new List<Opportunity>{opp});
    }
}