@isTest
public class MassCloseExtensionTest {

	@isTest
	static void MassCloseExtensionTest()
		{
			List <Case> cases = new List<Case>();

			Case c = new Case();
			c.Subject='test';
			insert c;

			cases.add(c);


			Test.startTest();
			Test.setCurrentPage(Page.TaskMassClose);
			ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(cases);
			stdSetController.setSelected(cases);
			MassCloseExtension ext = new MassCloseExtension(stdSetController);
			ext.execute();
			Test.stopTest();
		}
}