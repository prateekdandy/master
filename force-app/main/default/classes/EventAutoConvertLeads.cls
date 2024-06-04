Public class EventAutoConvertLeads 
{     @InvocableMethod   
    public static void LeadAssign(List<Id> LeadIds)  
    {         
        Apex_Setting__c apexSettings = Apex_Setting__c.getOrgDefaults();
       
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];    
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();    
        
        for(id currentlead: LeadIds){                
            Database.LeadConvert Leadconvert = new Database.LeadConvert();    
            Leadconvert.setLeadId(currentlead);                               
            Leadconvert.setConvertedStatus(CLeadStatus.MasterLabel); 
            /*
            if(apexSettings.Disable_Opportunity_Creation__c){
                LeadConvert.setDoNotCreateOpportunity(true);
            } 
            */
            MassLeadconvert.add(Leadconvert);    
        }                  
        if (!MassLeadconvert.isEmpty())
        {            
            List<Database.LeadConvertResult> leadConvertResult = Database.convertLead(MassLeadconvert);      
            List<Opportunity> oppList = new List<Opportunity>();
            for (Database.LeadConvertResult convertedLead : leadConvertResult) {
                if(convertedLead.getContactId() != null && convertedLead.getOpportunityId() != null){
                    oppList.add(new Opportunity(
                        Id = convertedLead.getOpportunityId(), Contact__c = convertedLead.getContactId()
                    ));
                }
            } 
            if(!oppList.isEmpty()){
                update oppList;
            }
        }  
     
    } 
}