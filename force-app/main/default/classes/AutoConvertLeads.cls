Public class AutoConvertLeads 
{     @InvocableMethod   
    public static void LeadAssign(List<Lead> Leads)  
    {         
        Apex_Setting__c apexSettings = Apex_Setting__c.getOrgDefaults();
        if(!apexSettings.Disable_Lead_Auto_Conversion__c || Test.isRunningTest()){
            LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1]; 
            List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();    
            for(Lead currentlead: Leads){
                Database.LeadConvert Leadconvert = new Database.LeadConvert();    
                Leadconvert.setLeadId(currentlead.Id);                             
                Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel);
    
                // If the lead is ownedby a queue, we must specify the owner of the created objects
                // https://salesforce.stackexchange.com/questions/193594/how-do-i-determine-if-the-case-owner-is-a-user-or-queue-in-process-builder
                if (String.valueOf(currentlead.OwnerId).startsWith('00G')) {
                    // Distribution engine will auto-assign SF Admin-owned opps
                    Leadconvert.setOwnerId(Constants.SALESFORCE_ADMIN_ID);
                }
                if(apexSettings.Disable_Opportunity_Creation__c){
                    LeadConvert.setDoNotCreateOpportunity(true);
                } 
                MassLeadconvert.add(Leadconvert);
            }
            if (!MassLeadconvert.isEmpty())
            {
                // https://salesforce.stackexchange.com/questions/197424/bypass-duplicate-when-converting-a-lead
                Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true;
                List<Database.LeadConvertResult> lcr = Database.convertLead(MassLeadconvert, dml);
                for (Database.LeadConvertResult l : lcr) {
                    // FWIW I have found the below to be helpful when trying to inspect errors during a failed JourneyBasicLead run
                    // throw new DandyException(JSON.serialize(l.getErrors()));
    				//   System.debug('Lead result '+l);
                    // Ensure all created practice accounts are initially owned by SF Admin
                    // So Distribution Engine can pick it up and transfer it to an AM
                    System.debug(l.getErrors());
                    String accountId = l.getAccountId();
                    String contactId = l.getContactId();
                    Account a = [Select Id, Name, OwnerId, RecordTypeId from Account where Id =: accountId];
                    
                    if (a.RecordTypeId == Constants.DENTAL_PRACTICE_ACCOUNT_RECORD_TYPE_ID) {
                        a.OwnerId = Constants.SALESFORCE_ADMIN_ID;
                        a.Status__c = 'New';
                    }
                    update a;
    
                    // This autoconversion only occurs when the prospect books a meeting themselves
                    // For reporting purposes, want to make sure that nobody is getting ownership credit for working this lead if they book on their own
                    Lead existingLead = [Select Id, OwnerId from Lead where Id =: l.getLeadId()];
                    if (existingLead.OwnerId != Constants.SALESFORCE_ADMIN_ID) {
                        existingLead.OwnerId = Constants.SALESFORCE_ADMIN_ID;
                        update existingLead;
                    }
                    if(!apexSettings.Disable_Opportunity_Creation__c){
                        String opportunityId = l.getOpportunityId();
                        // Set Contact__c property so PandaDoc works properly
                        Opportunity o = [Select Id from Opportunity where id = :opportunityId];
                        o.Contact__c = contactId;
                        // Set close date to 7 days from today
                        o.CloseDate = Date.today().addDays(7);
                        update o;
                    }
                }
            }
        }
    }
}