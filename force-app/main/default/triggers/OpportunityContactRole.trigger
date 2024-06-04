trigger OpportunityContactRole on OpportunityContactRole(after insert) {

    if (!Trigger.new.isEmpty()) {
        OpportunityContactRoleHelper.processOpportunityContactRole(Trigger.new);
    }

}