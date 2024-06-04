public class TestDataFactory {

    // Non-setup scaffolding should go here
    public static void createTestHookScaffolding() {
    }

    // Setup scaffolding should go here
    public static void createTestUsers() {
        UserRole sales_role = new UserRole(DeveloperName = 'Sales_Role', Name = 'Sales');
        UserRole ops_role = new UserRole(DeveloperName = 'Onboarding_Role', Name = 'Onboarding');
        insert sales_role; 
        insert ops_role;

        Group practiceLeadQueueGroup = new Group(Name='TEST Unqualified Practice Lead Queue', Type='Queue');
        insert practiceLeadQueueGroup;


        QueuesObject practiceLeadQueue = new QueueSObject(QueueID = practiceLeadQueueGroup.id, SObjectType = 'Lead');
        insert practiceLeadQueue;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];

        // Create 3 sales users
        List<User> users = new List<User>();
        for(Integer i=0;i<3;i++) {
            String uniqueUserName = 'sales_user' + DateTime.now().getTime() + i + '@test.meetdandy.com';
            User u = new User(Alias = 'sales'+ i, Email='sales' + i + '@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/New_York',
                UserName=uniqueUserName,
                UserRoleId = sales_role.Id,
                IsActive = true
            );
            users.add(u);
        }
        // Create 3 operations users
        for(Integer i=0;i<3;i++) {
            String uniqueUserName = 'ops_user' + DateTime.now().getTime() + i + '@test.meetdandy.com';
            User u = new User(Alias = 'ops'+ i, Email='ops' + i + '@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/New_York',
                UserName=uniqueUserName,
                UserRoleId = ops_role.Id,
                IsActive = true
            );
            users.add(u);
        }
        insert users;
    }
}