@isTest
public class TrainingTriggerTest {
    @isTest
    static void testTraining() {
        Account acc = new Account(name = 'test Account');
        insert acc;
        
        List<String> types = new List<String>{'Dandy Labs Training', 'Launch'};
        List<Training__c> trainingList = new List<Training__c>();
            
        for(String trainingType : types) {
            Training__c trainingRec = new Training__c(
                Type__c = trainingType, 
                Training_Start_Time__c = System.today(),
                Name = 'Test Training',
                AccountName__c = acc.Id
            );                
                
           trainingList.add(trainingRec);
       }
        
        Test.startTest();
        insert trainingList;
        Test.stopTest();
    }
	
}