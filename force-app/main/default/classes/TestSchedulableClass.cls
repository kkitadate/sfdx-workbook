@isTest
private class TestSchedulableClass {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    @isTest static void test() {
        
        // CRON expression: midnight on March 15.
        // Because this is a test, job executes
        // immediately after Test.stopTest().    
        Test.startTest();

        // Schedule the test job
        String jobId = System.schedule('ScheduleApexClassTest',
                            CRON_EXP,
                            new MySchedulableClass());

        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct.NextFireTime));
        // Verify the scheduled job hasn't run yet.
        Account[] al = [SELECT Id FROM Account
                        WHERE Name = 'Test Scheduled Acct'];
        System.assertEquals(al.size(), 0);

        Test.stopTest();

        // Now that the scheduled job has executed after Test.stopTest(),
        // fetch the new Account that got added.
        al = [SELECT Id FROM Account
                        WHERE Name = 'Test Scheduled Acct'];
        System.assertEquals(al.size(), 1);

    }
}