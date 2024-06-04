public class TrainingScheduledExecution {

	public static void processTrainingScheduledExecution(List<Opportunity> opportunities){
		for(Opportunity opp: opportunities){
			/*if(System.today().daysBetween(Date.valueOf(opp.Training_Date_Start_Time__c))<=10){
				opp.StageName = 'Needs Setup';
			}*/
		}
		update opportunities;
	}
}