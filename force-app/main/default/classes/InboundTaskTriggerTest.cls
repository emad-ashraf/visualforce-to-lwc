@isTest
private class InboundTaskTriggerTest {

    @testSetup
    static void setup() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = acc.Id
        );
        insert con;
    }

    @isTest
    static void testInboundTaskCreatesCase() {
        Contact con = [SELECT Id FROM Contact LIMIT 1];

        Test.startTest();
        insert new Task(
            Subject = 'Inbound Call',
            Status = 'Completed',
            Priority = 'Normal',
            WhoId = con.Id
        );
        Test.stopTest();

        List<Case> cases = [SELECT Id FROM Case WHERE ContactId = :con.Id];
        System.assertEquals(1, cases.size(), 'A Case should be created');
    }

    @isTest
    static void testNonInboundTaskDoesNotCreateCase() {
        Contact con = [SELECT Id FROM Contact LIMIT 1];

        Test.startTest();
        insert new Task(
            Subject = 'Outbound Call',
            Status = 'Completed',
            Priority = 'Normal',
            WhoId = con.Id
        );
        Test.stopTest();

        List<Case> cases = [SELECT Id FROM Case WHERE ContactId = :con.Id];
        System.assertEquals(0, cases.size(), 'No Case should be created');
    }

    @isTest
    static void testInboundTaskWithExistingOpenCase() {
        Contact con = [SELECT Id, AccountId FROM Contact LIMIT 1];

        // Pre-existing open case — trigger should NOT create another
        insert new Case(
            ContactId = con.Id,
            AccountId = con.AccountId,
            Status = 'New',
            Origin = 'Phone'
        );

        Test.startTest();
        insert new Task(
            Subject = 'Inbound Call',
            Status = 'Completed',
            Priority = 'Normal',
            WhoId = con.Id
        );
        Test.stopTest();

        List<Case> cases = [SELECT Id FROM Case WHERE ContactId = :con.Id];
        System.assertEquals(1, cases.size(), 'Still only 1 case — no duplicate');
    }
}