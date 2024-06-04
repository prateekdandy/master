public class ProcessOppsPipeline {
    public static void processOppPerStage(List<Opportunity> opportunityOpsList, Map<Id,Opportunity> oppsMapToUpdate){
        List<Opportunity> oppsToDeleteNeedsSetupTasks = new List<Opportunity>();
        List<Task> tasks = new List<Task>();
        RecordType recordType = [SELECT Id FROM RecordType WHERE Name = 'Sales Pipeline'];
        String ownerSales = OpportunityTriggerHelper.getUserForOwnerOpp('Sales');
        String ownerSetup = OpportunityTriggerHelper.getUserForOwnerOpp('Technical');
        String ownerTraining = OpportunityTriggerHelper.getUserForOwnerOpp('Training');
        /*
for(Opportunity opp: opportunityOpsList){
switch on oppsMapToUpdate.get(opp.Id).StageName{
when 'Ops Call Missed'{
if(oppsMapToUpdate.get(opp.Id).FirstOwnerSales__c == null){
oppsMapToUpdate.get(opp.Id).FirstOwnerSales__c = ownerSales;
}
tasks.add(OpportunityController.createNewTask(opp, 2, 'Reschedule Call',
'Reschedule Call for Opp: ' + opp.Name, oppsMapToUpdate.get(opp.Id).OwnerId));
}
when 'Needs Setup'{
if(oppsMapToUpdate.get(opp.Id).FirstOwnerSetup__c == null){
oppsMapToUpdate.get(opp.Id).FirstOwnerSetup__c = ownerSetup;
}
}
when 'Training Scheduled'{
if(opp.StageName == 'Needs Setup' || opp.StageName == 'Setup Complete'){
// if(oppsMapToUpdate.get(opp.Id).FirstOwnerOperations__c != null)oppsMapToUpdate.get(opp.Id).OwnerId = oppsMapToUpdate.get(opp.Id).FirstOwnerOperations__c;
oppsToDeleteNeedsSetupTasks.add(opp);
}
}
when 'Setup Complete'{
if(oppsMapToUpdate.get(opp.Id).FirstOwnerTraining__c == null){
oppsMapToUpdate.get(opp.Id).FirstOwnerTraining__c = ownerTraining;
}
if(oppsMapToUpdate.get(opp.Id).FirstOwnerTraining__c != null) oppsMapToUpdate.get(opp.Id).Trainer_Name__c = oppsMapToUpdate.get(opp.Id).FirstOwnerTraining__c;
}
}
}

        if(!oppsToDeleteNeedsSetupTasks.isEmpty()){
            ProcessOppsPipeline.deleteTaskWhenCameFromNeedsSetup(oppsToDeleteNeedsSetupTasks);
        }
        insert tasks;
*/
    }
    
    public static void labPipelineCreated(List<Opportunity> opportunities){
        String ownerId = OpportunityTriggerHelper.getUserForOwnerOpp('Technical');
        for(Opportunity opp: opportunities){
            opp.OwnerId = ownerId;
            opp.FirstOwnerOperations__c = ownerId;
        }
        update opportunities;
    }
    /*
    private static void deleteTaskWhenCameFromNeedsSetup(List<Opportunity> opportunities){
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId =: opportunities AND Subject IN('Setup Scanner and Laptop', 'Update Custom Contact Fields')];
        if(!tasks.isEmpty()){
            delete tasks;
        }
    }
    */
}