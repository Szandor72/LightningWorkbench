public with sharing class retrieveSObjectController {
    @AuraEnabled
    public static AuraActionResponse retrieveSObject(String recordId){
        try {
            Map<String,Object> result = new Map<String,Object>();
            result = SobjectService.retrieve(recordId);
            AuraActionResponse response = new  AuraActionResponse();
            response.values.put('sObjectName',result.get('sObjectName'));
            response.values.put('lastModifiedBy',result.get('lastModifiedBy'));
            response.values.put('lastModifiedDate',result.get('lastModifiedDate'));
            response.values.put('fields', JSON.serialize(result.get('fields')));
            response.message  = (String)result.get('sObjectName');
            return response;
        } catch (exception e) {
            return new AuraActionResponse(e.getMessage());
        }
    }

}