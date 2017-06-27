@isTest
public class SObjectServiceTest {
    @isTest
    public static void retrievebyID_Success() {
        Account a = new Account (Name = 'TestRetrieve');
        Exception ex;
        insert a;
        Map<String,Object> result = new Map<String,Object>();
        Test.startTest();
        try {
            result = SobjectService.retrieve(a.Id);
        }
        catch (exception e) {
            ex = e;
        }
        Test.stopTest();
        System.Assert(ex == null, 'No exceptions for valid transaction');
        System.Assert(result.keySet().size()>0, 'Values must be returned');
    }

    @isTest
    public static void retrievebyID_EX_NotAValidID() {
        Account a = new Account (Name = 'TestRetrieve');
        Exception ex;
        insert a;
        Test.startTest();
        try {
            SobjectService.retrieve(a.Id+'ABC');
        }
        catch (exception e) {
            ex = e;
        }
        Test.stopTest();
        System.Assert(ex != null, 'Exception thrown for invalid ID');
    }

    @isTest
    public static void retrievebyID_EX_NoObjectFound() {
        Account a = new Account (Name = 'TestRetrieve');
        Exception ex;
        insert a;
        delete a;
        Test.startTest();
        try {
            SobjectService.retrieve(a.Id);
        }
        catch (exception e) {
            ex = e;
        }
        Test.stopTest();
        System.Assert(ex != null, 'Exception thrown if no Object found by that Id');
    }

    

    @isTest
    public static void doUpdate_Success() {
        Account myAccount = new Account(Name = 'aero.com');
        insert myAccount; 
        Map<String,Object> result = SobjectService.retrieve(myAccount.Id);
        Map<String,Map<String,Object>> fieldResultMap = (Map<String,Map<String,Object>>)result.get('fields');
        List<object> fields = new List<object>();
        for (String fieldName : fieldResultMap.keyset()){
            Map<String,Object> mapInfo = new Map<String,Object>();
            
            Map<String,Object> mapProperties = new Map<String,Object>();
            
            Map<String,Object> propertyMap = fieldResultMap.get(fieldName);
                for(String key : propertyMap.keySet()) {
                    mapProperties.put(key, propertyMap.get(key));
                }
            mapInfo.put('name',fieldName);
            mapInfo.put('properties', mapProperties);
            fields.add(mapInfo);
            
        }
        String fieldsJSON = JSON.serialize(fields);
        String updatedJSON = fieldsJSON.replace('aero.com','appero.com');
        fields = (List<Object>)JSON.deserializeUntyped(updatedJSON);
        Test.startTest();
        SObjectService.doUpdate(myAccount.Id, 'Account', fields);
        Test.stopTest();

        Account assertAccount = [select id, name from Account where Id = :myAccount.Id];
        System.Assert(assertAccount.Name == 'appero.com','Update must change Account Name');
    }

}