@isTest
private class UpdateRelatedCasesFromIncidentsTest {

    @testSetup
    static void setup() {
        Case c = new Case(Subject = 'Test Case', Status = 'New', Origin = 'Phone');
        insert c;

        Incident incident = new Incident(Subject = 'Test Incident', Status = 'New');
        insert incident;

        CaseRelatedIssue cri = new CaseRelatedIssue(
            CaseId = c.Id,
            RelatedIssueId = incident.Id
        );
        insert cri;
    }

    @isTest
    static void testResolvedIncidentUpdatesCaseToSolved() {
        Incident incident = [SELECT Id FROM Incident LIMIT 1];
        Test.startTest();
        incident.Status = 'Resolved';
        update incident;
        Test.stopTest();

        Case c = [SELECT Status FROM Case LIMIT 1];
        System.assertEquals('Solved', c.Status, 'Case should be Solved');
    }

    @isTest
    static void testCompletedIncidentUpdatesCaseToClosed() {
        Incident incident = [SELECT Id FROM Incident LIMIT 1];
        Test.startTest();
        incident.Status = 'Completed';
        update incident;
        Test.stopTest();

        Case c = [SELECT Status FROM Case LIMIT 1];
        System.assertEquals('Closed', c.Status, 'Case should be Closed');
    }
}