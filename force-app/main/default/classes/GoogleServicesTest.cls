@isTest
public class GoogleServicesTest{
    @isTest
    static void testMethod1(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new GooglePlacesSearchMock());
        
        Test.startTest();
        GoogleServices.serachPlaces('Test String',null,null);
        Test.stopTest();
    }
    
    @isTest
    static void testMethod2(){
        Account acc = new Account(Name = 'Test');
        insert acc;
        
        Test.setMock(HttpCalloutMock.class, new GooglePlaceDetailsMock());
        
        Test.startTest();
        GoogleServices.getPlaceDetails('Test String');
        Test.stopTest();
    }
}