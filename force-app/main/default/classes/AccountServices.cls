public class AccountServices{
    @auraEnabled
    public static void savePlaceOpeningHours(String recordId, String openingHoursJSON){
        try{
            
            GooglePlaceAPIController.WeekdayOpeningHours openingHours = (GooglePlaceAPIController.WeekdayOpeningHours)system.JSON.deserializeStrict(openingHoursJSON, GooglePlaceAPIController.WeekdayOpeningHours.class);
            if(((Id)recordId).getSObjectType().getDescribe().getName() == 'Account'){
                Account acc = populateOpeningHours(recordId, openingHours);
                update acc;
            }else if(((Id)recordId).getSObjectType().getDescribe().getName() == 'Onboarding__c'){
                List<Onboarding__c> onboardingRecord = [Select Account_Name__c from Onboarding__c where Id =: recordId and Account_Name__c != NULL];    
                if(!onboardingRecord.isEmpty()){
                    Account acc = populateOpeningHours(onboardingRecord[0].Account_Name__c, openingHours);
                    update acc;    
                }
            }
            
        }catch(Exception e){
            System.debug('Exception: ' + e.getMessage() + ' On line number: ' + e.getLineNumber());
            throw new AuraHandledException(('Exception: ' + e.getMessage() + ' On line number: ' + e.getLineNumber()));
        }
    }
    
    public static Time convertStringToTime(String stringTime){
        
     stringTime = stringTime.replaceAll('\u202f', '').replaceAll('\u2009', '');
     
        Integer hour = stringTime.contains('AM') ?
            Integer.valueOf(stringTime.subStringBefore(':')) : 
           (Integer.valueOf(stringTime.subStringBefore(':')) != 12 ? Integer.valueOf(stringTime.subStringBefore(':')) + 12 : Integer.valueOf(stringTime.subStringBefore(':')));
       
        
        Integer m=0;
        
        if(stringTime.subStringAfter(':').subStringBefore(' ') == '00AM' || stringTime.subStringAfter(':').subStringBefore(' ') =='00PM'){
           m=0;
           return Time.newInstance(hour,m, 0, 0);
        }
         if(stringTime.subStringAfter(':').subStringBefore(' ') == '15AM' || stringTime.subStringAfter(':').subStringBefore(' ') =='15PM'){
           m=15;
           return Time.newInstance(hour,m, 0, 0);
        }
         if(stringTime.subStringAfter(':').subStringBefore(' ') == '30AM' || stringTime.subStringAfter(':').subStringBefore(' ') =='30PM'){
           m=30;
           return Time.newInstance(hour,m, 0, 0);
        }
         else{
           m=45;
           return Time.newInstance(hour,m, 0, 0);
        }
                       
    }
    
    public static Account populateOpeningHours(String accountId, GooglePlaceAPIController.WeekdayOpeningHours openingHours){
        Account acc = new Account(Id = accountId);
            
        acc.Monday_Opening_Hours__c = openingHours.mondayOpen == 'Open 24 hours' ? Time.newInstance(0,0, 0, 0) : 
            (openingHours.mondayOpen == '' ? null : convertStringToTime(openingHours.mondayOpen));
        acc.Tuesday_Opening_Hours__c = openingHours.tuesdayOpen == 'Open 24 hours' ? Time.newInstance(0,0, 0, 0) : 
            (openingHours.tuesdayOpen == '' ? null : convertStringToTime(openingHours.tuesdayOpen));
        acc.Wednesday_Opening_Hours__c = openingHours.wednesdayOpen == 'Open 24 hours' ? Time.newInstance(0,0, 0, 0) : 
            (openingHours.wednesdayOpen == '' ? null : convertStringToTime(openingHours.wednesdayOpen));
        acc.Thursday_Opening_Hours__c = openingHours.thursdayOpen == 'Open 24 hours' ? Time.newInstance(0,0, 0, 0) : 
            (openingHours.thursdayOpen == '' ? null : convertStringToTime(openingHours.thursdayOpen));
        acc.Friday_Opening_Hours__c = openingHours.fridayOpen == 'Open 24 hours' ? Time.newInstance(0,0, 0, 0) : 
            (openingHours.fridayOpen == '' ? null : convertStringToTime(openingHours.fridayOpen));
        acc.Saturday_Opening_Hours__c = openingHours.saturdayOpen == 'Open 24 hours' ? Time.newInstance(0,0, 0, 0) : 
            (openingHours.saturdayOpen == '' ? null : convertStringToTime(openingHours.saturdayOpen));
        acc.Sunday_Opening_Hours__c = openingHours.sundayOpen == 'Open 24 hours' ? Time.newInstance(0,0, 0, 0) : 
            (openingHours.sundayOpen == '' ? null : convertStringToTime(openingHours.sundayOpen));
            
        acc.Monday_Closing_Hours__c = openingHours.mondayOpen == 'Open 24 hours' ? Time.newInstance(23,59, 59, 0) : 
            (openingHours.mondayClose == '' ? null : convertStringToTime(openingHours.mondayClose));
        acc.Tuesday_Closing_Hours__c = openingHours.tuesdayOpen == 'Open 24 hours' ? Time.newInstance(23,59, 59, 0) :
            (openingHours.tuesdayClose == '' ? null : convertStringToTime(openingHours.tuesdayClose));
        acc.Wednesday_Closing_Hours__c = openingHours.wednesdayOpen == 'Open 24 hours' ? Time.newInstance(23,59, 59, 0) :
            (openingHours.wednesdayClose == '' ? null : convertStringToTime(openingHours.wednesdayClose));
        acc.Thursday_Closing_Hours__c = openingHours.thursdayOpen == 'Open 24 hours' ? Time.newInstance(23,59, 59, 0) :
            (openingHours.thursdayClose == '' ? null : convertStringToTime(openingHours.thursdayClose));
        acc.Friday_Closing_Hours__c = openingHours.fridayOpen == 'Open 24 hours' ? Time.newInstance(23,59, 59, 0) :
            (openingHours.fridayClose == '' ? null : convertStringToTime(openingHours.fridayClose));
        acc.Saturday_Closing_Hours__c = openingHours.saturdayOpen == 'Open 24 hours' ? Time.newInstance(23,59, 59, 0) :
            (openingHours.saturdayClose == '' ? null : convertStringToTime(openingHours.saturdayClose));
        acc.Sunday_Closing_Hours__c = openingHours.sundayOpen == 'Open 24 hours' ? Time.newInstance(23,59, 59, 0) :
            (openingHours.sundayClose == '' ? null : convertStringToTime(openingHours.sundayClose));
            
        acc.UTCOffset__c =  openingHours.utcOffSet;  
        acc.Google_Place_ID__c = openingHours.placeDetails.place_id;
        System.debug('acc-->' + acc);
        
        return acc;
    }
}