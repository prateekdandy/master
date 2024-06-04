public class EventAutomations {

    // Overloaded method for transitioning to a new stage
    public static void TransitionRelatedOppStage(Id oppId, String oldStage, String newStage) {
        TransitionRelatedOppStage(oppId, new List<String>{oldStage}, newStage);
    }

    public static void TransitionRelatedOppStage(Id oppId, List<String> oldStages, String newStage) {
        Opportunity relatedOpp = [select Id, StageName from Opportunity where Id=:oppId];
        if (oldStages.contains(relatedOpp.StageName)) {
            relatedOpp.StageName = newStage;
            update relatedOpp;
        }
    }

    public static Opportunity getOnboardingOpp(Event e) {
        // ChiliPiper automatically links kickoff/training events to the opportunity with the nearest close date (see https://help.chilipiper.com/hc/en-us/articles/360053021774)
        // This isn't always what we want, so make sure this is linked to the Onboarding Opp
       Opportunity accountId = [select Account.Id from Opportunity where Id =: e.WhatId];
       Opportunity[] onboardingOpp = [select Id, OwnerId from Opportunity where Account.Id =: accountId.Account.Id and RecordTypeId =: Constants.SALES_OPP_RECORD_TYPE_ID];
       return onboardingOpp[0];
   }

    public static void BeforeDiscoveryCallNoShow(Event e) {
        // Update Subject to reflect the no-show
        // If this is called on an incoming trigger, should not explicitly call "update e"
        e.Subject = e.Subject + ' (NO SHOW)';


        // Discovery Calls are a special setup, linked to a contact, which is linked to an account, which is linked to an opportunity
        List<Contact> relatedContacts = [select Id, AccountId from Contact where Id=:e.WhoId];
        if (relatedContacts.size() == 0) {
            throw new DandyException('Cannot perform update on a Discovery Call Event that is not linked to a Contact');
        }
        List<Opportunity> latestOpp = [select id, Name from Opportunity where AccountId =: relatedContacts[0].AccountId order by LastModifiedDate DESC Limit 1];
        if (latestOpp.size() == 0) {
            throw new DandyException('Cannot perform update on a Discovery Call Event that is not linked to a valid Opportunity');
        }

        //TransitionRelatedOppStage(latestOpp[0].Id, SalesStages.DISCOVERY_CALL_SCHEDULED, SalesStages.DEMO_MISSED);
        TransitionRelatedOppStage(latestOpp[0].Id, SalesStages.DISCOVERY_VALUE_CONNECTION, SalesStages.DEMO_MISSED);
    }

    public static void BeforeKickoffEventBooked(Event e) {
        Opportunity onboardingOpp = getOnboardingOpp(e);
        e.WhatId = onboardingOpp.Id;
 
        // Update RecordTypeID to make this a Kickoff Event RecordTypeID
        // Since this is called on an incoming trigger, do not explicitly need to call "update e"
        e.RecordTypeId = EventConstants.KICKOFF_CALL_RECORD_TYPE_ID;

        TransitionRelatedOppStage(e.WhatId, OnboardingStages.OPS_CALL_NEEDED, OnboardingStages.OPS_CALL_BOOKED);
    }

    public static void AfterKickoffEventCanceled(Event e) {
        TransitionRelatedOppStage(e.WhatId, OnboardingStages.OPS_CALL_BOOKED, OnboardingStages.OPS_CALL_NEEDED);
    }

}