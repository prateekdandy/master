public class updateAccountTypeScheduler {

    public static void scheduleUpdateAccountTypeBatch() {
        System.debug('Starting Account Type Update Batch...');
        Database.executeBatch(new updateAccountTypeGlobalClass());
        System.debug('Account Type Update Batch finished.');
    }
}