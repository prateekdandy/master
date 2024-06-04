public class LeadAutomations  {

    public static void updateRelatedLeadCounts(Lead l) {
        List<Task> relatedCalls = [Select Id from Task where WhoId =: l.Id and Type = 'Call'];
        List<Task> relatedEmails = [Select Id from Task where WhoId =: l.Id and Type = 'Email'];

        // Gets around some read-only enforcement during "after" triggers
        Lead toUpdate = [Select Id from Lead where Id =: l.Id];
        toUpdate.Number_of_Calls__c = relatedCalls.size();
        toUpdate.Number_of_Emails__c = relatedEmails.size();

        update toUpdate;
    }

}