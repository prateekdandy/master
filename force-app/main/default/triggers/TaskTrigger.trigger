trigger TaskTrigger on Task (after insert, after update)  {
    List<Task> ls = Trigger.new;
    for (Task new_task : ls) {
        if (new_task.Type == 'Call' || new_task.Type == 'Email') {
            List<Lead> relatedLeads = [Select Id from Lead where Id =: new_task.WhoId];
            for (Lead l : relatedLeads) {
                LeadAutomations.updateRelatedLeadCounts(l);
            }
        }
    }
}