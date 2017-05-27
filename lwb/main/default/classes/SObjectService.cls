public class SObjectService {
    public class SObjectServiceException extends exception {  }

    @AuraEnabled
    public static Map<String,Object> retrieve(String recordId) {
        if(!(recordId instanceOf Id)) {
            throw new SobjectServiceException('Not a valid sObject Id');
        }
        Id sobjectId = recordId;
        Schema.DescribeSobjectResult sObjectDescribe = sobjectId.getSObjectType().getDescribe();
        String strSobjectName = sObjectDescribe.getName();
        if(Database.query('Select id From '+strSobjectName+' where id =: recordId').size()==0) {
            throw new SobjectServiceException('There is no '+strSobjectName+' with id '+recordId+'.');
        }
        Map<String,Schema.SObjectField> fieldsMap = sObjectDescribe.fields.getMap();
        // fields = Map<fieldname, Map<attributename, value>>
        Map<String,Map<String,Object>> fields = new Map<String,Map<String,Object>>();
        for(String key:fieldsMap.keySet()) {
            Schema.DescribeFieldResult fieldDescribe = fieldsMap.get(key).getDescribe();
            if(fieldDescribe.isAccessible()) {
                String fieldName = fieldDescribe.getName();
                fields.put(fieldname, new Map<String,Object>());
                fields.get(fieldname).put('displayType', fieldDescribe.getType());
                if (fieldDescribe.getType() == Schema.DisplayType.PICKLIST) {
                    fields.get(fieldname).put('picklistValues', fieldDescribe.getPicklistValues());
                }
                fields.get(fieldname).put('isUpdateable', fieldDescribe.isUpdateable());
            }
        }
        String strCommaSeperatedFieldnames = '';
        for (String strFieldname : fields.keySet()) {
            strCommaSeperatedFieldnames += strFieldname + ',';
        }
        strCommaSeperatedFieldnames += 'LastModifiedBy.Name';
        sObject resultSobject = Database.query('Select '+strCommaSeperatedFieldnames+' FROM '+strSobjectName+' WHERE Id =: recordId' );
        Map<String,Object> valueMap = resultSObject.getPopulatedFieldsAsMap();
        for(String fieldName : valueMap.keySet()) {
            if(fields.get(fieldname)!=null) {
                fields.get(fieldname).put('value',valueMap.get(fieldName));
            }
        }
        Map<String,Object> result = new Map<String,Object>();
        result.put('lastModifiedBy', ((User)valueMap.get('LastModifiedBy')).Name);
        result.put('lastModifiedDate', valueMap.get('LastModifiedDate'));
        result.put('sObjectName', strSobjectName);
        result.put('fields', fields);
        return result;
    }
}