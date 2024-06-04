public class FindResourcesBasedOnSkills{
    @invocableMethod(label='Get Available Resources Based on Skills')
    public static List<List<ServiceResource>> getResources(list<payloadIn> payloadList){
        if(payloadList == null || payloadList.size() <> 1) return null;
        payloadIn payLoad = payloadList[0];
        
        List<ServiceResourceSkill> assignedSkills = [Select id, ServiceResourceId from ServiceResourceSkill where SkillId =: payLoad.skillId];
        Set<Id> skilledResourcesId = new Set<Id>();
        for(ServiceResourceSkill assignedSkill : assignedSkills){
            skilledResourcesId.add(assignedSkill.ServiceResourceId);
        }
        List<ServiceResource> skilldResource = [Select Id, Name, RelatedRecordId from ServiceResource where ID IN: skilledResourcesId AND isActive = TRUE ORDER BY Name ASC];
        
        return new List<List<ServiceResource>>{skilldResource};
    }
    
    public class payloadIn{
        @invocableVariable(required=true)
        public string skillId;
    }
}