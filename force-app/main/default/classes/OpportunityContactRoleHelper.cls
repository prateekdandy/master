public class OpportunityContactRoleHelper {

	public static void processOpportunityContactRole(List<OpportunityContactRole> OpportunityContactRoles){

		Set<Id> OpportunityIds = new Set<Id>();
		for(OpportunityContactRole ocr:OpportunityContactRoles){
			OpportunityIds.add(ocr.OpportunityId);
		}
		Map<Id, Opportunity> OppMap = new Map<Id, Opportunity>([SELECT Id, Name, AccountId FROM Opportunity Where Id IN :OpportunityIds]);

		List<AccountContactRelation> AccountContactRelations = new List<AccountContactRelation>();
		List<Contact> contacts = new List<Contact>();

		for(OpportunityContactRole ocr:OpportunityContactRoles){
			AccountContactRelation acr = new AccountContactRelation();
			acr.ContactId = ocr.ContactId;
			acr.AccountId = OppMap.get(ocr.OpportunityId).AccountId;
			AccountContactRelations.add(acr);

			Contact c = new Contact();
			c.Id = ocr.ContactId;
			c.AccountId = OppMap.get(ocr.OpportunityId).AccountId;
			contacts.add(c);
		}

		upsert contacts;
		Database.insert(AccountContactRelations, false) ;
	}

}