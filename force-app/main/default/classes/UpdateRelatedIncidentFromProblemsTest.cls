@isTest
private class UpdateRelatedIncidentFromProblemsTest {

    @testSetup
    static void setup() {
        Incident incident = new Incident(Subject = 'Test Incident', Status = 'New');
        insert incident;

        Problem problem = new Problem(Subject = 'Test Problem', Status = 'New');
        insert problem;

        ProblemIncident pi = new ProblemIncident(
            IssueId = problem.Id,
            RelatedIssueId = incident.Id
        );
        insert pi;
    }

    @isTest
    static void testResolvedProblemResolvesIncident() {
        Problem problem = [SELECT Id FROM Problem LIMIT 1];
        Test.startTest();
        problem.Status = 'Resolved';
        update problem;
        Test.stopTest();

        Incident incident = [SELECT Status FROM Incident LIMIT 1];
        System.assertEquals('Resolved', incident.Status, 'Incident should be Resolved');
    }

    @isTest
    static void testNonResolvedProblemDoesNotUpdateIncident() {
        Problem problem = [SELECT Id FROM Problem LIMIT 1];
        Test.startTest();
        problem.Status = 'In Progress';
        update problem;
        Test.stopTest();

        Incident incident = [SELECT Status FROM Incident LIMIT 1];
        System.assertEquals('New', incident.Status, 'Incident should remain New');
    }
}