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

}