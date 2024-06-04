@isTest
public class AccountServicesTest{
    @isTest
    static void testMethod1(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new GooglePlaceDetailsMock());
        
        Test.startTest();
        GooglePlaceAPIController.WeekdayOpeningHours openingHours = GooglePlaceAPIController.getOpeningHours('Test String');
        AccountServices.savePlaceOpeningHours(acc.Id,JSON.serialize(openingHours) );
        Test.stopTest();
        
        System.assertEquals('ChIJe9T4pAFZwokRBiEbj9_93U4',[Select Google_Place_ID__c from Account].Google_Place_ID__c);
    }
     @isTest
    static void testMethod2(){
        
        Account acc = new Account(Name = 'Test');
        insert acc;
        Onboarding__c onboarding = new Onboarding__c(Name = 'Test',Account_Name__c = acc.Id);
        
        insert onboarding;
        
        Test.setMock(HttpCalloutMock.class, new GooglePlaceDetailsMock());
        
        Test.startTest();
        GooglePlaceAPIController.WeekdayOpeningHours openingHours = GooglePlaceAPIController.getOpeningHours('Test String');
        AccountServices.savePlaceOpeningHours(onboarding.Id,JSON.serialize(openingHours) );
        Test.stopTest();
        
        System.assertEquals('ChIJe9T4pAFZwokRBiEbj9_93U4',[Select Google_Place_ID__c from Account].Google_Place_ID__c);
    }
        
}