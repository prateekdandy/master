global class CheckUpdateOpeningHoursSchedulableBatch implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts  {

    global void execute(SchedulableContext ctx){
        Database.executebatch(new CheckUpdateOpeningHoursSchedulableBatch(), 50);
    }
    
    global Database.Querylocator start(Database.BatchableContext bc){
        return Database.getQuerylocator([
            Select Id, Monday_Opening_Hours__c, Monday_Closing_Hours__c, Tuesday_Opening_Hours__c, Tuesday_Closing_Hours__c,
            Wednesday_Opening_Hours__c, Wednesday_Closing_Hours__c, Thursday_Opening_Hours__c, Thursday_Closing_Hours__c,
            Friday_Opening_Hours__c, Friday_Closing_Hours__c, Saturday_Opening_Hours__c, Saturday_Closing_Hours__c,
            Sunday_Opening_Hours__c, Sunday_Closing_Hours__c, UTCOffset__c, Google_Place_ID__c
            FROM Account
            WHERE Google_Place_ID__c != NULL
        ]);
    } 
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
        Map<Id,Account> updateAccountMap = new Map<Id,Account>();
        for(Account acc : scope){
            GooglePlaceAPIController.WeekdayOpeningHours openingHours = GooglePlaceAPIController.getOpeningHours(acc.Google_Place_ID__c);
            Account updatedAcc = AccountServices.populateOpeningHours(acc.Id,openingHours);
            
            if(acc.Monday_Opening_Hours__c != updatedAcc.Monday_Opening_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Monday_Closing_Hours__c != updatedAcc.Monday_Closing_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Tuesday_Opening_Hours__c != updatedAcc.Tuesday_Opening_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Tuesday_Closing_Hours__c != updatedAcc.Tuesday_Closing_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Wednesday_Opening_Hours__c != updatedAcc.Wednesday_Opening_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Wednesday_Closing_Hours__c != updatedAcc.Wednesday_Closing_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Thursday_Opening_Hours__c != updatedAcc.Thursday_Opening_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Thursday_Closing_Hours__c != updatedAcc.Thursday_Closing_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Friday_Opening_Hours__c != updatedAcc.Friday_Opening_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Friday_Closing_Hours__c != updatedAcc.Friday_Closing_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Saturday_Opening_Hours__c != updatedAcc.Saturday_Opening_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Saturday_Closing_Hours__c != updatedAcc.Saturday_Closing_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Sunday_Opening_Hours__c != updatedAcc.Sunday_Opening_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.Sunday_Closing_Hours__c != updatedAcc.Sunday_Closing_Hours__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            if(acc.UTCOffset__c != updatedAcc.UTCOffset__c){
                updateAccountMap.put(acc.Id,updatedAcc);
            }
            
        }
        if(!updateAccountMap.isEmpty()){
            List<Database.SaveResult> updateResult = Database.update(updateAccountMap.values(), false);
            string header = 'Account Id, Record Update Successfully, Error \n';
            string finalstr = header ;
            for(Integer i = 0 ;i < updateResult.size() ; i++){
                Account acc = updateAccountMap.values().get(i);
                string recordString = acc.id+',';
                if(updateResult[i].isSuccess()){
                    recordString += 'true,\n';
                }else{
                    for(Database.Error err : updateResult[i].getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('Account fields that affected this error: ' + err.getFields());
                        recordString += 'false,' + err.getMessage().escapeCSV() + ' Fields: ' + err.getFields()+ '\n';
                    }
                }
                finalstr = finalstr +recordString;
            }
            Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
            blob csvBlob = Blob.valueOf(finalstr);
            string csvname= 'UpdatedAccount.csv';
            csvAttc.setFileName(csvname);
            csvAttc.setBody(csvBlob);
            Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
            String[] toAddresses = new list<string>();
            toAddresses.addAll(System.Label.Google_Place_API_Email_Recipient.split(','));
            String subject ='Opening Hours Updated';
            email.setSubject(subject);
            email.setToAddresses( toAddresses );
            String body = 'Hi<br/>';
            body += 'Opening Hours Updated. Please see the attached file containing list of updated accounts.<br/>';
            body += 'Thanks!';
            email.setHtmlBody(body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
            if(!Test.isRunningTest())
                Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status FROM AsyncApexJob WHERE Id = :bc.getJobId()]; 
        System.debug('>>>> finish ' + job.Status);
    }
}