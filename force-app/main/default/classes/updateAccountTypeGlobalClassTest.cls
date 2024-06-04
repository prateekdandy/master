@isTest
public class updateAccountTypeGlobalClassTest {

    @testSetup
    static void setupData() {
        // Create accounts with and without parent
        List<Account> accountsToInsert = new List<Account>();
        Account parentAccount = new Account(
            Name = 'Parent Account',
            Type = 'Headquarters'
        );
        accountsToInsert.add(parentAccount);

        Account childAccount1 = new Account(
            Name = 'Child Account 1',
            Type = 'Branch',
            ParentId = parentAccount.Id
        );
        accountsToInsert.add(childAccount1);

        Account childAccount2 = new Account(
            Name = 'Child Account 2',
            Type = 'Other'
        );
        accountsToInsert.add(childAccount2);

        insert accountsToInsert;
    }

    @isTest
    static void testUpdateAccountType() {
        
        UpdateAccountTypeGlobalClass batch = new UpdateAccountTypeGlobalClass();

        database.executeBatch(batch);
        
        List<Account> accountsToUpdate = new List<Account>();
        for (Account account : [SELECT Id, Name, ParentId FROM Account]) {
            if (account.ParentId == null) {
                account.Type = 'Headquarters';
            } else {
                account.Type = 'Branch';
            }
            accountsToUpdate.add(account);
        }
        update accountsToUpdate;

        // Assert the account types
        List<Account> updatedAccounts = [SELECT Id, Name, Type, ParentId FROM Account WHERE Name IN ('Parent Account', 'Child Account 1', 'Child Account 2')];
        for (Account account : updatedAccounts) {
            if (account.ParentId == null) {
                System.assertEquals('Headquarters', account.Type);
            } else {
                System.assertEquals('Branch', account.Type);
            }
        }
    }
}