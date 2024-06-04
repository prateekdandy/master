public class FirstOrderQuestions {
	@AuraEnabled
	public static String saveForm(String Opportunity_Id,
								  String General_Feedback_FO,
								  String Rate_The_Esthetics_Of_Your_Cases,
								  String Esthetics_Feedback,
								  String Rate_The_Fit_Of_The_Crowns,
								  String Fit_Feedback,
								  String Rate_The_Turnaround_Time,
								  String Turnaround_Time,
								  String Rate_The_Customer_Support_You_Received,
								  String Customer_Support,
								  String Training_Sessions_Guidance_For_Success
								  ) {
		Opportunity opp = new Opportunity();
		opp.Id = Opportunity_Id;
		opp.General_Feedback_FO__c                    = General_Feedback_FO                    ;
		opp.Rate_The_Esthetics_Of_Your_Cases__c       = Rate_The_Esthetics_Of_Your_Cases       ;
		opp.Esthetics_Feedback__c                     = Esthetics_Feedback                     ;
		opp.Rate_The_Fit_Of_The_Crowns__c             = Rate_The_Fit_Of_The_Crowns             ;
		opp.Fit_Feedback__c                           = Fit_Feedback                           ;
		opp.Rate_The_Turnaround_Time__c               = Rate_The_Turnaround_Time               ;
		opp.Turnaround_Time__c                        = Turnaround_Time                        ;
		opp.Rate_The_Customer_Support_You_Received__c = Rate_The_Customer_Support_You_Received ;
		opp.Customer_Support__c                       = Customer_Support                       ;
		opp.Training_Sessions_Guidance_For_Success__c = Training_Sessions_Guidance_For_Success ;
		update opp;
		return 'Saved';
	}

	@AuraEnabled
	public static Opportunity getOpportunity(String oppId) {
		return [Select Id, Name,
				General_Feedback_FO__c                   ,
				Rate_The_Esthetics_Of_Your_Cases__c      ,
				Esthetics_Feedback__c                    ,
				Rate_The_Fit_Of_The_Crowns__c            ,
				Fit_Feedback__c                          ,
				Rate_The_Turnaround_Time__c              ,
				Turnaround_Time__c                       ,
				Rate_The_Customer_Support_You_Received__c,
				Customer_Support__c                      ,
		        Training_Sessions_Guidance_For_Success__c
		        from Opportunity where Id =: oppId limit 1];
	}
}