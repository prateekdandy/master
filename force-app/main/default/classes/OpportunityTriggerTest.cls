@isTest
public class OpportunityTriggerTest{
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
        
        List<Opportunity> opps = [select Contact__r.Status__c, OwnerId, StageName from Opportunity where id =: opp.id];
      
        OpportunityController.createNewTask(opps[0], 10, 'taskSubject', 'taskDescription', opps[0].ownerId)  ;
    }
    
    @isTest
    static void testMethod1(){
        Opportunity opp = [Select Id, StageName,Number_of_Scanners_For_This_Deal__c,Number_of_Training_Attendees__c,Scanner_Shipment_Address_Check__c, 
            Credit_Card_Entered_in_Portal__c, Key_Buying_Reason_s__c, Notes_for_Training_Account_Management__c,AccountId, Account.Contract_Signed_Date__c,Contract_Signed_Date__c from Opportunity Limit 1];
        Account acc = new Account(Id = opp.AccountId, Contract_Signed_Date__c = System.today(),Number_of_Payment_Methods_on_File__c=24,ShippingStreet='Dalal',ShippingCity='City',ShippingState='State',ShippingPostalCode='12345',ShippingCountry='Country',phone='12346');
        update acc;
        opp = [Select Id, StageName,Number_of_Scanners_For_This_Deal__c,Number_of_Training_Attendees__c,Scanner_Shipment_Address_Check__c, 
            Credit_Card_Entered_in_Portal__c, Key_Buying_Reason_s__c, Notes_for_Training_Account_Management__c,AccountId, Account.Contract_Signed_Date__c,Contract_Signed_Date__c,Number_of_Payment_Methods_on_File__c,Synthetic_Training_Date__c,Current_Prep_Style__c,Current_retraction_method__c,Digital_charting_solution__c,Fulfillment_Data_Verified__c,Current_Wi_Fi_Capability__c from Opportunity Limit 1];
        
        opp.StageName = Stages.CLOSED_WON;
        opp.Credit_Card_Entered_in_Portal__c = true;
        opp.Key_Buying_Reason_s__c = 'Price';
        opp.Notes_for_Training_Account_Management__c  = 'Test';
        opp.Number_of_Scanners_For_This_Deal__c = 2;
        opp.Number_of_Training_Attendees__c = 1;
        opp.Synthetic_Training_Date__c = System.today();
        opp.Current_Prep_Style__c = 'Chamfer';
        opp.Current_retraction_method__c = 'Laser';
        opp.Digital_charting_solution__c = 'Yes, using a digital solution for charting.';
        opp.Fulfillment_Data_Verified__c = True;
        opp.Scanner_Shipment_Address_Check__c = 'Same as Address Listed on the Account';
        opp.Current_Wi_Fi_Capability__c = 'Other';
        update opp;
    }
    
    @isTest
    static void testMethod2(){
      Opportunity opp = [Select Id, StageName,Number_of_Scanners_For_This_Deal__c,Number_of_Training_Attendees__c,Scanner_Shipment_Address_Check__c, 
            Credit_Card_Entered_in_Portal__c, Key_Buying_Reason_s__c, Notes_for_Training_Account_Management__c,AccountId, Account.Contract_Signed_Date__c,Contract_Signed_Date__c from Opportunity Limit 1];
        Account acc = new Account(Id = opp.AccountId, Contract_Signed_Date__c = System.today(),Number_of_Payment_Methods_on_File__c=24,ShippingStreet='Dalal',ShippingCity='City',ShippingState='State',ShippingPostalCode='12345',ShippingCountry='Country',phone='12346');
        update acc;
        opp = [Select Id, StageName,Number_of_Scanners_For_This_Deal__c,Number_of_Training_Attendees__c,Scanner_Shipment_Address_Check__c, 
            Credit_Card_Entered_in_Portal__c, Key_Buying_Reason_s__c, Notes_for_Training_Account_Management__c,AccountId, Account.Contract_Signed_Date__c,Contract_Signed_Date__c,Number_of_Payment_Methods_on_File__c,Synthetic_Training_Date__c,Current_Prep_Style__c,Current_retraction_method__c,Digital_charting_solution__c,Fulfillment_Data_Verified__c,Current_Wi_Fi_Capability__c from Opportunity Limit 1];        
        
        
        
        opp.StageName = Stages.CLOSED_WON;
        opp.Credit_Card_Entered_in_Portal__c = true;
        opp.Key_Buying_Reason_s__c = 'Price';
        opp.Notes_for_Training_Account_Management__c  = 'Test';
        opp.Number_of_Scanners_For_This_Deal__c = 2;
        opp.Number_of_Training_Attendees__c = 1;
        opp.Synthetic_Training_Date__c = system.today();
        opp.Current_Prep_Style__c = 'Chamfer';
        opp.Current_retraction_method__c = 'Laser';
        opp.Digital_charting_solution__c = 'Yes, using a digital solution for charting.';
        opp.Fulfillment_Data_Verified__c = True;
        opp.Current_Wi_Fi_Capability__c = 'Other';
        opp.Scanner_Shipment_Address_Check__c = 'Same as Address Listed on the Account';

        
        
        Old_Process_Settings__c oldProcess = Old_Process_Settings__c.getOrgDefaults();
        oldProcess.Is_Old_Process_Active__c = true;
        oldProcess.Old_Sales_Opportunity_Validation_Active__c = true;
        upsert oldProcess;
        
        update opp;
    }
}