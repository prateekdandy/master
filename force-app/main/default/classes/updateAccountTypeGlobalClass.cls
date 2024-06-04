global class updateAccountTypeGlobalClass implements Database.batchable<Sobject>,Schedulable {
    
    
    global Database.QueryLocator start(database.batchablecontext bc){
        
        string query = 'SELECT Id, Name, Type, ParentId FROM Account';
        return Database.getQueryLocator(query);
    }
    
    global void execute(database.batchablecontext bc, List<Sobject> scope){
        
        List<Account> acc = scope;
        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account a : acc) {
                
                if(a.ParentId == NULL){
                a.Type = 'Headquarters';
                
            }
            else{
                
                a.Type = 'Branch';
                
            }
            accountsToUpdate.add(a);
            
        }
        update accountsToUpdate;
    }
    
    global void finish(database.batchablecontext bc)  {
        
    } 
    
     global void execute(Schedulablecontext sc)  {
         
         
         updateAccountTypeGlobalClass accountTypeUpdate = new updateAccountTypeGlobalClass();
         Database.executebatch(accountTypeUpdate);
         //Database.executebatch(new updateAccountTypeGlobalClass(), 200);
        
    } 
    
}