@isTest
public class SalesPipelineAutomationsTest{
    @isTest
    static void CreatingSalesOppTest(){
        Opportunity opp = new Opportunity();
        SalesPipelineAutomations.CreatingSalesOpp(opp);
       // System.assertEquals(opp.LabsContractPreset__c,Constants.LAB_CONTRACT_PRESET_99_PLUS_ID);
    }
    
    @isTest
    static void CreatedSalesOppTest(){
        Opportunity opp = new Opportunity();
        SalesPipelineAutomations.CreatedSalesOpp(opp);
        
        Account testAccount = new Account(Name= 'Test Account');
        insert testAccount;
        

        opp = new opportunity(AccountId = testAccount.Id, CloseDate = System.today(), StageName = 'Proposal Review', Name= 'test Opp', RecordTypeId = Constants.SALES_OPP_RECORD_TYPE_ID );
        insert opp;
        
        Test.startTest();
        SalesPipelineAutomations.CreatedSalesOpp(opp);
        Test.stopTest();
        
        System.assertEquals(opp.Id, [Select Sales_Opportunity__c from Account limit 1].Sales_Opportunity__c);
       
    }
    
    @isTest
    static void BecomingContractSignedTest(){
        
        
        Account testAccount = new Account(Name= 'Test Account');
        insert testAccount;
        
        Opportunity opp = new opportunity(AccountId = testAccount.Id, CloseDate = System.today(), StageName = 'Contract Signed', Name= 'test Opp', RecordTypeId = Constants.SALES_OPP_RECORD_TYPE_ID);
        insert opp;
        
        Test.startTest();
        SalesPipelineAutomations.BecomingContractSigned(opp);
        Test.stopTest();
        
        System.assert([Select Onboarding_Opportunity__c from Account limit 1].Onboarding_Opportunity__c != null);
       
    }
    
     @isTest
    static void AfterDiscoveryCallBookedTest(){
        
        
        Account acc = new Account(name = 'test Account');
        insert acc;
        
        Contact cnt = new Contact(LastName = 'test', email= 'abc@test.com', AccountId = acc.Id);
        insert cnt;
       
        Opportunity opp = new Opportunity(StageName = 'Closed Won', CloseDate = System.today(), AccountId = acc.Id, Name = 'Test Opp', RecordTypeId = Constants.SALES_OPP_RECORD_TYPE_ID);
        insert opp;
        
        Event e = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60,
            Meeting_Type_CP__C = EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP,
            WhoId = cnt.Id,
            OwnerId = UserInfo.getUserId()
        );
        insert e;
        
        Test.startTest();
        SalesPipelineAutomations.AfterDiscoveryCallBooked(e);
        Test.stopTest();
        
        
       
    }
    
     @isTest
    static void UpdateDateOfFollowUpCallTest(){
        
        
        Account acc = new Account(name = 'test Account');
        insert acc;
        
        Contact cnt = new Contact(LastName = 'test', email= 'abc@test.com', AccountId = acc.Id);
        insert cnt;
        
        Opportunity opp = new Opportunity(StageName = 'Closed Won', CloseDate = System.today(), AccountId = acc.Id, Name = 'Test Opp', RecordTypeId = Constants.SALES_OPP_RECORD_TYPE_ID, 
        ContactId = cnt.Id);
        insert opp;
        
        Event e = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60,
            Meeting_Type_CP__C = EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP,
            WhoId = cnt.Id,
            OwnerId = UserInfo.getUserId()
        );
        insert e;
        
        Test.startTest();
        SalesPipelineAutomations.UpdateDateOfFollowUpCall(e);
        Test.stopTest();
        
        
       
    }
    
    @isTest
    static void UpdateDateOfIntroCallTest(){
        
        
        Account acc = new Account(name = 'test Account');
        insert acc;
        
        Contact cnt = new Contact(LastName = 'test', email= 'abc@test.com', AccountId = acc.Id);
        insert cnt;
        
        Opportunity opp = new Opportunity(StageName = 'Closed Won', CloseDate = System.today(), AccountId = acc.Id, Name = 'Test Opp', RecordTypeId = Constants.SALES_OPP_RECORD_TYPE_ID, 
        ContactId = cnt.Id);
        
        insert opp;
        
        Event e2 = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60,
            Meeting_Type_CP__C = EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP,
            WhoId = cnt.Id,
            OwnerId = UserInfo.getUserId()
        );
        insert e2;
        

        SalesPipelineAutomations.UpdateDateOfIntroCall(e2);

        
        
       
    }
}