public class HierarchyAssetsController {

	@AuraEnabled
	public static List<Account> ChildAccountsInHierarchy(String parentAcctId) {

		Boolean endTraversing = false;
		Integer accountLevel = 0;
		String query;
		List<Account> acctList = new List<Account>();
		List<String> parentIdList = new List<String>{parentAcctId};
		Map<String, Integer> accountIdLevelMap = new Map<String, Integer>();
		Map<String, Account> accountDetailsMap = new Map<String, Account>();
		Map<String, List<Account>> parentChildLinkedListMap = new Map<String, List<Account>>();
		List<Account> accountHierarchyList = new List<Account>();
		List<Account> allAccounts = new List<Account>();

		while (!endTraversing) {
			if (accountLevel == 0) {
				query = 'select Id, Name, ParentId, (Select Id, Name, Account.Name from Assets) from Account WHERE Id IN :parentIdList';
			} else {
				query = 'select Id, Name, ParentId, (Select Id, Name, Account.Name from Assets) from Account WHERE ParentId IN :parentIdList';
			}
			acctList = Database.query(query);

			if (acctList.size() == 0) {
				endTraversing = true;
			} else {
				parentIdList.clear();
				acctList.sort();
				Account a;
				for (Integer i = 0; i < acctList.size(); i++) {
					a = acctList.get(i);
					parentIdList.add(a.Id);

					accountIdLevelMap.put(a.Id, accountLevel);
					accountDetailsMap.put(a.Id, a);

					if (accountLevel > 0) {
						if (parentChildLinkedListMap.get(a.ParentId) == null) {
							parentChildLinkedListMap.put(a.ParentId, new List<Account>());

						}
						parentChildLinkedListMap.get(a.ParentId).add(a);
						parentChildLinkedListMap.get(a.ParentId).sort();
					}
					allAccounts.add(a);
				}
				accountLevel++;
			}
		}
		return allAccounts;
	}
}