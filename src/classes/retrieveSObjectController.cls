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
            response.values.put('isUserAdmin',checkPermissions());
            response.message  = (String)result.get('sObjectName');
            return response;
        } catch (exception e) {
            return new AuraActionResponse(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean checkPermissions() {
        Boolean isUserAdmin = false;
            User u = [SELECT Id, Profile.PermissionsModifyAllData, Profile.PermissionsViewAllData FROM User WHERE Id = :UserInfo.getUserId()];
            if(u.Profile.PermissionsModifyAllData && u.Profile.PermissionsViewAllData) {
                isUserAdmin = true;
            }
        return isUserAdmin;    
    }

    @AuraEnabled
    public static AuraActionResponse updatesObject(String recordId, String sObjectName, String fieldsJSON) {
        AuraActionResponse response = new AuraActionResponse();
        try {
            List<Object> fields = (List<Object>)JSON.deserializeUntyped(fieldsJSON);
            SObjectService.doUpdate(recordId, sObjectName, fields);
            response.isSuccess = true;
            response.message = 'Saved ' + sObjectName + ' successfully';
        } catch (exception e) {
            response.isSuccess = false;
            response.message = e.getMessage();
        }
        return response; 
    }

}