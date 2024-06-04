public without sharing class syncContactToPortalController {
    
    @AuraEnabled(Cacheable=true)
    public static void syncContactToPortal(String recordID) {
      
        System.debug('line1'+recordID);
        Contact con = [Select Id, AccountId, FirstName, LastName, Phone, Email, Portal_User_ID__c from Contact where id =:recordID];
        contactWrapper conWrap = new contactWrapper();
        conWrap.Id = con.Id;
        conWrap.AccountID = con.AccountId;
        conWrap.FirstName = con.FirstName;
        conWrap.LastName = con.LastName;
        conWrap.Phone = con.Phone;
        conWrap.Email = con.Email;
        
        string body = JSON.serialize(conWrap);
        
        System.debug('check'+conWrap);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    
        //Please set the endpoint of API gateway which we are going to create in later section
        request.setEndpoint('http://4a3f-71-187-61-157.ngrok.io/salesforce-zendesk/sync');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('APIKEY', 'asdj9439yahsdf97w9bf9a9we9u7r9w');
    
        // Set the body as a JSON object
        string res = '';

        request.setBody(body);
        System.debug('see'+body);
        HttpResponse response = http.send(request);
        System.debug('response==='+response.getBody());
    
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
            response.getStatusCode() + ' ' + response.getStatus());
        } else {
            res = response.getBody();
            con.Portal_User_ID__c = res;
            String currentUser = UserInfo.getName();
            con.Log_User__c = currentUser +' '+DateTime.now();
            Database.update(con);
            System.debug(response.getBody());
        }
    }

    public class contactWrapper {

     public String AccountID;
     public String Id;
     public String FirstName;
     public String LastName;
     public String Phone;
     public String Email;
    }
}