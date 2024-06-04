@isTest
public class FindAvailableResourcesTest{
    @isTest
    static void testMethod1(){
    
        Id skillId = [Select id, DeveloperName from Skill limit 1].Id;
        
        OperatingHours operatingHours = new OperatingHours(
          Name = 'Eastern Standard Time',                                  
          TimeZone = 'America/New_York'
        );
        insert operatingHours;
        
        WorkType workTypeObj = new WorkType(
            Name = 'Follow Up Training - Dentures',
            EstimatedDuration = 90.00,           
            DurationType = 'Minutes',              
            BlockTimeBeforeAppointment = 30,     
            BlockTimeBeforeUnit = 'Minutes',     
            BlockTimeAfterAppointment = 15,      
            BlockTimeAfterUnit = 'Minutes',      
            TimeFrameStartUnit = 'Days',         
            TimeFrameEndUnit = 'Days'            
        );
        insert workTypeObj;
        
        WorkTypeGroup workTypeGroupObj = new WorkTypeGroup(
            Name = 'Follow Up Training - Dentures',          
            GroupType = 'Default',                           
            IsActive = true,                                 
            Button__c = 'Book Follow Up Training',           
            Meeting_Type__c = 'Follow Up Training - Dentures',
            Create_Training_Record__c = false,                 
            Training_Type__c = 'Follow Up - Dentures',
            Training_Reason__c = 'Dentures',                  
            Email_Invite_Subject__c = 'Dentures Training'     
        );
        insert workTypeGroupObj;
        
        WorkTypeGroupMember workTypeGroupMemobj = new WorkTypeGroupMember(
            WorkTypeGroupId = workTypeGroupObj.Id,
            WorkTypeId = workTypeObj.Id
        );
        insert workTypeGroupMemobj;
        
        SkillRequirement skillReqObj = new SkillRequirement(
            SkillId = skillId,
            RelatedRecordId = workTypeObj.Id
        );
        insert skillReqObj;
        
        TimeSlot monday = new TimeSlot(
          DayOfWeek = 'Monday',  
          Type = 'Normal',       
          StartTime = Time.newInstance(8, 45, 0, 0), 
          EndTime = Time.newInstance(18, 15, 0, 0),   
          MaxAppointments = 1,
          OperatingHoursId =  operatingHours.Id 
        );
        insert monday;
        
        TimeSlot tuesday = new TimeSlot(
          DayOfWeek = 'Tuesday',  
          Type = 'Normal',        
          StartTime = Time.newInstance(8, 45, 0, 0), 
          EndTime = Time.newInstance(18, 15, 0, 0),
          MaxAppointments = 1 ,
          OperatingHoursId =  operatingHours.Id 
        );
        insert tuesday;
        
        TimeSlot wednesday = new TimeSlot(
          DayOfWeek = 'Wednesday',  
          Type = 'Normal',         
          StartTime = Time.newInstance(8, 45, 0, 0), 
          EndTime = Time.newInstance(18, 15, 0, 0),
          MaxAppointments = 1,
          OperatingHoursId =  operatingHours.Id   
        );
        insert wednesday;
        
        TimeSlot thursday = new TimeSlot(
          DayOfWeek = 'Thursday',  
          Type = 'Normal',         
          StartTime = Time.newInstance(8, 45, 0, 0), 
          EndTime = Time.newInstance(18, 15, 0, 0),
          MaxAppointments = 1,
          OperatingHoursId =  operatingHours.Id   
        );
        insert thursday;
        
        TimeSlot friday = new TimeSlot(
          DayOfWeek = 'Friday',  
          Type = 'Normal',         
          StartTime = Time.newInstance(8, 45, 0, 0), 
          EndTime = Time.newInstance(18, 15, 0, 0),
          MaxAppointments = 1,
          OperatingHoursId =  operatingHours.Id   
        );
        insert friday;
        
        ServiceTerritory territory = new ServiceTerritory(
          Name = 'Eastern Standard Time',
          IsActive = true,
          OperatingHoursId = operatingHours.Id            
        );
        insert territory;
        
        ServiceResource serviceResource = new ServiceResource(
          Name = 'Adam Pelc',                
          IsActive = true,                   
          RelatedRecordId = UserInfo.getUserId(),
          ResourceType = 'T'         
        );
        insert serviceResource;
        
        ServiceTerritoryMember stm = new ServiceTerritoryMember(
            ServiceResourceId = serviceResource.Id,
            ServiceTerritoryId = territory.Id
        );
        
        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;
        
        ServiceAppointment appointment = new ServiceAppointment(
            ParentRecordId = acc.Id,
            AppointmentType = 'Video',
            SchedStartTime = System.now().addHours(4),
            SchedEndTime = System.now().addHours(5)
        );
        insert appointment; 
        
        AssignedResource assignedResource = new AssignedResource(
            ServiceResourceId = serviceResource.Id,
            ServiceAppointmentId = appointment.Id
        );
        insert assignedResource;
        
        ServiceResourceSkill resourceSkillObj = new ServiceResourceSkill(
            ServiceResourceId = serviceResource.Id,
            SkillId = skillId,
            EffectiveStartDate = System.today().addDays(-1)
        );
        insert resourceSkillObj;
        
        Test.startTest();
        FindAvailableResources.payloadIn input = new FindAvailableResources.payloadIn();
        input.startTime = System.now();
        input.endTime = System.now().addHours(1);
        input.checkSkills = true;
        input.workTypeGroupId = workTypeGroupObj.Id;
        FindAvailableResources.getResources(new List<FindAvailableResources.payloadIn>{input});
        Test.stopTest();
    }
    
    @isTest
    static void testMethod2(){
        OperatingHours operatingHours = new OperatingHours(
          Name = 'Eastern Standard Time',                                  
          TimeZone = 'America/New_York'
        );
        insert operatingHours;
        
        TimeSlot monday = new TimeSlot(
          DayOfWeek = 'Monday',  
          Type = 'Normal',       
          StartTime = Time.newInstance(8, 45, 0, 0), 
          EndTime = Time.newInstance(18, 15, 0, 0),   
          MaxAppointments = 1,
          OperatingHoursId =  operatingHours.Id 
        );
        insert monday;
        
        TimeSlot tuesday = new TimeSlot(
          DayOfWeek = 'Tuesday',  
          Type = 'Normal',        
          StartTime = Time.newInstance(8, 45, 0, 0), 
          EndTime = Time.newInstance(18, 15, 0, 0),
          MaxAppointments = 1 ,
          OperatingHoursId =  operatingHours.Id 
        );
        insert tuesday;
        
        TimeSlot wednesday = new TimeSlot(
          DayOfWeek = 'Wednesday',  
          Type = 'Normal',         
          StartTime = Time.newInstance(8, 45, 0, 0), 
          EndTime = Time.newInstance(18, 15, 0, 0),
          MaxAppointments = 1,
          OperatingHoursId =  operatingHours.Id   
        );
        insert wednesday;
        
        TimeSlot thursday = new TimeSlot(
          DayOfWeek = 'Thursday',  
          Type = 'Normal',         
          StartTime = Time.newInstance(8, 45, 0, 0), 
          EndTime = Time.newInstance(18, 15, 0, 0),
          MaxAppointments = 1,
          OperatingHoursId =  operatingHours.Id   
        );
        insert thursday;
        
        TimeSlot friday = new TimeSlot(
          DayOfWeek = 'Friday',  
          Type = 'Normal',         
          StartTime = Time.newInstance(8, 45, 0, 0), 
          EndTime = Time.newInstance(18, 15, 0, 0),
          MaxAppointments = 1,
          OperatingHoursId =  operatingHours.Id   
        );
        insert friday;
        
        ServiceTerritory territory = new ServiceTerritory(
          Name = 'Eastern Standard Time',
          IsActive = true,
          OperatingHoursId = operatingHours.Id            
        );
        insert territory;
        
        ServiceResource serviceResource = new ServiceResource(
          Name = 'Adam Pelc',                
          IsActive = true,                   
          RelatedRecordId = UserInfo.getUserId(),
          ResourceType = 'T'         
        );
        insert serviceResource;
        
        ServiceTerritoryMember stm = new ServiceTerritoryMember(
            ServiceResourceId = serviceResource.Id,
            ServiceTerritoryId = territory.Id
        );
        
        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;
        
        ServiceAppointment appointment = new ServiceAppointment(
            ParentRecordId = acc.Id,
            AppointmentType = 'Video',
            SchedStartTime = System.now().addHours(1),
            SchedEndTime = System.now().addHours(2)
        );
        insert appointment;
        
        AssignedResource assignedResource = new AssignedResource(
            ServiceResourceId = serviceResource.Id,
            ServiceAppointmentId = appointment.Id
        );
        insert assignedResource;
        
        Test.startTest();
        FindAvailableResources.payloadIn input = new FindAvailableResources.payloadIn();
        input.startTime = System.now().addHours(1);
        input.endTime = System.now().addHours(2);
        FindAvailableResources.getResources(new List<FindAvailableResources.payloadIn>{input});
        Test.stopTest();
    }
}