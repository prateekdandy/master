public class SlackApiNotification {
    /*@future (callout=true)
    public static void sendOppNotificationToSlack(String OppId) {
        API_Integration__c slackNotification = API_Integration__c.getInstance('Slack API');
        if(!slackNotification.Endpoint__c.isWhitespace()){
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            HttpResponse res = new HttpResponse();
            req.setMethod('POST');
            req.setEndpoint(slackNotification.Endpoint__c);
            system.debug(slackNotification.Endpoint__c);
            req.setBody(getBodyToRequest(OppId, 'The following opportunity has changed'));
            res = http.send(req);
            if(res.getStatusCode() != 200){
                //throw new CalloutException('Code: ' + res.getStatusCode() + ' - Body: ' + res.getBody());
            }
        }else{
            //throw new CalloutException('The Slack Credentials aren´t in the System');
        }
    }*/
    
    @future (callout=true)
    public static void sendErrorNotificationToSlack(String OppId) {
        API_Integration__c slackNotification = API_Integration__c.getInstance('Slack API');
        if(!slackNotification.Endpoint__c.isWhitespace()){
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            HttpResponse res = new HttpResponse();
            req.setMethod('POST');
            req.setEndpoint(slackNotification.Endpoint__c);
            system.debug(slackNotification.Endpoint__c);
            req.setBody(getBodyToRequest(OppId, 'Error Sending to Nest'));
            res = http.send(req);
            if(res.getStatusCode() != 200){
                //throw new CalloutException('Code: ' + res.getStatusCode() + ' - Body: ' + res.getBody());
            }
        }else{
            //throw new CalloutException('The Slack Credentials aren´t in the System');
        }
    }

    private static String getBodyToRequest(String OppId, String ErrorMessage){
        Map<String,Object> msg = new Map<String,Object>();
        msg.put('text', ErrorMessage + ' : <https://meetdandy.lightning.force.com/lightning/r/Opportunity/'+OppId+'/view|Opportunity Link>');
        return JSON.serialize(msg);
    }
    
}