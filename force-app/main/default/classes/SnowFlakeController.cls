public class SnowFlakeController {

    /*public SnowFlakeController() {
        List<omnata_sflite.SnowflakeQueryBinding> queryBindings = new List<omnata_sflite.SnowflakeQueryBinding>();
        //String query = 'select m.cdate as "Date", m.SUBJECT as "Content", "email" as "Icon" from solder.ACTIVECAMPAIGN.MESSAGES m';
        //        String query = 'select "2018-01-01"::DATE as "Date", NAME as "Content", "email" as "Icon" from PK_DEMO_TABLE';
        //        String query = 'select "2018-01-01"::DATE as "Date", NAME as "Content", "email" as "Icon" from DEMO_DB.PUBLIC.PK_DEMO_TABLE';
        String query = 'select \'2018-01-01\'::DATE as "Date", NAME as "Content", \'email\' as "Icon" from DEMO_DB.PUBLIC.PK_DEMO_TABLE';

        queryBindings.add(new omnata_sflite.SnowflakeQueryBinding('TEXT', 'the_actual_value'));
        String snowflakeConnectionName = 'Main';
        omnata_sflite.SnowflakeConnection conn = new omnata_sflite.SnowflakeConnection(snowflakeConnectionName);
        omnata_sflite.SnowflakeSchemaResponse response = conn.executeQuery(query, queryBindings);
        // data types for the columns:
        system.debug(response.data);

        // data types for the columns:
        List<omnata_sflite.SnowflakeSchemaResponse.Rowtype> rowtypes = response.data.rowtype;
        // actual rows and column values, you access them by column index
        List<List<String>> rowset = response.data.rowset;

        Date epoch = date.newInstance(1970, 1, 1);

        List<TimeLineEntry> timeLineEntries = new List<TimeLineEntry>();
        for (List<String> resultsRow : rowset) {
            system.debug(resultsRow);
            TimeLineEntry entry = new TimeLineEntry();
            entry.icon = resultsRow[2];
            entry.content = resultsRow[1];
            entry.datez = epoch.addDays(Integer.valueOf(resultsRow[0]));
            timeLineEntries.add(entry);
        }
        system.debug(timeLineEntries);
    }*/


   /* public static Map<string, String> iconMap = new Map<String, String>{
    'email' => 'standard:email'
    };

    @AuraEnabled
    public static List<TimeLineEntry> getTimelineEntries(String query) {
        List<omnata_sflite.SnowflakeQueryBinding> queryBindings = new List<omnata_sflite.SnowflakeQueryBinding>();


        queryBindings.add(new omnata_sflite.SnowflakeQueryBinding('TEXT', 'the_actual_value'));
        String snowflakeConnectionName = 'Main';
        omnata_sflite.SnowflakeConnection conn;
        if(Test.isRunningTest()){
            omnata_sflite.SnowflakeSchemaResponse mockResponse = new omnata_sflite.SnowflakeSchemaResponse();
            conn = new omnata_sflite.SnowflakeConnection(mockResponse);
        }
        else{
            conn = new omnata_sflite.SnowflakeConnection(snowflakeConnectionName);
        }
        omnata_sflite.SnowflakeSchemaResponse response = conn.executeQuery(query, queryBindings);
        // data types for the columns:
        system.debug(response.data);
        if(Test.isRunningTest()){
            omnata_sflite.SnowflakeSchemaResponse.Rowtype row1 = new omnata_sflite.SnowflakeSchemaResponse.Rowtype();
            row1.name = 'Icon';
            omnata_sflite.SnowflakeSchemaResponse.Rowtype row2 = new omnata_sflite.SnowflakeSchemaResponse.Rowtype();
            row2.name = 'Content';

            List<String> l1 = new List<String>{'test1','test2'};
            List<String> l2 = new List<String>{'test1','test2'};

            List<List<String>> sl1 = new List<List<String>>();
            sl1.add(l1);
            sl1.add(l2);

            response.data = new omnata_sflite.SnowflakeSchemaResponse.Data();
            system.debug(response.data);
            response.data.rowtype = new List<omnata_sflite.SnowflakeSchemaResponse.Rowtype>();
            response.data.rowtype.add(row1);
            response.data.rowtype.add(row2);

            response.data.rowset = sl1;
        }
        // data types for the columns:
        List<omnata_sflite.SnowflakeSchemaResponse.Rowtype> rowtypes = response.data.rowtype;
        // actual rows and column values, you access them by column index
        List<List<String>> rowset = response.data.rowset;

        system.debug(response.data);
        system.debug(response.data.rowtype);
        system.debug(response.data.rowset);
        Date epoch = date.newInstance(1970, 1, 1);

        List<TimeLineEntry> timeLineEntries = new List<TimeLineEntry>();
        Map<Integer, String> rowtypeMap = new Map<Integer, String>();
        Map<String, Integer> rowtypeMapInverse = new Map<String, Integer>();
        Integer index = 0;
        List<string> requiredFields = new List<String>{'Icon', 'Content'};
        for (omnata_sflite.SnowflakeSchemaResponse.Rowtype rt : response.data.rowtype) {
            rowtypeMap.put(index, rt.name);
            rowtypeMapInverse.put(rt.name, index);
            index++;
        }
        Boolean validateQuery = true;
        for(String field:requiredFields){
            if(!rowtypeMapInverse.containsKey(field)) validateQuery = false;
        }

        if(validateQuery==false){
            throw new AuraHandledException('Required Fields are Missing');

        }
        system.debug(rowtypeMap);
        for (List<String> resultsRow : rowset) {
            system.debug(resultsRow);
            index = 0;
            TimeLineEntry entry = new TimeLineEntry();
            for(String val:resultsRow){
                if(rowtypeMap.get(index) == 'Date'){
                    entry.datez = epoch.addDays(Integer.valueOf(val));
                }
                else if(rowtypeMap.get(index) == 'Content'){
                    entry.content = val;
                }
                else if(rowtypeMap.get(index) == 'Icon'){
                    entry.icon = iconMap.get(val);
                }
                else if(rowtypeMap.get(index) == 'Body'){
                    entry.body = val;
                }

                index ++;
            }
            timeLineEntries.add(entry);
        }
        system.debug(timeLineEntries);
        return timeLineEntries;
    }

    public class TimeLineEntry{
        @AuraEnabled
        public String icon;
        @AuraEnabled
        public date datez;
        @AuraEnabled
        public String content;
        @AuraEnabled
        public String body;
    }*/

}