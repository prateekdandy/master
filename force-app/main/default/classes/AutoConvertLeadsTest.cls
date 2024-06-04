@isTest 
public class AutoConvertLeadsTest{
  static testMethod void createnewlead() {
      User userToCreate = [Select id from user where profile.name='System Administrator' Limit 1];
      
      Test.startTest();   

      Lead leadToCreate =new Lead();
      List<Lead> leadList= New List<Lead>();
      leadToCreate.ownerid= userToCreate.id;
      leadToCreate.LastName ='Gupta';
      leadToCreate.Company='Salesforce';
      leadToCreate.LeadSource='Partner Referral';
      leadToCreate.Rating='';
      leadToCreate.Status='';
      insert leadToCreate;
            
      leadList.add(leadToCreate);
      AutoConvertLeads.LeadAssign(leadList);
      
      Test.stopTest();
   }
   
   static testMethod void testDoNotCreateOpp() {
       Apex_Setting__c apexSettings = Apex_Setting__c.getOrgDefaults();
       apexSettings.Disable_Opportunity_Creation__c  = true;
       upsert apexSettings;
      User userToCreate = [Select id from user where profile.name='System Administrator' Limit 1];
      
      Test.startTest();    
      Lead leadToCreate =new Lead();
      List<Lead> leadList= New List<Lead>();
      leadToCreate.ownerid= userToCreate.id;
      leadToCreate.LastName ='Gupta';
      leadToCreate.Company='Salesforce';
      leadToCreate.LeadSource='Partner Referral';
      leadToCreate.Rating='';
      leadToCreate.Status='';
      insert leadToCreate; 
      
      leadList.add(leadToCreate);
      AutoConvertLeads.LeadAssign(leadList);
      
      Test.stopTest();
      System.assertEquals(0,[Select Id from Opportunity].size());
   }
}