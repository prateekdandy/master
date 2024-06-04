public class PostTrainingQuestions {
	@AuraEnabled
	public static String saveForm(String Opportunity_Id, String General_Feedback,String Scanning_More_Difficult_Than_Others, String Time_To_Complete_A_Full_Scan,
								  String  Assistants_Assisting_With_Scans,String Schedule_A_1_1_Session_With_A_Trainer, String Comfort_Level_With_The_Scanner,
								  String Am_Is_This_Account_At_Risk
								  ){
		Opportunity opp = new Opportunity();
		opp.Id = Opportunity_Id;
		opp.General_Feedback__c = General_Feedback;
		opp.Scanning_More_Difficult_Than_Others__c = Scanning_More_Difficult_Than_Others;
		opp.Time_To_Complete_A_Full_Scan__c = Time_To_Complete_A_Full_Scan;
		opp.Assistants_Assisting_With_Scans__c = Assistants_Assisting_With_Scans;
		opp.Schedule_A_1_1_Session_With_A_Trainer__c = Schedule_A_1_1_Session_With_A_Trainer;
		opp.Comfort_Level_With_The_Scanner__c = Comfort_Level_With_The_Scanner;
		opp.Am_Is_This_Account_At_Risk__c = Am_Is_This_Account_At_Risk;
		update opp;
		return 'Saved';
	}

	@AuraEnabled
	public static Opportunity getOpportunity(String oppId) {
		return [Select Id, Name, Comfort_Level_With_The_Scanner__c, Am_Is_This_Account_At_Risk__c, General_Feedback__c, Scanning_More_Difficult_Than_Others__c, Time_To_Complete_A_Full_Scan__c, Assistants_Assisting_With_Scans__c,	Schedule_A_1_1_Session_With_A_Trainer__c from Opportunity where Id =: oppId limit 1];
	}
}