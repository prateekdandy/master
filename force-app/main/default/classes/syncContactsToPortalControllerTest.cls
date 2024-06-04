@isTest
private class syncContactsToPortalControllerTest {
    @isTest static void testCallout() {

        Account acc = new Account();
        acc.Name = 'Test Account';
        insert acc;

        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'Test First';
        con.LastName = 'Test Last';
        con.Phone = '1234567890';
        con.Email = 'test@gmail.com';

        insert con;
        
        Test.setMock(HttpCalloutMock.class, new syncContactToPortalWebServiceMock());
        
        test.startTest();
        syncContactToPortalController.syncContactToPortal(con.Id);
        //System.assert(con.Portal_User_ID__c != null);
        // Set mock callout class 
        
        test.stopTest();
}
}