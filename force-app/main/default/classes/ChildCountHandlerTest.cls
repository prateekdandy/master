@isTest
private class ChildCountHandlerTest {

    @TestSetup
    static void setupData() {
        // Create test accounts with parent-child relationships
        Account parent1 = new Account(Name = 'Parent 1');
        insert parent1;
        Account child1 = new Account(Name = 'Child 1', ParentId = parent1.Id);
        Account child2 = new Account(Name = 'Child 2', ParentId = parent1.Id);
        insert new List<Account>{child1, child2};
    }

    @isTest
    static void testUpdateAccountCountAfterInsert() {
        // Insert a new child account
        Account newChild = new Account(Name = 'New Child', ParentId = [SELECT Id FROM Account WHERE Name = 'Parent 1'].Id);
        insert newChild;

        // Call the class method to update counts
        ChildCountHandler.updateAccountCount(new List<Account>{newChild});

        // Assert that the parent's Num_Locations__c field is updated correctly
        Account updatedParent = [SELECT Id, Num_Locations__c FROM Account WHERE Name = 'Parent 1'];
        System.assertEquals(3, updatedParent.Num_Locations__c);
    }

    @isTest
    static void testUpdateAccountCountonUpdate() {
        // Update a child account's ParentId
        Account childToUpdate = [SELECT Id FROM Account WHERE Name = 'Child 1'];
        childToUpdate.ParentId = null;
        update childToUpdate;

        // Call the class method to update counts
        Map<Id, Account> oldMap = new Map<Id, Account>{childToUpdate.Id => childToUpdate.clone()};
        ChildCountHandler.updateAccountCountonUpdate(new List<Account>{childToUpdate}, oldMap);

        // Assert that the previous parent's Num_Locations__c is updated, and the new parent's (if any) is updated as well
        Account previousParent = [SELECT Id, Num_Locations__c FROM Account WHERE Name = 'Parent 1'];
        System.assertEquals(1, previousParent.Num_Locations__c);

        // Assert on the new parent if applicable
        if (childToUpdate.ParentId != null) {
            Account newParent = [SELECT Id, Num_Locations__c FROM Account WHERE Id = :childToUpdate.ParentId];
            System.assertEquals(2, newParent.Num_Locations__c);
        }
    }
}