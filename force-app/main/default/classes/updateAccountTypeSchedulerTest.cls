@isTest
public class updateAccountTypeSchedulerTest {

    @testSetup
    static void setupData() {
        // Create sample accounts
        Account parentAccount = new Account(
            Name = 'Parent Account',
            Type = 'Headquarters'
        );
        insert parentAccount;

        Account childAccount1 = new Account(
            Name = 'Child Account 1',
            Type = 'Branch',
            ParentId = parentAccount.Id
        );
        insert childAccount1;

    }

    @isTest
    static void testScheduleUpdateAccountTypeBatch() {
        // Mock System.now() to avoid actual execution of the scheduled job
        //Test.setFixedTime(Date.newInstance(2023, 12, 8, 0, 0, 0));

        // Simulate the scheduler triggering the batch execution
        updateAccountTypeScheduler.scheduleUpdateAccountTypeBatch();

        // Assert the account types are updated correctly
        List<Account> updatedAccounts = [SELECT Id, Name, Type, ParentId  FROM Account WHERE Name IN ('Parent Account', 'Child Account 1', 'Child Account 2')];
        for (Account account : updatedAccounts) {
            if (account.ParentId == null) {
                System.assertEquals('Headquarters', account.Type);
            } else {
                System.assertEquals('Branch', account.Type);
            }
        }
    }
}