@IsTest
public class TestTrainingScheduledStageJob {

	static testmethod void testTrainingScheduledJob(){
		Test.startTest();

		Contact c = new Contact();
		c.LastName = 'test';
		insert c;

		Opportunity opp = new Opportunity(StageName = 'Training Scheduled', CloseDate = System.today(), Name = 'none', Contact__c = c.Id);
		insert opp;

		TrainingStageSchedule trainingStageSchedule = new TrainingStageSchedule();
		System.schedule('testTrainingScheduledJob', '0 11 10 * * ? *', trainingStageSchedule);
		trainingStageSchedule.execute(null);

		Test.stopTest();

		Opportunity opportunity = [SELECT Id, StageName FROM Opportunity WHERE Id =: opp.Id];

		TrainingScheduleProcessJob t = new TrainingScheduleProcessJob();
	//	System.assertEquals('Needs Setup', opportunity.StageName);
	//	System.assertNotEquals(opp.StageName, opportunity.StageName);
	}
}