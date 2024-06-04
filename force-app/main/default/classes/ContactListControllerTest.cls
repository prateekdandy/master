@IsTest
public class ContactListControllerTest {

	static testmethod void testContactListController(){
		Test.startTest();
		Contact contact = new Contact(
			LastName = 'Test',
			FirstName = 'Test',
			Specialty__c = 'SF Tester'
		);
		insert contact;

		Account account = new Account(
				Name = 'Test'
		);
		insert account;

		Lead lead = new Lead(
				LastName = 'Test',
				FirstName = 'Test',
				Company = 'Test'
		);
		insert lead;

		Opportunity opp = new Opportunity(StageName = 'Training Scheduled', CloseDate = System.today(), Name = 'Test',
				Contact__c = contact.Id, AccountId = account.Id);
		insert opp;

		String JSONContacts = '[{"lastName":"Test","firstName":"Test","id":"fileShare1","specialty":"SF Developer","recordToInsert":"false","isSaved":"true","ableToAdd":"false","recordToUpdate":"true","idContact":"' + contact.Id + '"},' +
				'{"lastName":"Test2","firstName":"Test2","id":"fileShare2","title":"Test","recordToInsert":"true","isSaved":"true","ableToAdd":"false","recordToUpdate":"false","idContact":""}]';

		ContactListController.addContactAndOppContact(JSONContacts, opp.Id, 'Attendees');
		ContactListController.getContactPerOppContactRole('Staff', opp.Id);

		List<Contact> contacts = ContactListController.searchContact('Test Test');

		System.assertEquals(1, contacts.size());
		System.assertNotEquals(contacts[0].Specialty__c, contact.Specialty__c);
		System.assertEquals(contacts[0].Specialty__c, 'SF Developer');
		System.assertNotEquals(0, [SELECT Id FROM OpportunityContactRole WHERE OpportunityId=: opp.Id].size());

		Test.stopTest();

		ContactListController.deleteContactFromOppContactRole(opp.Id, contact.Id, 'Attendees');
		System.assertNotEquals(1, [SELECT Id FROM Contact].size());
	}
}