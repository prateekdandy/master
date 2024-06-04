trigger OpportunityTrigger on Opportunity(before insert, after insert, before update, after update){
    System.debug('OpportunityTrigger');
    Old_Process_Settings__c oldProcess = Old_Process_Settings__c.getOrgDefaults();
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            for (Opportunity opp : Trigger.new) {
                if (opp.RecordTypeId == Constants.SALES_OPP_RECORD_TYPE_ID) {
                    SalesPipelineAutomations.CreatingSalesOpp(opp);
                }
            }
        }
        if (Trigger.isUpdate) {
            for (Opportunity opp : Trigger.new) {
                Opportunity old_opp = Trigger.oldMap.get(opp.Id);
                if(oldProcess != null && oldProcess.Old_Sales_Opportunity_Validation_Active__c){
                    AllowedStageTransitions.OpportunityCondition(opp, old_opp);
                }
                if(oldProcess != null && oldProcess.Is_Old_Process_Active__c){
                    if (opp.StageName == 'Contract Signed' && old_opp.StageName != 'Contract Signed') {
                        SalesPipelineAutomations.BecomingContractSigned(opp);
                    }
                }
            }
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            OpportunityTriggerHelper.handleOpportunityInsert(Trigger.new);
            for (Opportunity opp : Trigger.new) {
                if (opp.RecordTypeId == Constants.SALES_OPP_RECORD_TYPE_ID) {
                    SalesPipelineAutomations.CreatedSalesOpp(opp);
                    SalesPipelineAutomations.syncSalesRep(opp);
                }
            }
        }
        if (Trigger.isUpdate) {
            for (Opportunity opp : Trigger.new) {
                Opportunity old_opp = Trigger.oldMap.get(opp.Id);
                if (opp.OwnerId != old_opp.OwnerId) {
                    OpportunityTriggerHelper.syncContactOwner(opp);
                    if (opp.RecordTypeId == Constants.SALES_OPP_RECORD_TYPE_ID) {
                        SalesPipelineAutomations.syncSalesRep(opp);
                    }
                }
                //if (opp.StageName == 'Ops Call Held' && old_opp.StageName != 'Ops Call Held') {
                  //  OnboardingPipelineAutomations.BecameOpsCallHeld(opp);
                //}
               // if(oldProcess != null && oldProcess.Is_Old_Process_Active__c){
                 //   if (
                   //     opp.StageName == 'Closed Won' && 
                     //   old_opp.StageName != 'Closed Won' &&
                       // opp.RecordTypeId == Constants.ONBOARDING_OPP_RECORD_TYPE_ID
                    //) {
                      //  OnboardingPipelineAutomations.BecameClosedWon(opp);
                    //}
               // }
            }
        }
    }

    // Legacy
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            // TODO: Replicate this :)
            //String ownerId = OpportunityTriggerHelper.getUserForOwnerOpp('Onboarding');
            //for(Opportunity opp: opportunities){
            //  opp.OwnerId = ownerId;
            //  opp.FirstOwnerOperations__c = ownerId;
            //}
            //update opportunities;
        }
        if (Trigger.isUpdate) {
            List<Id> oppsToUpdate = new List<Id>();
            Map<Id, Opportunity> oppsMapToUpdate = new Map<Id, Opportunity>();
            for (Opportunity opp : Trigger.new) {
                if (Trigger.oldMap.get(opp.Id).StageName != Trigger.newMap.get(opp.Id).StageName) {
                    oppsToUpdate.add(opp.Id);
                    oppsMapToUpdate.put(opp.Id, opp);
                }
            }
            if (!oppsToUpdate.isEmpty()) {
                OpportunityTriggerHelper.processPerRecordTypeBeforeUpdate(oppsToUpdate, oppsMapToUpdate);
            }
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            List<Id> opportunities = new List<Id>();
            for (Opportunity opp : Trigger.new) {
                opportunities.add(opp.Id);
            }
            if (!opportunities.isEmpty()) {
                OpportunityTriggerHelper.processOppPerRecordTypeAfterInsert(opportunities);
            }
        }
        if (Trigger.isUpdate) {
            List<Opportunity> oppsToUpdate = new List<Opportunity>();
            for (Opportunity opp : Trigger.new) {
                if (Trigger.oldMap.get(opp.Id).StageName != Trigger.newMap.get(opp.Id).StageName) {
                    oppsToUpdate.add(opp);
                }
            }
            if (!oppsToUpdate.isEmpty()) {
                OpportunityTriggerHelper.processPerRecordTypeAfterUpdate(oppsToUpdate);
            }
        }
    }
}