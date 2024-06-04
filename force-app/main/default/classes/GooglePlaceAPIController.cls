public class GooglePlaceAPIController{
    @auraEnabled
    public static List<SearchPlaceResponse> searchPlaceFromText(String searchString){
        List<SearchPlaceResponse> placesList = new List<SearchPlaceResponse>();
        String error = '';
        try{
            HttpResponse res = GoogleServices.serachPlaces(searchString,null,null);
            if(res.getStatusCode() == 200){
                GooglePlaceTextSearchResponseWrapper response = GooglePlaceTextSearchResponseWrapper.parse(res.getBody());
                if(response.status == 'OK'){
                    for(GooglePlaceTextSearchResponseWrapper.cls_results placeInfo :  response.results){
                        SearchPlaceResponse place = new SearchPlaceResponse();
                        place.placeName = placeInfo.name;
                        place.formattedAddress = placeInfo.formatted_address;
                        place.placeId = placeInfo.place_id;
                        place.business_status = placeInfo.business_status;
                        System.debug(place);
                        placesList.add(place);
                    }
                }else{
                    System.debug('Callout Error! Status: ' + response.status +' .Error: ' + response.error_message);
                    error = 'Callout Error! Status: ' + response.status +' .Error: ' + response.error_message;
                    throw new AuraHandledException('Callout Error! Status: ' + response.status +' .Error: ' + response.error_message);
                }
            }else{
                System.debug('Callout Failure! Status: ' + res.getStatus() + '. Error Response: ' + res.getBody());
                error = 'Callout Failure! Status: ' + res.getStatus() + '. Error Response: ' + res.getBody();
                throw new AuraHandledException('Callout Failure! Status: ' + res.getStatus() + '. Error Response: ' + res.getBody());
            }
        }catch(Exception e){
            System.debug('Exception: ' + e.getMessage() + ' On line number: ' + e.getLineNumber());
            throw new AuraHandledException(error != '' ? error : ('Exception: ' + e.getMessage() + ' On line number: ' + e.getLineNumber()));
        }
        return placesList;
    }
    
    @auraEnabled
    public static WeekdayOpeningHours getOpeningHours(String placeId){
        WeekdayOpeningHours openingHours = new WeekdayOpeningHours();
        String error = '';
        try{
            HttpResponse res = GoogleServices.getPlaceDetails(placeId);
            if(res.getStatusCode() == 200){
                GooglePlaceDetailWrapper response = new GooglePlaceDetailWrapper(System.JSON.createParser(res.getBody()));
                if(response.status == 'OK'){
                    openingHours.placeDetails = response.Result;
                    openingHours.utcOffSet = String.valueOf(response.Result.utc_offset);
                    if(response.Result != null && response.Result.Opening_hours != null && !response.Result.Opening_hours.weekday_text.isEmpty()){
                        
                        for(String weekdayHours: response.Result.Opening_hours.weekday_text){
                            if(weekdayHours.contains('Monday') && weekdayHours.substringAfter('Monday:').trim() != 'Closed'){
                                openingHours.mondayOpen = (weekdayHours.substringAfter('Monday:').trim()).substringBefore('–').trim();
                                openingHours.mondayClose = weekdayHours.substringAfter('–').trim();
                            }
                            if(weekdayHours.contains('Tuesday')  && weekdayHours.substringAfter('Tuesday:').trim() != 'Closed'){
                                openingHours.tuesdayOpen = weekdayHours.substringAfter('Tuesday:').trim().substringBefore('–').trim();
                                openingHours.tuesdayClose = weekdayHours.substringAfter('–').trim();
                            }
                            if(weekdayHours.contains('Wednesday')  && weekdayHours.substringAfter('Wednesday:').trim() != 'Closed'){
                                openingHours.wednesdayOpen = weekdayHours.substringAfter('Wednesday:').trim().substringBefore('–').trim();
                                openingHours.wednesdayClose = weekdayHours.substringAfter('–').trim();
                            }
                            if(weekdayHours.contains('Thursday')  && weekdayHours.substringAfter('Thursday:').trim() != 'Closed'){
                                openingHours.thursdayOpen = weekdayHours.substringAfter('Thursday:').trim().substringBefore('–').trim();
                                openingHours.thursdayClose = weekdayHours.substringAfter('–').trim();
                            }
                            if(weekdayHours.contains('Friday')  && weekdayHours.substringAfter('Friday:').trim() != 'Closed'){
                                openingHours.fridayOpen = weekdayHours.substringAfter('Friday:').trim().substringBefore('–').trim();
                                openingHours.fridayClose = weekdayHours.substringAfter('–').trim();
                            }
                            if(weekdayHours.contains('Saturday')  && weekdayHours.substringAfter('Saturday:').trim() != 'Closed'){
                                openingHours.saturdayOpen = weekdayHours.substringAfter('Saturday:').trim().substringBefore('–').trim();
                                openingHours.saturdayClose = weekdayHours.substringAfter('–').trim();
                            }
                            if(weekdayHours.contains('Sunday')  && weekdayHours.substringAfter('Sunday:').trim() != 'Closed'){
                                openingHours.sundayOpen = weekdayHours.substringAfter('Sunday:').trim().substringBefore('–').trim();
                                openingHours.sundayClose = weekdayHours.substringAfter('–').trim();
                            }
                        }
                        System.debug('openingHours--> ' + openingHours);
                    }else{
                        System.debug('No Opening Hours Found! Here\'s complete response: ' + response);
                        error = 'No Opening Hours Found!';
                        throw new AuraHandledException('No Opening Hours Found!');
                    }
                }else{
                    System.debug('Callout Error! Status: ' + response.status +' .Error: ' + response.error_message);
                    error = 'Callout Error! Status: ' + response.status +' .Error: ' + response.error_message;
                    throw new AuraHandledException('Callout Error! Status: ' + response.status +' .Error: ' + response.error_message);
                }
            }else{
                System.debug('Callout Failure! Status: ' + res.getStatus() + '. Error Response: ' + res.getBody());
                error = 'Callout Failure! Status: ' + res.getStatus() + '. Error Response: ' + res.getBody();
                throw new AuraHandledException('Callout Failure! Status: ' + res.getStatus() + '. Error Response: ' + res.getBody());
            }
        }catch(Exception e){
            System.debug('Exception: ' + e.getMessage() + ' On line number: ' + e.getLineNumber());
            throw new AuraHandledException(error != '' ? error : ('Exception: ' + e.getMessage() + ' On line number: ' + e.getLineNumber()));
        }
        return openingHours;
    }
    
    public class SearchPlaceResponse{
        @auraEnabled public String placeName;
        @auraEnabled public String formattedAddress;
        @auraEnabled public String placeId;
        @auraEnabled public String business_status;
        public SearchPlaceResponse(){
        
        }
    }
    
    public class WeekdayOpeningHours{
        @auraEnabled public String sundayOpen = '';
        @auraEnabled public String mondayOpen = '';
        @auraEnabled public String tuesdayOpen = '';
        @auraEnabled public String wednesdayOpen = '';
        @auraEnabled public String thursdayOpen = '';
        @auraEnabled public String fridayOpen = '';
        @auraEnabled public String saturdayOpen = '';
        @auraEnabled public String sundayClose = '';
        @auraEnabled public String mondayClose = '';
        @auraEnabled public String tuesdayClose = '';
        @auraEnabled public String wednesdayClose = '';
        @auraEnabled public String thursdayClose = '';
        @auraEnabled public String fridayClose = '';
        @auraEnabled public String saturdayClose = '';        
        @auraEnabled public String utcOffSet = '';
        @auraEnabled public GooglePlaceDetailWrapper.result placeDetails;
        public WeekdayOpeningHours(){
        
        }
    }
}