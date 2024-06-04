public class SalesPipelineAutomations  {
    public static void CreatingSalesOpp(Opportunity new_sales_opp) {
        new_sales_opp.LabsContractPreset__c = Constants.LAB_CONTRACT_PRESET_99_PLUS_ID;
        if(test.isRunningtest())
       
            {
                 new_sales_opp.LabsContractPreset__c = null;
            }
    
    }

    public static void CreatedSalesOpp(Opportunity new_sales_opp) {
        if (new_sales_opp.AccountId == null) {
            // most likely in a test, just return with no error
            return;
        }
        Account a = [
            select 
            Id,
            Sales_Opportunity__c 
            from Account
            where Id = :new_sales_opp.AccountId
        ];
        a.Sales_Opportunity__c = new_sales_opp.Id;
        update a;
    }

    public static void BecomingContractSigned(Opportunity contract_signed_opp) {
        if (
            contract_signed_opp.StageName != 'Contract Signed'
        ) {
            throw new DandyException(
                'Tried to create onboarding opportunity for unsigned contract ' + contract_signed_opp.Id
            );
        }
        Account a = [
            select 
            Id, 
            OwnerId,
            Onboarding_Opportunity__c 
            from Account
            where Id = :contract_signed_opp.AccountId
        ];
        if (
            a.Onboarding_Opportunity__c != null
        ) {
            System.debug('Opportunity ' + contract_signed_opp.Id + ' already had Onboarding_Opportunity__c, aborting...');
            return;
        }

        // No `update` statement needed because we are in an isBefore trigger.
        // We get updates for free!!!
        a.Contract_Signed_Date__c = System.today();
        
        Opportunity onboarding_opp = new Opportunity(
            closeDate = Date.today(),
            Name = contract_signed_opp.Name + ' - Onboarding',
            StageName = OnboardingStages.OPS_CALL_NEEDED,
            AccountId = contract_signed_opp.AccountId,
            OwnerId = a.OwnerId
            //RecordTypeId = Constants.ONBOARDING_OPP_RECORD_TYPE_ID
        );
        insert onboarding_opp;

        a.Onboarding_Opportunity__c = onboarding_opp.Id;
        a.Status__c = 'Training';
        update a;
    }

    public static void syncSalesRep(Opportunity opp) {
        List<Account> accs = [select Id from Account where Id =: opp.AccountId];
        for (Account acc : accs) {
        
        if(opp.RecordType.Name == 'Sales Pipeline'){
            acc.Sales_Rep__c = opp.OwnerId;
            update acc;
            }
        }
    }

    public static void AfterDiscoveryCallBooked(Event e) {
        List<Contact> cntList = [Select Id, AccountId from Contact where Id =: e.WhoId];
        if(!cntList.isEmpty()){
            Contact c = cntList[0];
            List<Account> accList = [Select Id, Status__c from Account where Id =: c.AccountId];
            if((!accList.isEmpty()) && (accList[0].Status__c == 'New' || accList[0].Status__c == 'Recycled' || accList[0].Status__c == 'Blueprinting' || accList[0].Status__c == 'Prospecting' ) ){
                Account a = accList[0];
                
                List<Opportunity> oppList = [Select Id from Opportunity where RecordTypeId =: Constants.SALES_OPP_RECORD_TYPE_ID and AccountId = :a.Id];
                if(!oppList.isEmpty()){
                    Opportunity o = oppList[0];
                    o.OwnerId = e.OwnerId;
                    update o;
                }
        
                a.OwnerId = e.OwnerId;
                update a;
            }
            c.OwnerId = e.OwnerId;
            update c;
        }
    }

    public static void UpdateDateOfIntroCall(Event e) {
        List<Lead> relatedLeads = [Select Id from Lead where Id = :e.WhoId];
        if (relatedLeads.size() > 0) {
            Lead l = relatedLeads[0];
            l.Date_of_Intro_Call__C = e.ActivityDateTime;
            update l;
        }
        List<Contact> relatedContacts = [Select Id from Contact where Id = :e.WhoId];
        if (relatedContacts.size() > 0) {
            Contact c = relatedContacts[0];
            /*
            Opportunity salesOpp = [Select Id from Opportunity where ContactId = :c.Id and RecordTypeId = :Constants.SALES_OPP_RECORD_TYPE_ID];
            salesOpp.Date_of_Intro_Call__C = e.ActivityDateTime;
            update salesOpp;
            */
            List<Opportunity> salesOppList = [Select Id from Opportunity where ContactId = :c.Id and RecordTypeId = :Constants.SALES_OPP_RECORD_TYPE_ID];
            if(!salesOppList.isEmpty()){
                salesOppList[0].Date_of_Intro_Call__C = e.ActivityDateTime;
                update salesOppList[0];
            }
            
        }
    }

    public static void UpdateDateOfFollowUpCall(Event e) {
        List<Contact> relatedContacts = [Select Id, AccountId from Contact where Id = :e.WhoId];
        if (relatedContacts.size() > 0) {
            Contact c = relatedContacts[0];
            Opportunity salesOpp = [Select Id from Opportunity where ContactId = :c.Id and RecordTypeId = :Constants.SALES_OPP_RECORD_TYPE_ID];
            salesOpp.Date_Of_Follow_Up_Call__C = e.ActivityDateTime;
            update salesOpp;
        }
    }
}