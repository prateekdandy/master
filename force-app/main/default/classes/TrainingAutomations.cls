public class TrainingAutomations {

    // Before training event booked, ensure that it has the correct fields set
    public static void BeforeTrainingEventBooked(Event e) {
        Opportunity onboardingOpp = EventAutomations.getOnboardingOpp(e);
        e.WhatId = onboardingOpp.Id;

        // Update RecordTypeID to make this a Training Event RecordTypeID
        // If this is called on an incoming trigger, should not explicitly call "update e"
        e.RecordTypeId = EventConstants.TRAINING_EVENT_RECORD_TYPE_ID;
    }

    public static void assignAccountLevelTrainer(Event e) {
        Opportunity accountId = [select Account.Id from Opportunity where Id =: e.WhatId];
        Account relatedAccount = [select Id from Account where Id =: accountId.Account.Id];

        relatedAccount.Trainer__c = e.OwnerId;
        update relatedAccount;
    }

    // After training event booked, update related objects appropriately
    public static void AfterTrainingEventBooked(Event e) {
        Opportunity onboardingOpp = EventAutomations.getOnboardingOpp(e);
        Id opportunityId = onboardingOpp.Id;

        // TODO: Mark the "Trainer" property of the Onboarding Opportunity to the assignee of the event
        // Once we add "Trainer" as an explicit field. Until then, use Opportunity Owner
        onboardingOpp.OwnerId = e.OwnerId;
        update onboardingOpp;

        TrainingAutomations.assignAccountLevelTrainer(e);

        System.debug('Logging event' + e);

        // CRITICAL these are separate so the opp passes through "Ops Call Held" and triggers the "Closed Won" stage on the Sales Opp
        EventAutomations.TransitionRelatedOppStage(opportunityId, OnboardingStages.OPS_CALL_BOOKED, OnboardingStages.OPS_CALL_HELD);
        EventAutomations.TransitionRelatedOppStage(opportunityId, OnboardingStages.OPS_CALL_HELD, OnboardingStages.TRAINING_SCHEDULED);

        // Create Trainers' tasks
        Task callDoctorThreeDays = new Task(
            ActivityDate = e.ActivityDate.addDays(-3),
            OwnerId = e.OwnerId,
            Priority = 'High',
            Status = 'Open',
            Subject = 'Call Doctor // Set Up Scanner (3 Days Out)',
            WhatId = opportunityId // Want this related to the opportunity
        );

        Task callDoctorOneDay = new Task(
            ActivityDate = e.ActivityDate.addDays(-1),
            OwnerId = e.OwnerId,
            Priority = 'High',
            Status = 'Open',
            Subject = 'Call Doctor // Set Up Scanner (1 Day Out)',
            WhatId = opportunityId // Want this related to the opportunity
        );

        insert callDoctorThreeDays;
        insert callDoctorOneDay;
    }

    public static void AfterTrainingEventCanceled(Event e) {
        EventAutomations.TransitionRelatedOppStage(e.WhatId, OnboardingStages.TRAINING_SCHEDULED, OnboardingStages.OPS_CALL_HELD);
    }
}