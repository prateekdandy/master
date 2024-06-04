public class GoogleServices{
    private static final String findPlaceEndPoint = 'https://maps.googleapis.com/maps/api/place/textsearch/json';
    private static final String placeDetailsEndPoint = 'https://maps.googleapis.com/maps/api/place/details/json';
    
    public static HttpResponse serachPlaces(String searchText, String latitude, String longitude){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        String endPoint = findPlaceEndPoint;
        endPoint += '?&inputtype=textquery&fields=opening_hours,place_id,formatted_address,name,formatted_phone_number,url,website,icon,business_status,utc_offset';
        endPoint += '&query=' + EncodingUtil.urlEncode(searchText,'UTF-8');
        if(String.isNotBlank(latitude) && String.isNotBlank(longitude)){
            endPoint += '&location=' + latitude + ',' + longitude;
        }
        endPoint += '&key=' + Google_API_Settings__c.getOrgDefaults().API_Key__c;
        System.debug('endPoint --> ' + endPoint );
        
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        req.setTimeout(5000);
    
        HttpResponse res = h.send(req);
        return res;
        
    }
    
    public static HttpResponse getPlaceDetails(String placeId){
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        String endPoint = placeDetailsEndPoint;
        endPoint += '?fields=opening_hours,place_id,formatted_address,name,formatted_phone_number,url,website,icon,business_status,utc_offset,international_phone_number';
        endPoint += '&place_id=' + placeId;
        endPoint += '&key=' + Google_API_Settings__c.getOrgDefaults().API_Key__c;
        System.debug('endPoint --> ' + endPoint );
        
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        req.setTimeout(5000);
    
        HttpResponse res = h.send(req);
        return res;
    }
    
}