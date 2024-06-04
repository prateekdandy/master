public class ContactListController{
	@AuraEnabled
	public static List<Contact> searchContact(String keywordToFind) {
		try{
			List<Contact> contacts = Database.query('SELECT Id, Name, FirstName, LastName, Title, Specialty__c FROM Contact' +
					' WHERE Full_Name__c LIKE \'%'+String.escapeSingleQuotes(keywordToFind)+'%\' LIMIT 20');
			if(contacts.isEmpty()){
				contacts = [SELECT Id, Name, FirstName, LastName, Title, Specialty__c FROM Contact WHERE Name =: keywordToFind LIMIT 20];
			}
			return contacts;
		}catch(Exception e){
			System.debug('Line number: ' + e.getLineNumber() +  ' - Cause: ' + e.getCause() + ' - Message: ' + e.getMessage());
			throw e;
		}
		return null;
	}

	@AuraEnabled
	public static List<Contact> getContactPerOppContactRole(String contactRole, String idOpportunity){
		List<OpportunityContactRole> oppsContactRole = [SELECT Id, ContactId FROM OpportunityContactRole WHERE OpportunityId=: idOpportunity
			AND Role =: contactRole];
		if(!oppsContactRole.isEmpty()){
			List<Id> idContacts = new List<Id>();
			for(OpportunityContactRole oppContactRole: oppsContactRole){
				idContacts.add(oppContactRole.ContactId);
			}
			return [SELECT Id, FirstName, LastName, Title, Specialty__c FROM Contact WHERE Id IN: idContacts];
		}
		return new List<Contact>();
	}

	@AuraEnabled
	public static void addContactAndOppContact(String JSONContacts, String opportunityId, String roleForContact){
		List<AuraJSONProcess.ContactList> auraContacts = (List<AuraJSONProcess.ContactList>)
				System.JSON.deserialize(JSONContacts,List<AuraJSONProcess.ContactList>.class);
		if(!auraContacts.isEmpty()){
			List<Contact> contacts = new List<Contact>();
			List<Id> idContacts = new List<Id>();
			for(AuraJSONProcess.ContactList auraContact: auraContacts){
				if(Boolean.valueOf(auraContact.recordToInsert) || Boolean.valueOf(auraContact.recordToUpdate)){
					Contact contact = new Contact();
					if(!String.isEmpty(auraContact.specialty)){
						contact.Specialty__c = auraContact.specialty;
					}
					if(!String.isEmpty(auraContact.title)){
						contact.Title = auraContact.title;
					}
					if(!String.isEmpty(auraContact.idContact)){
						contact.Id = auraContact.idContact;
					}
					contact.LastName = auraContact.lastName;
					contact.FirstName = auraContact.firstName;
					contacts.add(contact);
				}else{
					if(!String.isEmpty(auraContact.recordToInsert)){
						idContacts.add(auraContact.idContact);
					}
				}
			}
			if(!contacts.isEmpty()) {
				upsert contacts;
				for(Contact contact: contacts){
					idContacts.add(contact.Id);
				}
			}
			if(!idContacts.isEmpty()){
				List<OpportunityContactRole> opportunityContactRoles = [SELECT Id, ContactId FROM OpportunityContactRole
					WHERE OpportunityId =: opportunityId AND Role =: roleForContact];
				List<String> avoidDuplicates = new List<String>();
				if(!opportunityContactRoles.isEmpty()){
					for(OpportunityContactRole oppContactRole: opportunityContactRoles){
						avoidDuplicates.add(oppContactRole.ContactId);
					}
				}
				List<OpportunityContactRole> contactRoles = new List<OpportunityContactRole>();
				for(Id idContact: idContacts){
					if(avoidDuplicates.contains(idContact) != true){
						OpportunityContactRole contactRole = new OpportunityContactRole(
								OpportunityId = opportunityId,
								ContactId = idContact,
								Role = roleForContact
						);
						contactRoles.add(contactRole);
					}
				}
				insert contactRoles;
				if(roleForContact.equalsIgnoreCase('Attendees')){
					ContactListController.calculateAttendeeOnCount(roleForContact, opportunityId);
				}
			}
		}
	}

	@AuraEnabled
	public static void deleteContactFromOppContactRole(String idOpportunity, String contactId, String contactRole){
		OpportunityContactRole oppContactRole = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId =: idOpportunity AND
			ContactId =: contactId AND Role =: contactRole];
		delete oppContactRole;
		if(contactRole.equalsIgnoreCase('Attendees')){
			ContactListController.calculateAttendeeOnCount(contactRole, idOpportunity);
		}
	}

	private static void calculateAttendeeOnCount(String roleForContact, String oppId){
		Integer attendeeCount = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId =: oppId
			AND Role =: roleForContact].size();
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Id =: oppId];
		opp.Attendee_Count__c = String.valueOf(attendeeCount);
		update opp;
	}
}