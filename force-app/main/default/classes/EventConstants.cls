public class EventConstants {

    private static EventConstants instance = null;

    public Map<String, RecordTypeInfo> EventRecordTypeInfos = null;
    public RecordTypeInfo KickoffCallRecordType = null;
 
    // Private constructor used to memoize lookups
    private EventConstants(){
        EventRecordTypeInfos = Schema.SObjectType.Event.getRecordTypeInfosByName();
    }

    // Static factory method for memoizing lookups
    private static EventConstants getInstance() {
        if (instance == null) {
            instance = new EventConstants();
        }
        return instance;
    }

    public static String TRAINING_EVENT_RECORD_TYPE_ID = getInstance().EventRecordTypeInfos.get('Labs Training').getRecordTypeId();
    public static String KICKOFF_CALL_RECORD_TYPE_ID = getInstance().EventRecordTypeInfos.get('Kickoff Call').getRecordTypeId();

    public final static String DANDY_LABS_TRAINING_EVENT_TYPE_CP = 'Dandy Labs Training';
    public final static String KICKOFF_CALL_EVENT_TYPE_CP = 'Kickoff Call';
    public final static String DISCOVERY_CALL_EVENT_TYPE_CP = 'Discovery Call';
}