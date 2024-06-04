public class AccountAutomations  {
    public static void CreatingAccount(Account new_account) {
        Practice_Profile__c new_profile = new Practice_Profile__c(
            Name = new_account.Name,
            Account__c = new_account.Id
        );
        insert new_profile;

        // If run during an aftr insert trigger, the incoming account is not mutable
        Account to_update = [Select Id from Account where Id=:new_account.Id];
        to_update.Practice_Profile__c = new_profile.Id;
        update to_update;
    }

    // We rely on distribution engine to manage the ownership of accounts, but when that ownership
    // does change we want to propagate to the correct opportunities
    public static void AfterOwnerChange(Account newAcct) {
        System.debug('After Owner Change: ' + newAcct.OwnerId);
        List<Opportunity> nonSalesOpps = [Select Id, RecordTypeId, OwnerId from Opportunity where AccountId =: newAcct.Id and RecordTypeId !=: Constants.SALES_OPP_RECORD_TYPE_ID];
        System.debug(nonSalesOpps);
        for (Opportunity opp : nonSalesOpps) {
            if (opp.OwnerId != newAcct.OwnerId) {
            System.debug('Changing account owner: ' + newAcct.OwnerId);
                opp.OwnerId = newAcct.OwnerId;
                update opp;
            }
        }
    }
}