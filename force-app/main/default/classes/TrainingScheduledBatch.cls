global class TrainingScheduledBatch implements Database.Batchable<SObject>{

	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator([SELECT Id, StageName FROM Opportunity WHERE StageName = 'Training Scheduled'
			AND Name = 'none']);
	}

	global void execute(Database.BatchableContext BC, List<Opportunity> opportunities){
		if(!opportunities.isEmpty()){
			TrainingScheduledExecution.processTrainingScheduledExecution(opportunities);
		}
	}

	global void finish(Database.BatchableContext BC){
	}
}