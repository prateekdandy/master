public class OpportunityController {

	public static Task createNewTask(Opportunity opp, Integer daysToActivity, String taskSubject, String taskDescription, Id ownerId){
		Task newTask = new Task();
		newTask.WhatId = opp.id;
		newTask.Subject = taskSubject;
		newTask.Description = taskDescription;
		newTask.ActivityDate = System.today().addDays(daysToActivity);
		newTask.OwnerId = ownerId;
		return newTask;
	}
}