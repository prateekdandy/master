public class Constants {

    private static Constants instance = null;

    public Map<String, RecordTypeInfo> OnboardingRecordTypes = null;
 
    // The constructor is private and initializes the id of the record type
    private Constants(){
        OnboardingRecordTypes = Schema.SObjectType.Opportunity.getRecordTypeInfosByName(); 
    }

    private static Constants getInstance() {
        if (instance == null) {
            instance = new Constants();
        }
        return instance;
    }

    public static String SALES_OPP_RECORD_TYPE_ID = getInstance().OnboardingRecordTypes.get('Sales Pipeline').getRecordTypeId();

    public final static String DENTAL_PRACTICE_ACCOUNT_RECORD_TYPE_ID = '0123h000000M1h0AAC';
    public final static String LAB_CONTRACT_PRESET_99_PLUS_ID = Label.LAB_CONTRACT_PRESET_99_PLUS_ID;

    // Useful so Distribution Engine knows something is unowned
    public final static String SALESFORCE_ADMIN_ID = '0053h000001FOXMAA4';
    public final static String TEST_ACCOUNT_OWNER_ID = '0053h000004Q9USAA0'; // Brenna
    public final static String TEST_TRAINER_ID = '0053h000004LMRxAAO'; // Zach
}