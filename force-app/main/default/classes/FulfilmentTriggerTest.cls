@isTest
public class FulfilmentTriggerTest {

    @isTest
    static void testTraining() {
        Account acc = new Account(name = 'test Account');
        insert acc;
        
        List<String> names = new List<String>{'Fulfillment', 'Additional Scanner'};
        List<Fulfillments__c> ffList = new List<Fulfillments__c>();
        
        for(String nameStr : names) {
            Fulfillments__c ffRec = new Fulfillments__c(
                //Deliver_By_Date__c = System.today(),
                Name = nameStr,
                Practice_Name__c = acc.Id
            );                
            
            ffList.add(ffRec);
        }
        
        
        
        Test.startTest();
        insert ffList;
        Test.stopTest();
    }
}