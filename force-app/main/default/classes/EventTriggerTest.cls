@isTest
public class EventTriggerTest{
    @testSetup
    static void testData(){
        Account acc = new Account(name = 'test Account');
        insert acc;
        
        Opportunity opp = new Opportunity(StageName = 'Closed Won', CloseDate = System.today(), AccountId = acc.Id, Name = 'Test Opp');
        insert opp;
    }
    
    @isTest
    static void testMethod1(){
        Opportunity opp = [Select Id from Opportunity Limit 1];
        
        Event e = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60
        );
        insert e;
    }
    
    @isTest
    static void testMethod2(){
    
        Opportunity opp = [Select Id from Opportunity Limit 1];
        
        Event e = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60,
            Meeting_Type_CP__C = EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP
        );
        insert e;
    }
    
    @isTest
    static void testMethod3(){
    
        Opportunity opp = [Select Id from Opportunity Limit 1];
        
        Event e = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60,
            Meeting_Type_CP__C = EventConstants.KICKOFF_CALL_EVENT_TYPE_CP
        );
        insert e;
    }
    
    @isTest
    static void testMethod4(){
        
        Opportunity opp = [Select Id from Opportunity Limit 1];
        
        Event e = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60,
            Meeting_Type_CP__C = EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP
        );
        insert e;
        
        Old_Process_Settings__c oldProcess = Old_Process_Settings__c.getOrgDefaults();
        oldProcess.Is_Old_Process_Active__c = true;
        upsert oldProcess;
        
        e.Meeting_Type_CP__C = EventConstants.KICKOFF_CALL_EVENT_TYPE_CP;
        update e;
    }
    
    @isTest
    static void testMethod5(){
    
        Opportunity opp = [Select Id from Opportunity Limit 1];
        
        Event e = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60,
            Meeting_Type_CP__C = EventConstants.KICKOFF_CALL_EVENT_TYPE_CP
        );
        insert e;
        
        Old_Process_Settings__c oldProcess = Old_Process_Settings__c.getOrgDefaults();
        oldProcess.Is_Old_Process_Active__c = true;
        upsert oldProcess;
        
        e.Meeting_Type_CP__C = EventConstants.DISCOVERY_CALL_EVENT_TYPE_CP;
        update e;
    }
    
    @isTest
    static void testMethod6(){
    
        Opportunity opp = [Select Id from Opportunity Limit 1];
        
        Event e = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60,
            Meeting_Type_CP__C = EventConstants.KICKOFF_CALL_EVENT_TYPE_CP
        );
        insert e;
        
        Old_Process_Settings__c oldProcess = Old_Process_Settings__c.getOrgDefaults();
        oldProcess.Is_Old_Process_Active__c = true;
        upsert oldProcess;
        
        Delete e;
    }
    
    @isTest
    static void testMethod7(){
    
        Opportunity opp = [Select Id from Opportunity Limit 1];
        
        Event e1 = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60,
            Meeting_Type_CP__C = 'Follow Up Meeting'
        );
        insert e1;
    }
    
    @isTest
    static void testMethod8(){
    
        Opportunity opp = [Select Id from Opportunity Limit 1];
        
        Event e = new Event(
            WhatId = opp.Id,
            ActivityDateTime= System.now(),
            DurationInMinutes = 60,
            Meeting_Type_CP__C = EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP
        );
        insert e;
        
        Old_Process_Settings__c oldProcess = Old_Process_Settings__c.getOrgDefaults();
        oldProcess.Is_Old_Process_Active__c = true;
        upsert oldProcess;
        
        Delete e;
        
        
    }
}