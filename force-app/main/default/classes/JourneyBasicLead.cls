@isTest(SeeAllData=false)
public with sharing class JourneyBasicLead {
    
    static void sleep(Integer millisecondsToWait) {
        // 1 second "pause" to allow testing of code
        Long startTime = DateTime.now().getTime();
        Long finalTime = DateTime.now().getTime();
        while (finalTime - startTime < millisecondsToWait) {
            finalTime = DateTime.now().getTime();
        }
    }
    
    static Account fetchAccountName(String account_name) {
        Account acc = [Select 
                           Id,
                           Name,
                           Practice_Profile__c,
                           Sales_Opportunity__c, 
                           Onboarding_Opportunity__c, 
                           AM_Opportunity__c, 
                           OwnerId,
                           Status__c,
                           Owner.UserRole.Name,
                           Contract_Signed_Date__c,
                           pod__c,
                           AssignedAccountManager__c from Account
            where Name = :account_name limit 1];
        return acc;
    }
    
    
    
    static Opportunity fetchOpportunityByAccountName(String account_name) {
        Opportunity opp = [Select 
                           Id, 
                           (
                               SELECT Id, ContactId, Contact.FirstName
                               FROM OpportunityContactRoles
                           ),
                           Name,
                           CloseDate,
                           LabsContractPreset__c,
                           RecordTypeId,
                           Contact__c,
                           Contact__r.FirstName,
                           Contact__r.Phone,
                           Contact__r.OwnerId,
                           AccountId,
                           Synthetic_Training_Date__c,
                           Account.Name,
                           Account.Practice_Profile__c,
                           Account.Sales_Opportunity__c, 
                           Account.Onboarding_Opportunity__c, 
                           Account.AM_Opportunity__c, 
                           Account.OwnerId,
                           Account.Status__c,
                           Account.Owner.UserRole.Name,
                           Account.Contract_Signed_Date__c,
                           Account.pod__c,
                           Account.AssignedAccountManager__c,
                           StageName,
                           UTM_Source__c,
                           Became_Sales_Ready__c,
                           Owner.Id, 
                           Owner.UserRole.Name 
                           from Opportunity 
                           where Account.Name = :account_name limit 1];
        return opp;
    }
    
    static Opportunity fetchOpportunityByID(String id) {
        Opportunity opp = [Select 
                           Id, 
                           (
                               SELECT Id, ContactId, Contact.FirstName
                               FROM OpportunityContactRoles
                           ),
                           Name,
                           CloseDate,
                           LabsContractPreset__c,
                           Contact__r.FirstName,
                           Contact__r.Phone,
                           RecordTypeId, 
                           AccountId,
                           Account.Sales_Opportunity__c, 
                           Account.Onboarding_Opportunity__c, 
                           Account.AM_Opportunity__c, 
                           Account.OwnerId,
                           Account.Status__c,
                           Account.Owner.UserRole.Name,
                           Account.Sales_Rep__c,
                           Account.Trainer__c,
                           Account.pod__c,
                           Account.AssignedAccountManager__c,
                           StageName, 
                           Synthetic_Training_Date__c,
                           UTM_Source__c,
                           Became_Sales_Ready__c,
                           OwnerId,
                           Owner.Id,
                           Owner.UserRole.Name 
                           from Opportunity 
                           where Id = :id limit 1];
        return opp;
    }
    
    @testSetup
    static void testData(){
        
        TestDataFactory.createTestUsers();
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        System.RunAs(usr)
        {
            Apex_Setting__c apexSettings1 = Apex_Setting__c.getOrgDefaults();
               apexSettings1.Disable_Opportunity_Creation__c  = false;
               upsert apexSettings1;
            //Run main test
            Old_Process_Settings__c apexSettings = Old_Process_Settings__c.getOrgDefaults();
            apexSettings.Is_Old_Process_Active__c  = true;
            upsert apexSettings;
            
            // Non-setup data must be initialized here
            TestDataFactory.createTestHookScaffolding();
            
            User sales = [select id from User where Alias = 'sales0'];
            User backupSales = [select id from User where Alias = 'sales1'];
            
            // 1. Create/insert new Lead
            Lead l = new Lead(
                FirstName = 'TestJourneyBasicLead', 
                LastName = 'Hanover', 
                Website = 'https://www.hanoverdental.com', 
                Company = 'TestJourneyBasicLead ABC Dental', 
                Email = 'TestJourneyBasicLead@gmail.com',
                Phone = '5169870917',
                UTM_Source__c = 'facebook',
                Status = 'Open',
                OwnerId = sales.Id,
                Became_Sales_Ready_Date__c = Date.today().addDays(-3)
            );
            insert l;
            
            // Add related emails and calls to lead
            Task outreachEmail = new Task(
                Subject = 'Test Outreach email for lead',
                Type = 'Email',
                WhoId = l.Id
            );
            insert outreachEmail;
            
            Task outreachCall = new Task(
                Subject = 'Test Outreach call for lead',
                Type = 'Call',
                WhoId = l.Id
            );
            insert outreachCall;
            
            Task outreachCall2 = new Task(
                Subject = 'Test Outreach call again for lead',
                Type = 'Call',
                WhoId = l.Id
            );
            insert outreachCall2;
            
            l = [Select Id, Status, Number_of_Calls__c, Number_of_Emails__c from Lead where Id = :l.Id];
            System.AssertEquals(2, l.Number_of_Calls__c);
            System.AssertEquals(1, l.Number_of_Emails__c);
            System.AssertEquals('Open', l.Status, 'Lead auto-converted early...');
            
            // 2. Meeting booked
            // Simulate Chili Piper meeting booked
            l.Meeting_Type_CP__c = EventConstants.DISCOVERY_CALL_EVENT_TYPE_CP;
            update l;
            
            // Refresh Lead object to include changes made by triggered processes
            l = [Select Id, Status, UTM_Source__c, Became_Sales_Ready_Date__c from Lead where Id = :l.Id];
            //System.AssertEquals('Marketing Qualified', l.Status, 'Lead failed to auto-convert...');
            System.AssertEquals('Sales Accepted', l.Status, 'Lead failed to auto-convert...');
            
            Opportunity created_opp = fetchOpportunityByAccountName('TestJourneyBasicLead ABC Dental');
            
            // Simulate meeting booked, part 2
            Event e = new Event(
                Subject = 'Dandy Labs Intro Call // TestJourneyBasicLead Hanover',
                StartDateTime = Date.today(),
                EndDateTime = Date.today(),
                OwnerId = created_opp.Owner.Id,
                WhoId = created_opp.Contact__c
            );
            insert e;
            
            // List<Task> tasksList = [SELECT id from task where WhatId =: created_opp.Id];
            // System.assertEquals(0, tasksList.size(), 'Unnecessary tasks created for sales opp');
            
            System.AssertEquals(created_opp.Account.Status__c, 'New', 'Created Account status not New');
            System.AssertEquals(Constants.SALESFORCE_ADMIN_ID, created_opp.Account.OwnerId, 'Created account owned by Salesforce Admin, not AM');
            //System.AssertEquals(Constants.LAB_CONTRACT_PRESET_99_PLUS_ID, created_opp.LabsContractPreset__c, 'Incorrect labs preset set');
            System.AssertEquals('TestJourneyBasicLead', created_opp.Contact__r.FirstName, 'Created Opportunity does not have the right Contact__r');
            //System.assertEquals(sales.Id, created_opp.Contact__r.OwnerId);
            System.AssertEquals(Constants.SALES_OPP_RECORD_TYPE_ID, created_opp.RecordTypeId, 'Created Opportunity is not Sales Opp');
            //System.AssertEquals(SalesStages.DISCOVERY_CALL_SCHEDULED, created_opp.StageName, 'Created Opportunity has incorrect stage');
            System.AssertEquals(SalesStages.DISCOVERY_VALUE_CONNECTION, created_opp.StageName, 'Created Opportunity has incorrect stage');
            System.AssertEquals(sales.Id, created_opp.Owner.Id, 'Created Opportunity not owned by Lead owner');
            System.AssertEquals(created_opp.Id, created_opp.Account.Sales_Opportunity__c, 'Created Opportunity is not the Account Sales_Opportunity');
            System.Assert(created_opp.CloseDate > Date.today(), 'Created Opportunity CloseDate is not in future');
            
            // The below fields should be populated by Lead Custom Field Mappings (see Object Manager -> Fields -> Map Lead Fields)
            System.assertEquals(created_opp.UTM_Source__c, l.UTM_Source__c);
            System.assertEquals(created_opp.Became_Sales_Ready__c, l.Became_Sales_Ready_Date__c);
            Test.startTest();    
            Practice_Profile__c practice_profile = [Select Id, Name from Practice_Profile__c where Account__c =: created_opp.Account.Id];
            System.assertEquals(practice_profile.Name, created_opp.Account.Name);
            System.assertEquals(practice_profile.Id, created_opp.Account.Practice_Profile__c);
            
            System.AssertEquals('TestJourneyBasicLead', created_opp.OpportunityContactRoles[0].Contact.FirstName, 'Created Opportunity Contact Roles Incorrect');
            // System.AssertEquals('Onboarding', created_opp.Account.Owner.UserRole.Name, 'Created Account not assigned to an Onboarding User');
            
            // Simulate a change in Opportunity owner
            
            System.assertEquals(created_opp.OwnerId, sales.Id);
            created_opp.OwnerId = backupSales.Id;
            update created_opp;
            Contact relatedContact = [select Id, OwnerId from Contact where Id =: created_opp.Contact__r.Id];
            Account relatedAccount = [select Id, Sales_Rep__c from Account where Id =: created_opp.AccountId];
            System.assertEquals(created_opp.OwnerId, backupSales.Id);
            System.assertEquals(relatedContact.OwnerId, backupSales.Id);
            //System.assertEquals(relatedAccount.Sales_Rep__c, created_opp.OwnerId);
            
            
            // 3. Simulate demo missed
            // TODO: Simulate a demo call missed (should move to "Demo Missed")
            
            e.No_Show_CP__c = true;
            update e;
            
            created_opp = fetchOpportunityByAccountName(created_opp.Name);
            
            e = [Select Id, Subject, WhoId from Event where Id=:e.Id ];
            System.assert(e.Subject.contains('(NO SHOW)'));
            System.assertEquals(created_opp.StageName, SalesStages.DEMO_MISSED); 
            Pod__c pod = new Pod__c();
            pod.Name = 'Pod 1';
            pod.CX_Lead__c = sales.Id;
            pod.AM__c = sales.Id;
            insert pod;
            Account created_account = fetchAccountName('TestJourneyBasicLead ABC Dental');
            created_account.Pod__c = pod.id;
            created_account.AssignedAccountManager__c = sales.id;
            created_account.Assigned_Pod__c = 'Pod 1';
            update created_account;
            
            // 4. Simulate PandaDoc Contract Sent
            created_opp.StageName = 'Contract Sent';
            update created_opp;
            System.debug('Account Id is'+ created_opp.Accountid+'Pod is = '+created_opp.Account.pod__c+'Assidned Manager = '+ created_opp.Account.AssignedAccountManager__c);
            System.AssertNotEquals(null, created_opp.Contact__r.Phone, 'Contract Opportunity Contact does not have the right Contact__r');
            
            // 5. Simulate PandaDoc Contract Signed
            created_opp.StageName = 'Contract Signed';
            created_opp.Synthetic_Training_Date__c = System.today();
            created_opp.Current_Prep_Style__c = 'Chamfer';
            created_opp.Current_retraction_method__c = 'Laser';
            created_opp.Digital_charting_solution__c = 'Yes, using a digital solution for charting.';
            created_opp.Fulfillment_Data_Verified__c = True;
            created_opp.Scanner_Shipment_Address_Check__c = 'Same as Address Listed on the Account';
            created_opp.Current_Wi_Fi_Capability__c = 'Other';
            created_opp.Credit_Card_Entered_in_Portal__c = true;
            created_opp.Key_Buying_Reason_s__c = 'Price';
            created_opp.Notes_for_Training_Account_Management__c  = 'Test';
            created_opp.Number_of_Scanners_For_This_Deal__c = 2;
            created_opp.Number_of_Training_Attendees__c = 1;
            update created_opp;
            Test.stopTest();
        }   
    }
    /*
    @isTest static void TestJourneyBasicLeadQueue() {
        // Setup test data
        
        
        
        //Run main test
        Test.startTest();
        // Non-setup data must be initialized here
        TestDataFactory.createTestHookScaffolding();
        
        
        Opportunity created_opp = fetchOpportunityByAccountName('TestJourneyBasicLead ABC Dental');
        
        // Simulate meeting booked, part 2
        Event e = [Select id from event where subject = 'Dandy Labs Intro Call // TestJourneyBasicLead Hanover'];
        
        EventRelation er = new EventRelation(EventId = e.Id, 
                                             RelationId = created_opp.Contact__c);
        //insert er;
        
        //System.AssertEquals(Constants.SALESFORCE_ADMIN_ID, created_opp.Owner.Id, 'Created Opportunity not owned by SF Admin');
        
    }
    */
    @isTest static void TestJourneyBasicLead1() {
        // Setup test data
        
        Test.startTest();
        
        Opportunity signed_opp = fetchOpportunityByAccountName('TestJourneyBasicLead ABC Dental');
        System.AssertEquals('TestJourneyBasicLead', signed_opp.Contact__r.FirstName, 'Signed Opportunity does not have the right Contact__r');
        
        System.AssertEquals(System.today(), signed_opp.Account.Contract_Signed_Date__c, 'Contract Signed Opportunity Incorrect Contract Signed Date');
        System.Assert(signed_opp.Account.Onboarding_Opportunity__c != null, 'Onboarding Opportunity not created after Contract Signed');
        System.AssertEquals(signed_opp.Account.Status__c, 'Training', 'Account status not Training');
        
        Opportunity onboarding_opp = fetchOpportunityByID(signed_opp.Account.Onboarding_Opportunity__c);
        
        System.AssertNotEquals(null, onboarding_opp, 'Onboarding Opportunity was not created');
        System.AssertEquals(OnboardingStages.OPS_CALL_NEEDED, onboarding_opp.StageName, 'Onboarding Opportunity not created with Ops Call Needed Stage');
        System.AssertEquals(onboarding_opp.OwnerId, signed_opp.Account.OwnerId, 'Onboarding Opportunity not owned by Onboarder');
        
        // 6. Simulate Ops Call Booked
        Event kickoff_call_event = new Event(
            Subject = 'Dandy Kickoff Call // ' + onboarding_opp.Name,
            WhatId = signed_opp.Id, // This is wrong on purpose, simulating a CP mistake
            StartDateTime = Date.today(),
            EndDateTime = Date.today(),
            OwnerId = onboarding_opp.Owner.Id,
            Meeting_Type_CP__c = 'Kickoff Call'
        );
        insert kickoff_call_event;
        
        onboarding_opp = fetchOpportunityByID(signed_opp.Account.Onboarding_Opportunity__c);
        //System.AssertEquals(OnboardingStages.OPS_CALL_BOOKED, onboarding_opp.StageName, 'Onboarding Opportunity not set to Ops Call Booked when kickoff call scheduled');
        
        kickoff_call_event = [select Id, WhatId, RecordTypeId from Event where Id=:kickoff_call_event.Id];
        //System.AssertEquals(kickoff_call_event.WhatId, onboarding_opp.Id); // Should be corrected by our trigger logic
        System.AssertEquals(kickoff_call_event.RecordTypeId, EventConstants.KICKOFF_CALL_RECORD_TYPE_ID);
        
         Datetime fiveDaysOut = Datetime.now().addDays(5);
         Account a = signed_opp.Account;
        a.OwnerId = Constants.TEST_ACCOUNT_OWNER_ID;
        a.Number_of_Payment_Methods_on_File__c=24;
        a.ShippingStreet='Dalal';
        a.ShippingCity='City';
        a.ShippingState='State';
        a.ShippingPostalCode='12345';
        a.ShippingCountry='Country';
        a.phone='12346';
        update a; 
        Event training_event = new Event(
            Subject = 'Dandy Labs Training // ' + onboarding_opp.Name,
            WhatId = signed_opp.Id, // This is wrong on purpose - sometimes chilipiper gets it wrong and we should be able to handle anyway
            ActivityDate=null, // Our Chilipiper events come in with a null ActivityDate field (not intentional, just appears to be how CP sends the event info)
            ActivityDateTime = fiveDaysOut, // Our afterInsert hook relies on ActivityDate, which should be populated after creation if ActivityDateTime is set
            StartDateTime = fiveDaysOut,
            EndDateTime = fiveDaysOut.addMinutes(300),
            OwnerId = Constants.TEST_TRAINER_ID,
            Meeting_Type_CP__c = 'Dandy Labs Training'
        );
        insert training_event;
       
        signed_opp = fetchOpportunityByID(signed_opp.Id);
        //System.AssertEquals(Stages.CLOSED_WON, signed_opp.StageName, 'Signed Opportunity not marked Closed Won after Ops Call Held');
        
        
        Test.stopTest();        
        
    }
    
    @isTest static void TestJourneyBasicLead2() {
        // Setup test data
        
        Test.startTest();
        
        Opportunity signed_opp = fetchOpportunityByAccountName('TestJourneyBasicLead ABC Dental');
        
        Opportunity onboarding_opp = fetchOpportunityByID(signed_opp.Account.Onboarding_Opportunity__c);
         Datetime fiveDaysOut = Datetime.now().addDays(5);
        Event training_event = new Event(
            Subject = 'Dandy Labs Training // ' + onboarding_opp.Name,
            WhatId = signed_opp.Id, // This is wrong on purpose - sometimes chilipiper gets it wrong and we should be able to handle anyway
            ActivityDate=null, // Our Chilipiper events come in with a null ActivityDate field (not intentional, just appears to be how CP sends the event info)
            ActivityDateTime = fiveDaysOut, // Our afterInsert hook relies on ActivityDate, which should be populated after creation if ActivityDateTime is set
            StartDateTime = fiveDaysOut,
            EndDateTime = fiveDaysOut.addMinutes(300),
            OwnerId = Constants.TEST_TRAINER_ID,
            Meeting_Type_CP__c = 'Dandy Labs Training'
        );
        insert training_event;
        
       
        
        training_event = [select Id, WhatId, RecordTypeId, ActivityDateTime, ActivityDate from Event where Id=:training_event.Id];
        //System.AssertEquals(training_event.WhatId, onboarding_opp.Id); // Should correct the whatId to be the onboarding opp
        System.AssertEquals(training_event.RecordTypeId, EventConstants.TRAINING_EVENT_RECORD_TYPE_ID);
        System.AssertEquals(training_event.ActivityDate, Date.today().addDays(5));
        
        // There should be two "Set up scanner" tasks created, linked to the onboarding opp, assigned to the owner of the training event
        List<Task> relatedReminderTasks = [Select Id, Subject, OwnerId, ActivityDate from Task where WhatId =: onboarding_opp.Id and Subject like '%Set Up Scanner%'];
        
        //System.assertEquals(relatedReminderTasks.size(), 2);
        for (Task t : relatedReminderTasks) {
            System.assertEquals(t.OwnerId, Constants.TEST_TRAINER_ID);
            if (t.Subject.contains('3 Days Out')) {
                System.assertEquals(t.ActivityDate, Date.today().addDays(2));
            }
            if (t.Subject.contains('1 Day Out')) {
                System.assertEquals(t.ActivityDate, Date.today().addDays(4));
            }
        }
        
        // 8. Simulate Needs Setup
        // TODO: this line is the only reason we need `SeeAllData=true`, which is not ideal
        // We need to create the relevant Pricebooks in `createTestHookScaffolding` so we can remove this
        training_event.Training_Status__c = 'Confirmed';
        update training_event;
        
        
        //System.assertEquals(onboarding_opp.StageName, OnboardingStages.NEEDS_SETUP, 'Opp not moved to needs setup after training confirmed.');
       
        // 9. Simulate Materials Shipped
       // onboarding_opp.StageName = OnboardingStages.MATERIALS_SHIPPED;
        //update onboarding_opp;
        
        // 10. Simulate Setup Complete
       // onboarding_opp.StageName = OnboardingStages.SETUP_COMPLETE;
        //update onboarding_opp;
        
        // 11. Simulate Training Pending
        //onboarding_opp.StageName = OnboardingStages.TRAINING_PENDING;
        //update onboarding_opp;
        
        // 12. Simulate Closed Won
         Account a = signed_opp.Account;
        a.OwnerId = Constants.TEST_ACCOUNT_OWNER_ID;
        a.Number_of_Payment_Methods_on_File__c=24;
        a.ShippingStreet='Dalal';
        a.ShippingCity='City';
        a.ShippingState='State';
        a.ShippingPostalCode='12345';
        a.ShippingCountry='Country';
        a.phone='12346';
        update a;
        
        onboarding_opp.StageName = Stages.CLOSED_WON;
        onboarding_opp.Credit_Card_Entered_in_Portal__c = true;
        onboarding_opp.Key_Buying_Reason_s__c = 'Price';
        onboarding_opp.Notes_for_Training_Account_Management__c  = 'Test';
        onboarding_opp.Number_of_Scanners_For_This_Deal__c = 2;
        onboarding_opp.Number_of_Training_Attendees__c = 1;
        onboarding_opp.Synthetic_Training_Date__c = system.today();
        onboarding_opp.Current_Prep_Style__c = 'Chamfer';
        onboarding_opp.Current_retraction_method__c = 'Laser';
        onboarding_opp.Digital_charting_solution__c = 'Yes, using a digital solution for charting.';
        onboarding_opp.Fulfillment_Data_Verified__c = True;
        onboarding_opp.Current_Wi_Fi_Capability__c = 'Other';
        onboarding_opp.Scanner_Shipment_Address_Check__c = 'Same as Address Listed on the Account';
        update onboarding_opp;
        
        onboarding_opp = fetchOpportunityByID(onboarding_opp.Id);
        Test.stopTest();
        
        
    }
}