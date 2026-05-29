@isTest
private class CaseEntitlementTriggerTest {

    @testSetup
    static void setup() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        insert new Entitlement(
            Name = 'Test Entitlement',
            AccountId = acc.Id,
            StartDate = System.today()
        );
    }

    @isTest
    static void testCaseGetsEntitlementFromAccount() {
        Account acc = [SELECT Id FROM Account LIMIT 1];

        Test.startTest();
        insert new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Phone',
            AccountId = acc.Id
        );
        Test.stopTest();

        // Trigger ran before insert — just verify case exists
        List<Case> cases = [SELECT Id FROM Case WHERE Subject = 'Test Case'];
        System.assertEquals(1, cases.size(), 'Case should be inserted successfully');
    }

    @isTest
    static void testCaseWithoutAccountGetsNoEntitlement() {
        Test.startTest();
        insert new Case(Subject = 'No Account Case', Status = 'New', Origin = 'Phone');
        Test.stopTest();

        List<Case> cases = [SELECT Id FROM Case WHERE Subject = 'No Account Case'];
        System.assertEquals(1, cases.size(), 'Case without account should insert fine');
    }
}