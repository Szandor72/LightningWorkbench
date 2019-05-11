public class RESTCall {
    public static void callOut() {
        //Make sure your Salesforce instance URL is added in remote site settings
        String sfdcURL = URL.getOrgDomainUrl().toExternalForm(); 
        String restAPIURL = sfdcURL + '/services/data/v45.0/sobjects';  
        
        HttpRequest request = new HttpRequest();  
        request.setMethod('GET');   
        request.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());        
        request.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); 
        request.setEndpoint(restAPIURL);  
        String response = '';
        try {  
            Http http = new Http();   
            HttpResponse httpResponse = http.send(request);  
            if (httpResponse.getStatusCode() == 200 ) {  
                response = JSON.serializePretty( JSON.deserializeUntyped(httpResponse.getBody()) );  
            } else {  
                
                throw new CalloutException( httpResponse.getBody() );  
            }   
        } catch( System.Exception e) {  
            System.debug('ERROR: '+ e);  
            throw e;  
        } 
        
        List<String> responseSubstrings = splitToSubstrings(response, 131000);
        
        
        Response__e responseEvent = new Response__e();
        
        responseEvent.payload__c = responseSubstrings[0];
        
        if (responseSubstrings.size()>1) {
            for (Integer i = 1; i < responseSubstrings.size(); i++) {
                String suffix = String.valueOf(i);
                String fieldName = 'szDev__continuedPayload'+suffix+'__c';
                responseEvent.put(fieldName, responseSubstrings[i]);
            }
        }
        
        
        Database.SaveResult publishResult = EventBus.publish(responseEvent);
        system.assert(publishResult.isSuccess(), 'Error on PE Insert');
        //System.debug(' ** response ** : ' + response ); 
    }
    
    @future(callout=true)
    public static void futureCallOut() {
        callOut(); 
    }
    
    @AuraEnabled
    public static void lightningCallout() {
        //callout();
        futureCallout();
    }
    
    private static List<String> splitToSubstrings(String input, Integer maxLength) {
        
        Integer lengthOfInput = input.length();
        Integer chunks = Integer.valueOf(Math.ceil(lengthOfInput/maxLength));
        List<String> outputStrings = new List<String>();
        
        if (input == null 
            || maxLength == null 
            || maxLength == 0 
            || maxLength < 0) {
            return outputstrings;
        }
        
        if (input.length() < maxLength) {
            outputStrings.add(input);
            return outputstrings;
        }
        
        for (Integer i = 0; i <= chunks; i++) {
            Integer startPosition = i * maxLength;
            Integer endPosition = (i+1)*maxLength > lengthOfInput ? lengthOfInput : (i+1)*maxLength;
            String currentToken = input.substring(startPosition, endPosition);
            outputStrings.add(currentToken);
        }
        Integer checkSum = 0;
        for (String chunk : outputStrings) {
            checkSum += chunk.length();
        }
        system.assertEquals(lengthOfInput, checkSum,'Glued toegther, the string is as long as the original');
        return outputStrings;
    }
}