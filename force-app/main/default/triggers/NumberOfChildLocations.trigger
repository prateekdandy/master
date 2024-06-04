trigger NumberOfChildLocations on Account (before insert, before update, before delete,after insert, after update) {
    
    if(trigger.isInsert && trigger.isAfter){
        ChildCountHandler.updateAccountCount(trigger.new);
    }
    if(trigger.isUpdate && trigger.isAfter){
        ChildCountHandler.updateAccountCountonUpdate(trigger.new,trigger.oldMap);
    } 

}