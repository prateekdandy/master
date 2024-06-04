@isTest
public class PostTrainingQuestionsTest {
	@isTest static void TestPostTrainingQuestions() {
		Contact c = new Contact();
		c.LastName = 'test';
		insert c;
		Opportunity opp = new Opportunity();
		opp.Name = 'test';
		opp.StageName = 'Engaged Prospect';
		opp.Contact__c = c.Id;
		opp.CloseDate = System.today();
		insert opp;
		PostTrainingQuestions.saveForm(opp.Id, 'test','test','test','test','test','1 (Poor)','1 (Poor)');
		PostTrainingQuestions.getOpportunity(opp.Id);

	}
}