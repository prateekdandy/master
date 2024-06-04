// Restricting the permitted stage transitions makes reasoning about our users' Salesforce behavior SIGNIFICANTLY easier
public class AllowedStageTransitions  {

    public static void OpportunityCondition(Opportunity opp, Opportunity old_opp) {
        if (opp.StageName == old_opp.StageName) {
            return;
        }
        if (
            opp.RecordTypeId != Constants.SALES_OPP_RECORD_TYPE_ID
            
        ) {
            return;
        }
        if (old_opp.StageName == null || opp.StageName == Stages.CLOSED_LOST || old_opp.StageName == Stages.CLOSED_LOST) {
            return;
        }
        Map<String, List<String>> m = new Map<String, List<String>>();

        // Sales Pipeline
        m.put(SalesStages.DISCOVERY_CALL_SCHEDULED, new List<String> {SalesStages.DEMO_MISSED, SalesStages.CONFIRMING, SalesStages.CONTRACT_SENT});
        m.put(SalesStages.DEMO_MISSED, new List<String> {SalesStages.DISCOVERY_CALL_SCHEDULED, SalesStages.CONFIRMING, SalesStages.CONTRACT_SENT});
        m.put(SalesStages.CONFIRMING, new List<String>{SalesStages.CONTRACT_SENT, SalesStages.CONTRACT_SIGNED});
        m.put(SalesStages.CONTRACT_SENT, new List<String>{SalesStages.CONFIRMING, SalesStages.CONTRACT_SIGNED});
        m.put(SalesStages.CONTRACT_SIGNED, new List<String>{Stages.CLOSED_WON});
        
        Old_Process_Settings__c oldProcess = Old_Process_Settings__c.getOrgDefaults();
        if(oldProcess != null && oldProcess.Is_Old_Process_Active__c){
            // Onboarding Pipeline
            m.put(OnboardingStages.OPS_CALL_NEEDED, new List<String>{ OnboardingStages.OPS_CALL_BOOKED, OnboardingStages.OPS_CALL_HELD });
            m.put(OnboardingStages.OPS_CALL_BOOKED, new List<String>{ OnboardingStages.OPS_CALL_NEEDED, OnboardingStages.OPS_CALL_HELD });
            m.put(OnboardingStages.OPS_CALL_HELD, new List<String>{ OnboardingStages.TRAINING_SCHEDULED });
            m.put(OnboardingStages.TRAINING_SCHEDULED, new List<String>{ OnboardingStages.OPS_CALL_HELD, OnboardingStages.NEEDS_SETUP, Stages.CLOSED_WON }); // Can move backwards iff the scheduled meeting has been cancelled
            m.put(OnboardingStages.NEEDS_SETUP, new List<String>{ OnboardingStages.MATERIALS_SHIPPED, Stages.CLOSED_WON });
            m.put(OnboardingStages.MATERIALS_SHIPPED, new List<String>{ OnboardingStages.SETUP_COMPLETE, Stages.CLOSED_WON });
            m.put(OnboardingStages.SETUP_COMPLETE, new List<String>{ OnboardingStages.TRAINING_PENDING, Stages.CLOSED_WON });
            m.put(OnboardingStages.TRAINING_PENDING, new List<String>{ Stages.CLOSED_WON });
        }
        if (!m.containsKey(old_opp.StageName)) {
            opp.addError('The current stage (' + old_opp.StageName + ') ' + 
            'doesnt actually exist. Ping a developer for help :/');
        }

        if (!m.get(old_opp.StageName).contains(opp.StageName)) {
            opp.addError('Please do not skip opportunity stages' + 
            '(cant transition from ' + old_opp.StageName + ' to ' + opp.StageName + ')');
        }
    }
}