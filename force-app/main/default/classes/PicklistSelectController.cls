public with sharing class PicklistSelectController {

	@AuraEnabled
	public static String getFieldLabel( String objectName, String fieldName ) {
		String label = Schema.getGlobalDescribe().get( objectName ).getDescribe().fields.getMap().get( fieldName ).getDescribe().getLabel();
		return label;
	}

	@AuraEnabled
	public static List<PicklistOption> getPicklistOptions( String objectName, String fieldName ) {
		List<PicklistOption> options = new List<PicklistOption>();

		for ( PicklistEntry entry : Schema.getGlobalDescribe().get( objectName ).getDescribe().fields.getMap().get( fieldName ).getDescribe().getPicklistValues() ) {
			options.add( new PicklistOption( entry.getLabel(), entry.getValue() ) );
		}
		return options;
	}

	public class PicklistOption {
		@AuraEnabled
		public String label { get; set; }
		@AuraEnabled
		public String value { get; set; }
		public PicklistOption( String label, String value ) {
			this.label = label;
			this.value = value;
		}
	}
}