@isTest
public class GooglePlaceAPIControllerTest{
    @isTest
    static void testMethod1(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new GooglePlacesSearchMock());
        
        Test.startTest();
        GooglePlaceAPIController.searchPlaceFromText('Test String');
        Test.stopTest();
    }
    
    @isTest
    static void testMethod2(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new GooglePlaceDetailsMock());
        
        Test.startTest();
        GooglePlaceAPIController.getOpeningHours('Test String');
        Test.stopTest();
    }
}