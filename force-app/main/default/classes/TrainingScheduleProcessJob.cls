global class TrainingScheduleProcessJob{
/*
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([SELECT Id, StageName FROM Opportunity WHERE StageName = 'Training Scheduled'
			AND Name = 'none'] );
		//return null;
	}

	global void execute(Database.BatchableContext BC, List<Opportunity> opportunities) {
		System.debug(opportunities.isEmpty());
		if(!opportunities.isEmpty()){
			TrainingScheduledExecution.processTrainingScheduledExecution(opportunities);
		}
	}

	global void finish(Database.BatchableContext BC) {
	}*/
}