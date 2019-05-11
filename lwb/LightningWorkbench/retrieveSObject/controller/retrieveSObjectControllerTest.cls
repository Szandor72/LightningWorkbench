@isTest
public class retrieveSObjectControllerTest {
    @istest
    public static void retrieveSObject_Error(){
        String strId = 'BogusId';
        AuraActionResponse response = retrieveSObjectController.retrieveSObject(strId);
        System.Assert(!String.isEmpty(response.message),'There must be a message in the response' );
    }

    @istest
    public static void retrieveSObject_Success(){
        Account myAccount = new Account(name = 'appero.com');
        insert myAccount; 
        AuraActionResponse response = retrieveSObjectController.retrieveSObject(myAccount.Id);
        System.Assert(!String.isEmpty(response.message),'There must be a message in the response' );
    }

    @isTest
    public static void updatesObject() {
        Account myAccount = new Account(name = 'appero.com');
        insert myAccount; 
        AuraActionResponse response = retrieveSObjectController.updatesObject(myAccount.Id, 'Account', '');
        System.Assert(!String.isEmpty(response.message),'There must be a message in the response' );
    }
}