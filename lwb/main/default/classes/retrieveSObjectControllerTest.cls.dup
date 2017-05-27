@isTest
public class retrieveSObjectControllerTest {
    @istest
    public static void retrieveSObject(){
        String strId = 'BogusId';
        AuraActionResponse response = retrieveSObjectController.retrieveSObject(strId);
        retrieveSObjectController.checkSettings();
        System.Assert(!String.isEmpty(response.message),'There must be a message in the response' );
    }
}