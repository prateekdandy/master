@isTest
public class CheckUpdateOpeningHoursSchedulableTest{
    @isTest
    static void testMethod1(){
        Account acc = new Account(Name = 'Test', Google_Place_ID__c='ChIJe9T4pAFZwokRBiEbj9_93U4');
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new GooglePlaceDetailsMock());
        
        Test.startTest();
        CheckUpdateOpeningHoursSchedulableBatch obj = new CheckUpdateOpeningHoursSchedulableBatch();
        obj.execute(null);
        Test.stopTest();
        
        System.assert([Select Monday_Opening_Hours__c from Account].Monday_Opening_Hours__c != null);
    }
}