public  class ChildCountHandler {
    
    //Call below method After Insert of Account Trigger
    public static void updateAccountCount(List<Account> lstNewAccount){
        List<Account> lstParentAccountToUpdate = new List<Account> ();
        Set<Id> setParentAccId = new Set<Id>();
        for(Account objAcc: [Select Id,ParentId from Account Where ParentId != Null AND ID IN:lstNewAccount]){
            setParentAccId.add(objAcc.ParentId);
        }
        if(!setParentAccId.isEmpty()){
            Map<Id,Integer> mapAccountIdWithChilds = new Map<Id,Integer>();
            for(Account objAcc:[Select Id,ParentId from Account Where ParentId != Null AND ParentId IN:setParentAccId]){
                if(mapAccountIdWithChilds.containsKey(objAcc.ParentId)){
                    integer count = mapAccountIdWithChilds.get(objAcc.ParentId);
                    count = count+1; 
                    mapAccountIdWithChilds.put(objAcc.ParentId,count);
                }else{
                    mapAccountIdWithChilds.put(objAcc.ParentId,1);
                }                
            }           
            if(!mapAccountIdWithChilds.isEmpty()){
                for(id objAccId:mapAccountIdWithChilds.keySet()){
                    Account objAcc = new Account();
                    objAcc.id = objAccId;
                    objAcc.Num_Locations__c = mapAccountIdWithChilds.get(objAccId);
                    lstParentAccountToUpdate.add(objAcc);
                }
                if(!lstParentAccountToUpdate.isEmpty()){                    
                    Database.update(lstParentAccountToUpdate,false);
                }	
            }            
        }        
    }
    
    //Call below method After Upadte of Account Trigger
    public static void updateAccountCountonUpdate(List<Account> lstNewAccount,Map<Id,Account> mapOldAccount){
        Set<Id> setParentAccId = new Set<Id>();
        List<Account> lstParentAccountToUpdate = new List<Account> ();
        for(Account objAcc:lstNewAccount){
            if(objAcc.ParentId != mapOldAccount.get(objAcc.Id).ParentId){
                if(objAcc.ParentId != Null){
                    setParentAccId.add(objAcc.ParentId);
                }               
                if(mapOldAccount.get(objAcc.Id).ParentId != Null){
                    setParentAccId.add(mapOldAccount.get(objAcc.Id).ParentId); 
                }                
            }
        }
        if(!setParentAccId.isEmpty()){
            System.debug('setParentAccId==> '+setParentAccId);
            Map<Id,Integer> mapAccountIdWithChilds = new Map<Id,Integer>();
            for(Account objAcc:[Select Id,ParentId from Account Where ParentId != Null AND ParentId IN:setParentAccId]){
                if(mapAccountIdWithChilds.containsKey(objAcc.ParentId)){
                    integer count = mapAccountIdWithChilds.get(objAcc.ParentId);
                    count = count+1; 
                    mapAccountIdWithChilds.put(objAcc.ParentId,count);
                }else{
                    mapAccountIdWithChilds.put(objAcc.ParentId,1);
                }                
            }           
            if(!mapAccountIdWithChilds.isEmpty()){
                for(id objAccId:mapAccountIdWithChilds.keySet()){
                    Account objAcc = new Account();
                    objAcc.id = objAccId;
                    objAcc.Num_Locations__c = mapAccountIdWithChilds.get(objAccId);
                    lstParentAccountToUpdate.add(objAcc);
                }
                if(!lstParentAccountToUpdate.isEmpty()){                    
                    Database.update(lstParentAccountToUpdate,false);
                }	
            }
        }
        
    }
    
    
}