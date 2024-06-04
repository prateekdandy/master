trigger EventTrigger on Event (before insert, after insert, before update, after update, after delete)  {
    Old_Process_Settings__c oldProcess = Old_Process_Settings__c.getOrgDefaults();
    if (Trigger.isInsert) {
        List<Event> es = Trigger.new;
        if (Trigger.isBefore) {
            for (Event e : es) {
                
                if (e.Meeting_Type_CP__C == EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP) {
                    if(oldProcess != null && oldProcess.Is_Old_Process_Active__c){
                        TrainingAutomations.BeforeTrainingEventBooked(e);
                    }
                }
                if (e.Meeting_Type_CP__C == EventConstants.KICKOFF_CALL_EVENT_TYPE_CP) {
                    if(oldProcess != null && oldProcess.Is_Old_Process_Active__c){
                        EventAutomations.BeforeKickoffEventBooked(e);
                    }
                }
            }
        }

        if (Trigger.isAfter) {
            for (Event e : es) {
                if(oldProcess != null && oldProcess.Is_Old_Process_Active__c){
                    if (e.Meeting_Type_CP__C == EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP) {
                        TrainingAutomations.AfterTrainingEventBooked(e);
                    }
                }
                if (e.Meeting_Type_CP__C == EventConstants.DISCOVERY_CALL_EVENT_TYPE_CP) {
                    SalesPipelineAutomations.AfterDiscoveryCallBooked(e);
                }
                if (e.Meeting_Type_CP__C == EventConstants.DISCOVERY_CALL_EVENT_TYPE_CP || e.Meeting_Type_CP__C == 'BDR Meeting Type' || e.Meeting_Type_CP__C == 'My Meeting') {
                    SalesPipelineAutomations.UpdateDateOfIntroCall(e);
                }
                if (e.Meeting_Type_CP__C == 'Follow Up Meeting') {
                    SalesPipelineAutomations.UpdateDateOfFollowUpCall(e);
                }
            }
        }
    }

    if (Trigger.isUpdate) {
        List<Event> es = Trigger.new;
        Map<Id, Event> oldMap = Trigger.oldMap;
        if (Trigger.isBefore) {
            for (Event e : es) {
                Event old = oldMap.get(e.Id);
                if (!old.No_Show_CP__c && e.No_Show_CP__c) {
                    EventAutomations.BeforeDiscoveryCallNoShow(e);
                }
            }
        }

        if (Trigger.isAfter) {
            for (Event e : es) {
                Event old = oldMap.get(e.Id);
                if(oldProcess != null && oldProcess.Is_Old_Process_Active__c){
                    if (e.Meeting_Type_CP__C == EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP) {
                        // If updating an event that is a training and marking it as a training for the first time, update related fields
                        if (old.Meeting_Type_CP__C != EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP) {
                            TrainingAutomations.AfterTrainingEventBooked(e);
                        }
                        // Could also just be a reassignment
                        if (old.OwnerId != e.OwnerId) {
                            TrainingAutomations.assignAccountLevelTrainer(e);
                        }
                    }
                }
                if (e.Meeting_Type_CP__C == EventConstants.DISCOVERY_CALL_EVENT_TYPE_CP || e.Meeting_Type_CP__C == 'BDR Meeting Type' || e.Meeting_Type_CP__C == 'My Meeting') {
                    SalesPipelineAutomations.UpdateDateOfIntroCall(e);
                }
                if (e.Meeting_Type_CP__C == 'Follow Up Meeting') {
                    SalesPipelineAutomations.UpdateDateOfFollowUpCall(e);
                }
            }
        }
    }

    if (Trigger.isDelete) {
        List<Event> es = Trigger.old;
        for (Event e : es) {
            if(oldProcess != null && oldProcess.Is_Old_Process_Active__c){
                if (e.Meeting_Type_CP__C == EventConstants.DANDY_LABS_TRAINING_EVENT_TYPE_CP) {
                    TrainingAutomations.AfterTrainingEventCanceled(e);
                }
                if (e.Meeting_Type_CP__C == EventConstants.KICKOFF_CALL_EVENT_TYPE_CP) {
                    EventAutomations.AfterKickoffEventCanceled(e);
                }
            }
        }
    }
}