trigger LeadTrigger on Lead (after update)  {
    List<Lead> ls = Trigger.new;
    for (Lead new_lead : ls) {
        Lead old_lead = Trigger.oldMap.get(new_lead.Id);
        if (new_lead.Meeting_Type_CP__c == EventConstants.DISCOVERY_CALL_EVENT_TYPE_CP && old_lead.Meeting_Type_CP__c != EventConstants.DISCOVERY_CALL_EVENT_TYPE_CP) {
            AutoConvertLeads.LeadAssign(new List<Lead> {new_lead});
        }
    }
}