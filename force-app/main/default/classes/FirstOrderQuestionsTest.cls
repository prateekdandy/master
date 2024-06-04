@isTest
public class FirstOrderQuestionsTest {
	@isTest static void TestFirstOrderQuestionsTest() {
		Contact c = new Contact();
		c.LastName = 'test';
		insert c;
		Opportunity opp = new Opportunity();
		opp.Name = 'test';
		opp.StageName = 'Engaged Prospect';
		opp.Contact__c = c.Id;
		opp.CloseDate = System.today();
		insert opp;
		FirstOrderQuestions.saveForm(opp.Id, '1 (Poor)', '1 (Poor)', '1 (Poor)', '1 (Poor)', '1 (Poor)', '1 (Poor)', '1 (Poor)', '1 (Poor)', '1 (Poor)', '1 (Poor)');
		FirstOrderQuestions.getOpportunity(opp.Id);

	}
}