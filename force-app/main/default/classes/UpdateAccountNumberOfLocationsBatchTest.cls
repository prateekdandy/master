@isTest
private class UpdateAccountNumberOfLocationsBatchTest {

    @TestSetup
    static void setupData() {
        // Create test accounts with parent-child relationships
        // (Same setup as in the ChildCountHandlerTest class)
        Account parent1 = new Account(Name = 'Parent 1');
        insert parent1;
        Account child1 = new Account(Name = 'Child 1', ParentId = parent1.Id);
        Account child2 = new Account(Name = 'Child 2', ParentId = parent1.Id);
        insert new List<Account>{child1, child2};
    }

    @isTest
    static void testBatchExecution() {
        // Test by directly calling the batch execute method
        Test.startTest();
        UpdateAccountNumberOfLocationsBatch batch = new UpdateAccountNumberOfLocationsBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Assert that the parent's Num_Locations__c field is updated correctly
        Account updatedParent = [SELECT Id, Num_Locations__c FROM Account WHERE Name = 'Parent 1'];
        System.assertEquals(2, updatedParent.Num_Locations__c);
    }
}