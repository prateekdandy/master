global class TrainingStageSchedule implements Schedulable{

	global void execute(SchedulableContext SC){
		Database.executeBatch(new TrainingScheduledBatch());
	}
}