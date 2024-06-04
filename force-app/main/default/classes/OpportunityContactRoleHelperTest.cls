@isTest
public class OpportunityContactRoleHelperTest {
	@IsTest static void testOpportunityContactRoleHelper() {
		Test.startTest();


		Contact c = new Contact();
		c.LastName = 'test';
		insert c;

		Account a = new Account();
		a.Name = 'test';
		insert a;

		Opportunity opp = new Opportunity();
		opp.Name = 'test';
		opp.StageName = 'Contract Signed';
		opp.CloseDate = system.today();
		opp.Contact__c = c.Id;
		insert opp;

		OpportunityContactRole contactRole = new OpportunityContactRole();
		contactRole.OpportunityId = opp.Id;
		contactRole.ContactId = c.Id;
		contactRole.Role = 'Present For Training';

		insert contactRole;
		Test.stopTest();
	}
}