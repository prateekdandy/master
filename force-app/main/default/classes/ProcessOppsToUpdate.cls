public class ProcessOppsToUpdate {
    /*
    public static void processOppsPerRecordType(List<String> oppsToUpdate){
        List<Opportunity> opportunities = [SELECT Id, RecordType.Name, StageName, OwnerId FROM Opportunity WHERE Id =: oppsToUpdate];
        if(!opportunities.isEmpty()){
            for(Opportunity opp: opportunities){
                if(opp.RecordType.Name == 'Ops Pipeline'){
                    // opp = ProcessOppsPipeline.processOppPerStage(opp);
                }else{
                    //
                }
            }
            update opportunities;
        }
    }
    */
}