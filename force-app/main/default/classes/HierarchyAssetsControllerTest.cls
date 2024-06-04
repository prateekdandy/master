@isTest
public class HierarchyAssetsControllerTest {
	@IsTest static void testHierarchyAssetsController() {
		Account a = new Account();
		a.Name = 'test';
		insert a;

		Account a2 = new Account();
		a2.Name = 'test2';
		a2.ParentId = a.Id;
		insert a2;

		Asset asset = new Asset();
		asset.Name = 'test';
		asset.AccountId = a.Id;
		insert asset;

		Asset asset2 = new Asset();
		asset2.Name = 'test';
		asset2.AccountId = a2.Id;
		insert asset2;

		Test.startTest();
		List<Account> accs = new List<Account>();
		accs = HierarchyAssetsController.ChildAccountsInHierarchy(a.Id);
		System.assertEquals(2, accs.size());
		Test.stopTest();
	}
}