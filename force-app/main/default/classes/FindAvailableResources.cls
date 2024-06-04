public class FindAvailableResources{
    @invocableMethod(label='Get Available Resources')
    public static List<OutputWrapper> getResources(list<payloadIn> payloadList){
        if(payloadList == null || payloadList.size() <> 1) return null;
        payloadIn payLoad = payloadList[0];
        /*
        List<AssignedResource> assignedResourceList = [Select ServiceResourceId, ServiceResource.Name, ServiceAppointment.SchedEndTime 
            from AssignedResource
            WHERE (ServiceAppointment.SchedStartTime <= :payLoad.endTime AND ServiceAppointment.SchedStartTime >= :payLoad.startTime) OR 
            (ServiceAppointment.SchedEndTime <= :payLoad.endTime AND ServiceAppointment.SchedEndTime >= :payLoad.startTime) OR
            (ServiceAppointment.SchedStartTime < :payLoad.startTime AND ServiceAppointment.SchedEndTime > :payLoad.endTime) ];
        System.debug('assignedResourceList-->' + assignedResourceList); 
        */
        System.debug('payLoad-->' + payLoad);    
        Boolean allowConcurrent = false;
        WorkTypeGroup workTypeGroup = new WorkTypeGroup();
        if(String.isNotBlank(payLoad.workTypeGroupId)){
            workTypeGroup = [Select Id, Allow_Concurrent_Scheduling__c, Meeting_Type__c from WorkTypeGroup where Id=: payLoad.workTypeGroupId limit 1];
            allowConcurrent = workTypeGroup.Allow_Concurrent_Scheduling__c;
        }  
        
        WorkTypeGroupMember workTypeGroupMember = new WorkTypeGroupMember();
        Integer blockTimeBeforeDuration = 0;
        String blockTimeBeforeUnit = 'Minutes';
        Integer blockTimeAfterDuration = 0;
        String blockTimeAfterUnit = 'Minutes';
        if(String.isNotBlank(payLoad.workTypeGroupId)){
            workTypeGroupMember = [Select id, WorkType.BlockTimeBeforeAppointment, WorkType.BlockTimeAfterAppointment, WorkType.BlockTimeAfterUnit, WorkType.BlockTimeBeforeUnit
                from WorkTypeGroupMember where WorkTypeGroupId =: payLoad.workTypeGroupId limit 1];
            if(workTypeGroupMember.WorkType.BlockTimeBeforeAppointment != null){
                blockTimeBeforeDuration = Integer.valueOf(workTypeGroupMember.WorkType.BlockTimeBeforeAppointment);
            }
            if(workTypeGroupMember.WorkType.BlockTimeAfterAppointment != null){
                blockTimeAfterDuration = Integer.valueOf(workTypeGroupMember.WorkType.BlockTimeAfterAppointment);
            }
            if(workTypeGroupMember.WorkType.BlockTimeAfterUnit != null){
                blockTimeAfterUnit = String.valueOf(workTypeGroupMember.WorkType.blockTimeAfterUnit);
            }
            if(workTypeGroupMember.WorkType.BlockTimeBeforeUnit != null){
                blockTimeBeforeUnit = String.valueOf(workTypeGroupMember.WorkType.BlockTimeBeforeUnit);
            }
        }
        
        DateTime endTimeWithBuffer = blockTimeAfterUnit == 'Minutes' ? payLoad.endTime.addMinutes(blockTimeAfterDuration) : payLoad.endTime.addHours(blockTimeAfterDuration); 
        DateTime startTimeWithBuffer = blockTimeBeforeUnit == 'Minutes' ? payLoad.startTime.addMinutes(-blockTimeBeforeDuration) : payLoad.startTime.addHours(-blockTimeBeforeDuration); 
         
        List<Event> existingEventList =  [Select OwnerId 
            from Event
            WHERE ((StartDateTime < :endTimeWithBuffer AND StartDateTime >= :startTimeWithBuffer) OR 
            (EndDateTime <= :endTimeWithBuffer AND EndDateTime > :startTimeWithBuffer) OR
            (StartDateTime < :startTimeWithBuffer AND EndDateTime > :endTimeWithBuffer))
			AND ShowAs != 'Free' 	]; 
        System.debug('existingEventList--> ' + existingEventList);   
        
        Set<Id> blockedUserIdSet = new Set<Id>();
        if(!existingEventList.isEmpty()){
            for(Event evt : existingEventList){
                blockedUserIdSet.add(evt.OwnerId);
            }
        }
        System.debug('blockedUserIdSet-->' + blockedUserIdSet);
        Set<Id> blockedServiceResourceIdSet = new Set<Id>();
        /*
        if(!assignedResourceList.isEmpty()){
            for(AssignedResource ar : assignedResourceList){
                blockedServiceResourceIdSet.add(ar.ServiceResourceId);
            }
        }
        System.debug('blockedServiceResourceIdSet-->' + blockedServiceResourceIdSet);
        */
        if(String.isNotBlank(payLoad.currentServiceResourceId)){
            blockedServiceResourceIdSet.add(payLoad.currentServiceResourceId);
        }
        if(String.isNotBlank(payLoad.workTypeGroupId) && payLoad.checkSkills){
            List<SkillRequirement> requiredSkills = [Select id, SkillId, Skill.DeveloperName from SkillRequirement 
                where RelatedRecordId  IN (Select WorkTypeId from WorkTypeGroupMember where WorkTypeGroupId =:  payLoad.workTypeGroupId)];
            if(!requiredSkills.isEmpty()){
                Set<Id> requiredSkillSetId = new Set<Id>();
                for(SkillRequirement requiredSkill : requiredSkills){
                    requiredSkillSetId.add(requiredSkill.SkillId);
                }
                List<ServiceResourceSkill> assignedSkills = [Select id, ServiceResourceId, EffectiveStartDate from ServiceResourceSkill where SkillId IN: requiredSkillSetId AND EffectiveStartDate <= :startTimeWithBuffer];
                if(!assignedSkills.isEmpty()){
                    Set<Id> skilledResourcesId = new Set<Id>();
                    for(ServiceResourceSkill assignedSkill : assignedSkills){
                        skilledResourcesId.add(assignedSkill.ServiceResourceId);
                    }
                    Map<Id,ServiceResource> availableResourceMap = new Map<Id,ServiceResource>();
                    if(!allowConcurrent){
                        availableResourceMap = new Map<Id,ServiceResource>([
                            Select Id, Name, RelatedRecordId, Allow_Concurrent_Scheduling__c  from ServiceResource
                            WHERE ID IN: skilledResourcesId AND 
                            ((ID NOT IN: blockedServiceResourceIdSet AND RelatedRecordId NOT IN: blockedUserIdSet)) AND IsActive = TRUE
                            order by name asc
                        ]);
                    }else{
                        availableResourceMap = new Map<Id,ServiceResource>([
                            Select Id, Name, RelatedRecordId, Allow_Concurrent_Scheduling__c from ServiceResource
                            WHERE ID IN: skilledResourcesId AND 
                            ((ID NOT IN: blockedServiceResourceIdSet AND RelatedRecordId NOT IN: blockedUserIdSet) OR Allow_Concurrent_Scheduling__c = TRUE) AND IsActive = TRUE
                            order by name asc
                        ]);
                    }
                    
                    System.debug('availableResourceMap-->' + availableResourceMap);
                    return new List<OutputWrapper>{checkOperatingHours(availableResourceMap,payLoad.startTime,payLoad.endTime,workTypeGroup,blockedUserIdSet)};
                }else{
                    return new List<OutputWrapper>{new OutputWrapper(null,null )};
                }
            }    
        }
        Map<Id,ServiceResource> availableResourceMap = new Map<Id,ServiceResource>([
            Select Id, Name, RelatedRecordId from ServiceResource
            WHERE ((ID NOT IN: blockedServiceResourceIdSet AND RelatedRecordId NOT IN: blockedUserIdSet)) AND IsActive = TRUE
            order by name asc
        ]);
        System.debug('availableResourceMap1-->' + availableResourceMap);
        return new List<OutputWrapper>{checkOperatingHours(availableResourceMap,payLoad.startTime,payLoad.endTime,workTypeGroup,blockedUserIdSet)};
    }
    public static OutputWrapper checkOperatingHours(Map<Id,ServiceResource> availableResourceMap, DateTime startTime, DateTime endTime, WorkTypeGroup workTypeGroup, Set<Id> blockedUserIdSet){
        Map<Id,Id> mapServiceResourceByUserId = new Map<Id,Id>();
        for(ServiceResource resource : availableResourceMap.values()){
            mapServiceResourceByUserId.put(resource.RelatedRecordId, resource.Id);
        }
        String currentDayOfWeek = startTime.format('EEEE');
        System.debug('currentDayOfWeek-->' + currentDayOfWeek);
        List<ServiceResource> availableResource = new List<ServiceResource>();
        List<TimeSlot> timeSlotList = [Select id, DayOfWeek, StartTime, EndTime, OperatingHours.Name, OperatingHoursId, OperatingHours.TimeZone, MaxAppointments,
        (Select id, WorkTypeGroupId, WorkTypeGroup.Name, operatingHoursId, OperatingHours.Name from AppointmentTopicTimeSlots) 
        from TimeSlot where DayOfWeek =: currentDayOfWeek];
        System.debug('timeSlotList->' + timeSlotList);
        Map<Id,TimeSlot> mapTimeSlotByOperatingHoursId = new Map<Id,TimeSlot>();
        //System.debug('startTime--> ' + startTime);
        //System.debug('endTime--> ' + endTime);
        for(TimeSlot ts: timeSlotList){
            //System.debug('ts.OperatingHours.Name--> ' + ts.OperatingHours.Name);
            //System.debug('ts.OperatingHours.TimeZone--> ' + ts.OperatingHours.TimeZone);
            //System.debug('ts.StartTime--> ' + ts.StartTime);
            //System.debug('ts.EndTime--> ' + ts.EndTime);
            Timezone tz = Timezone.getTimeZone(ts.OperatingHours.TimeZone);
            Integer offset = tz.getOffset(startTime);
            Time convertedStartTime = startTime.addSeconds(offset/1000).timeGMT();
            //System.debug('convertedStartTime--> ' + convertedStartTime  );
            Time convertedEndTime = endTime.addSeconds(offset/1000).timeGMT();
            //System.debug('convertedEndTime--> ' + convertedEndTime);
            if(convertedStartTime >= ts.StartTime && convertedStartTime <= ts.EndTime && convertedEndTime >= ts.StartTime && convertedEndTime <= ts.EndTime ){
                if(ts.AppointmentTopicTimeSlots.size() == 0){
                    mapTimeSlotByOperatingHoursId.put(ts.OperatingHoursId,ts);
                }else{
                    for(AppointmentTopicTimeSlot appointmentTimeSlot : ts.AppointmentTopicTimeSlots){
                        if(appointmentTimeSlot.workTypeGroupId == workTypeGroup.Id){
                            mapTimeSlotByOperatingHoursId.put(ts.OperatingHoursId,ts);
                        }
                    }
                }
                
            }
        }
        System.debug('mapTimeSlotByOperatingHoursId->' + mapTimeSlotByOperatingHoursId);
        List<ServiceTerritoryMember> territoryMembersList = [Select Id, ServiceResourceId, ServiceTerritoryId, OperatingHoursId, OperatingHours.Name, ServiceResource.RelatedRecordId  
            from ServiceTerritoryMember
            WHERE ServiceResourceId IN: availableResourceMap.keySet()];
        System.debug('territoryMembersList-->' + territoryMembersList);      
        Map<Id,Id> mapServiceTerritoryIdByResourceId = new Map<Id,Id>();
        Map<Id,Id> mapOperatingHoursIdByResourceId = new Map<Id,Id>();
        for(ServiceTerritoryMember stm : territoryMembersList){
            if(!mapTimeSlotByOperatingHoursId.containsKey(stm.OperatingHoursId)){
                availableResourceMap.keySet().remove(stm.ServiceResourceId);
                mapServiceResourceByUserId.keySet().remove(stm.ServiceResource.RelatedRecordId);
            }
            mapServiceTerritoryIdByResourceId.put(stm.ServiceResourceId,stm.ServiceTerritoryId);
            mapOperatingHoursIdByResourceId.put(stm.ServiceResourceId,stm.OperatingHoursId);
        }
        System.debug('Updated availableResourceMap-->' + availableResourceMap);      
        AggregateResult[] currentEvents = [Select Count(Id) eventCount, sum(DurationInMinutes) eventDuration, OwnerId userId
            from Event
            WHERE StartDateTime >= : System.now() AND StartDateTime <= NEXT_N_DAYS:14 AND OwnerId IN: mapServiceResourceByUserId.keySet() AND Scheduled_with_SF_Scheduler__c = TRUE
            GROUP BY OwnerId order by sum(DurationInMinutes) asc];
        System.debug('currentEvents-->' + currentEvents);     
        AggregateResult[] concurrentEvents = [Select Count(Id) eventCount, sum(DurationInMinutes) eventDuration, OwnerId userId
            from Event
            WHERE StartDateTime = :startTime AND EndDateTime = :endTime AND OwnerId IN: mapServiceResourceByUserId.keySet()
            AND Meeting_Type_CP__c != NULL AND Meeting_Type_CP__c =: workTypeGroup.Meeting_Type__c
            GROUP BY OwnerId order by sum(DurationInMinutes) asc];    
        System.debug('concurrentEvents-->' + concurrentEvents);    
        System.debug('concurrent->' + [Select Id, OwnerId from Event
            WHERE StartDateTime = :startTime AND EndDateTime = :endTime AND OwnerId IN: mapServiceResourceByUserId.keySet()
            AND Meeting_Type_CP__c != NULL AND Meeting_Type_CP__c =: workTypeGroup.Meeting_Type__c])     ; 
        Map<Id,Integer> mapConcurrentEventCountByUser = new Map<Id,Integer>();
        Map<Id,Decimal> mapConcurrentEventDurationByUser = new Map<Id,Decimal>();
        for(AggregateResult ar : concurrentEvents){
            mapConcurrentEventCountByUser.put((ID)ar.get('userId'), (Integer)ar.get('eventCount'));
            mapConcurrentEventDurationByUser.put((ID)ar.get('userId'), (Decimal)ar.get('eventDuration'));
        } 
        System.debug('mapConcurrentEventCountByUser->' + mapConcurrentEventCountByUser);
        Map<Id,Integer> mapEventCountByUser = new Map<Id,Integer>(); 
        Map<Id,Decimal> mapEventDurationByUser = new Map<Id,Decimal>(); 
        OutputWrapper output = new OutputWrapper(null,null ); 
        Integer count = 0;
        for(AggregateResult ar : currentEvents){
            mapEventCountByUser.put((ID)ar.get('userId'), (Integer)ar.get('eventCount'));
            mapEventDurationByUser.put((ID)ar.get('userId'), (Decimal)ar.get('eventDuration'));
            Id resourceId = mapServiceResourceByUserId.get((ID)ar.get('userId'));
            System.debug('resourceId->' + resourceId);
            if(count == 0){
                output = new OutputWrapper(availableResourceMap.get(resourceId),mapServiceTerritoryIdByResourceId.get(resourceId) );
                System.debug('output -->' + output );
                count++;
                if(availableResourceMap.get(resourceId).Allow_Concurrent_Scheduling__c  && !mapConcurrentEventCountByUser.containsKey((Id)ar.get('userId')) && 
                    blockedUserIdSet.contains((Id)ar.get('userId'))){
                    output = new OutputWrapper(null,null ); 
                    count = 0;
                }
            }
            if(mapConcurrentEventCountByUser.containsKey((Id)ar.get('userId')) && mapOperatingHoursIdByResourceId.containsKey(resourceId) &&
                mapTimeSlotByOperatingHoursId.containsKey(mapOperatingHoursIdByResourceId.get(resourceId) ) &&
                mapTimeSlotByOperatingHoursId.get(mapOperatingHoursIdByResourceId.get(resourceId) ).MaxAppointments != null && 
                mapConcurrentEventCountByUser.get((Id)ar.get('userId')) >= mapTimeSlotByOperatingHoursId.get(mapOperatingHoursIdByResourceId.get(resourceId) ).MaxAppointments){
                System.debug('(Integer)ar.get(eventCount)-->' + (Integer)ar.get('eventCount'));
                output = new OutputWrapper(null,null ); 
                count = 0;
            }
        }    
        for(ServiceResource resource : availableResourceMap.values()){
            if(!mapEventCountByUser.containsKey(resource.relatedRecordId)){
                output = new OutputWrapper(resource ,mapServiceTerritoryIdByResourceId.get(resource.Id) );
                return output;  
            }
        }
        //System.assert(false,'final output -->' + output );
        System.debug('availableResource-->' + availableResource); 
        return output;  
        //return new OutputWrapper(null,null );
        //return availableResource.size() == 0 ? new List<ServiceResource>{availableResourceMap.values()[0]} : availableResource;
    }
    public class payloadIn{
        @invocableVariable(required=false)
        public string workTypeGroupId;
        @invocableVariable(required=true)
        public boolean checkSkills;
        @invocableVariable(required=false)
        public string serviceTerritoryId;
        @invocableVariable(required=false)
        public string currentServiceResourceId;
        @invocableVariable(required=false)
        public string schedulingPolicyId;
        @invocableVariable(required=false)
        public string accountId;
        @invocableVariable(required=true)
        public datetime startTime;
        @invocableVariable(required=true)
        public datetime endTime;
    }
    public class OutputWrapper{
        @invocableVariable
        public ServiceResource availableResource;
        @invocableVariable
        public string serviceTerritoryId;
        public OutputWrapper(ServiceResource availableResource, string serviceTerritoryId){
            this.availableResource = availableResource;
            this.serviceTerritoryId = serviceTerritoryId;
        }
    }
}