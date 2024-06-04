public class OpportunityTriggerHelper {
    public static void processOppPerRecordTypeAfterInsert(List<Id> oppListIdToHandle){
        List<Opportunity> opportunities = [SELECT Id, RecordType.Name, StageName, OwnerId, Contact__r.Status__c
            FROM Opportunity WHERE Id =: oppListIdToHandle];
        if(!opportunities.isEmpty()){
            List<Opportunity> oppsSalesPipeline = new List<Opportunity>();
            List<Opportunity> oppsLabsPipeline = new List<Opportunity>();
            for(Opportunity opp: opportunities){
                if(opp.RecordType.Name == 'Sales Pipeline'){
                    oppsSalesPipeline.add(opp);
                }else if(opp.RecordType.Name == 'Labs Pipeline'){
                    oppsLabsPipeline.add(opp);
                }
            }
        }
    }
    public static void processPerRecordTypeBeforeUpdate(List<Id> oppsToUpdate, Map<Id,Opportunity> oppsMapToUpdate){
        System.debug('processPerRecordTypeBeforeUpdate');
        List<Opportunity> opportunities = [SELECT Id, RecordType.Name, (Select Id, Subject, RecordType.Name, ActivityDate From Events where RecordType.Name = 'Labs Training' order by ActivityDate DESC limit 1) , Name, StageName, OwnerId, Contact__r.Status__c, Contact__r.OwnerId
            FROM Opportunity WHERE Id =: oppsToUpdate];
        if(!opportunities.isEmpty()){
            List<Opportunity> opportunityOpsList = new List<Opportunity>();
            List<Opportunity> salesOpportunities = new List<Opportunity>();
            for(Opportunity opp: opportunities){
                //if(opp.RecordType.Name == 'Ops Pipeline'){
                //  opportunityOpsList.add(opp);
                //}
                if(opp.RecordType.Name == 'Sales Pipeline') {
                    salesOpportunities.add(opp);
                }
            }
            if(!salesOpportunities.isEmpty()){
                
            }
           // if(!opportunityOpsList.isEmpty()){
           //   ProcessOppsPipeline.processOppPerStage(opportunityOpsList, oppsMapToUpdate);
           //}
        }
    }

    public static void processPerRecordTypeAfterUpdate(List<Opportunity> oppsToUpdate){
        for (Opportunity o : oppsToUpdate) {
            // If we close-loss an opportunity due to spam be sure to retroactively set the lead to rejected
            if (o.StageName == 'Closed Lost' && o.Loss_Reason__C == 'Spam') {
                List<Lead> relatedLeads = [Select Id from Lead where Id = :o.Lead_Id__C];
                for (Lead l : relatedLeads) {
                    l.Status = 'Rejected';
                }
            }
        }
    }

    public static String getUserForOwnerOpp(String userRole){
        String userSelected = '';
        Map<String, Integer> mapUsers = new Map<String, Integer>();
        List<User> usersPipeline = [SELECT Id FROM User WHERE UserRole.Name =: userRole AND IsActive = TRUE];
        if(!usersPipeline.isEmpty()){
            for(User user: usersPipeline){
                mapUsers.put(user.Id, 0);
            }
            List<Opportunity> opps = [SELECT Id, OwnerId FROM Opportunity WHERE OwnerId =: usersPipeline AND CreatedDate >: System.today().addDays(-7)];
            if(!opps.isEmpty()){
                for(Opportunity opp: opps){
                    Integer oppInvolved = mapUsers.get(opp.OwnerId);
                    mapUsers.put(opp.OwnerId, oppInvolved + 1);
                }
                if(!mapUsers.isEmpty()){
                    Integer userConcurrency = 0;
                    for(String ownerId: mapUsers.keySet()){
                        if((userConcurrency == 0 && userSelected.isWhitespace()) || mapUsers.get(ownerId) < userConcurrency){
                            userConcurrency = mapUsers.get(ownerId);
                            userSelected = ownerId;
                        }
                    }
                }
            }else{
                userSelected = usersPipeline[0].Id;
            }
        }
        return userSelected;
    }

    public static void syncContactOwner(Opportunity opp) {
        List<Contact> relatedContacts = [select Id, OwnerId from Contact where Id =: opp.Contact__c];
        if (relatedContacts.size() > 0) {
            Contact related = relatedContacts[0];
            related.OwnerId = opp.OwnerId;
            update related;
        }
    }
    public static void handleOpportunityInsert(List<Opportunity> newOpportunities) {
        Set<Id> opportunityIds = new Set<Id>();
        for(Opportunity opp : newOpportunities) {
            opportunityIds.add(opp.Id);
        }
        
        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();
        
        // Retrieve Price Book and its associated Products
        Map<Id, List<PricebookEntry>> priceBookIdToProductsMap = new Map<Id, List<PricebookEntry>>();
        for(Opportunity opp : [SELECT Id, Pricebook2Id FROM Opportunity WHERE Id IN :opportunityIds]) {
            List<PricebookEntry> priceBookProducts = [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :opp.Pricebook2Id];
            priceBookIdToProductsMap.put(opp.Id, priceBookProducts);
        }
        
        // Create Opportunity Line Items for each Opportunity
        for(Opportunity opp : newOpportunities) {
            List<PricebookEntry> priceBookProducts = priceBookIdToProductsMap.get(opp.Id);
            if(priceBookProducts != null) {
                for(PricebookEntry pbEntry : priceBookProducts) {
                    OpportunityLineItem oli = new OpportunityLineItem();
                    oli.OpportunityId = opp.Id;
                    oli.PricebookEntryId = pbEntry.Id;
                    oli.Quantity = 1; // Set quantity as needed
                    oli.UnitPrice = pbEntry.UnitPrice;
                    opportunityLineItems.add(oli);
                }
            }
        }
        
        // Insert Opportunity Line Items
        if(!opportunityLineItems.isEmpty()) {
            insert opportunityLineItems;
        }
    }
}