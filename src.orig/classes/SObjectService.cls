public class SObjectService {
    public class SObjectServiceException extends exception {  }
    
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
                fields.get(fieldname).put('label', fieldDescribe.getLabel());
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

    public static void doUpdate(String recordId, String sObjectName, List<Object> fields) {        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sObjectName);
        sObject sObjectToSave = targetType.newSobject(recordId);
        for (Object field : fields) {
            Map<String,Object> fieldInfo = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(field));            
            Map<String,Object> fieldProperties = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(fieldInfo.get('properties'))); 
            String fieldName = String.ValueOf(fieldInfo.get('name'));
            Boolean isUpdateable = Boolean.ValueOf(fieldProperties.get('isUpdateable'));
            if(isUpdateable) {
                Object valueObject = fieldProperties.get('value');
                String value = String.ValueOf(valueObject);
                String displayType = String.ValueOf(fieldProperties.get('displayType'));
                if (value == null || value == 'null') {
                    // skip sObjectToSave.put(fieldName,null);
                } else {    
                    if (displayType == 'DATE') {
                        sObjectToSave.put(fieldName, Date.valueOf(value));
                    } else if(displayType == 'DATETIME') {
                        sObjectToSave.put(fieldName, DateTime.valueOfGmt(value));
                    } else if (displayType == 'PERCENT' || displayType == 'CURRENCY') {
                        sObjectToSave.put(fieldName, value == '' ? null : Decimal.valueOf(value));
                    } else if (displayType == 'DOUBLE') {
                        sObjectToSave.put(fieldName, value == '' ? null : Double.valueOf(value));
                    } else if (displayType == 'INTEGER') {
                        sObjectToSave.put(fieldName, Integer.valueOf(value));
                    } else if (displayType == 'BASE64') {
                        sObjectToSave.put(fieldName, Blob.valueOf(value));
                    } else if (displayType == 'BOOLEAN') {
                        sObjectToSave.put(fieldName, Boolean.valueOf(value));
                    } else {
                        sObjectToSave.put(fieldName, value);
                    }
                }    
            }
        }
        try {
            update sObjectToSave;
        } catch (exception e) {
            throw new SObjectServiceException(e.getMessage());
        }
    }
}