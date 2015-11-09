@IsTest
private class MongoIntegrationBatch_TESTS {

@IsTest
private static void BatchCreationTest () {
 
MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/$cmd/?filter_count=answers&limit=1', 'CountJSON');
multimock.setStatusCode(200);

MongoDatabaseBatchHandler mdbh = new MongoDatabaseBatchHandler();
mdbh.sCollection = 'answers';

test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    mdbh.BatchStart(1000);
test.stoptest();
system.assertequals(0, mdbh.irows[0]);
}

@IsTest
private static void BatchCreationTestWithError () {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/$cmd/?filter_count=answers&limit=1', 'CountJSON');
multimock.setStatusCode(401);

MongoDatabaseBatchHandler mdbh = new MongoDatabaseBatchHandler();
mdbh.sCollection = 'answers';

test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    mdbh.BatchStart(1000);
test.stoptest();

system.debug(mdbh.irows);

}

@IsTest
private static void MongoCollectionCount () {
    MongoCollectionCount mc = MongoCollectionCount.parse(MongoIntegration_TESTS.getJSON('CountJSON'));
    system.assertequals(1000, mc.rows[0].n);
    system.assertequals(1, mc.rows[0].ok);
    
}

@IsTest
private static void BatchHandlerTests() {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/answers/?skip=13000&limit=-1000', 'Answers115JSON');
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/answers/?skip=14000&limit=-1000', 'Answers115JSON');
multimock.setStatusCode(200);

MongoDatabaseBatchHandler mdbh = new MongoDatabaseBatchHandler();

List<Integer> iTestScope = new List<Integer> {13000,14000};

test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    mdbh.BatchExecute('answers', iTestScope, '1000'); 
test.stoptest();
} 

@IsTest
private static void BatchHandlerCampaignTest() {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/campaigns/?skip=1&limit=-1', 'CTCampaignKALIMA');
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/campaigns/?skip=2&limit=-1', 'CTCampaignKALIMA');
multimock.setStatusCode(200);

MongoDatabaseBatchHandler mdbh = new MongoDatabaseBatchHandler();

List<Integer> iTestScope = new List<Integer> {1,2};

test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    mdbh.BatchExecute('campaigns', iTestScope, '1'); 
test.stoptest();
} 

@IsTest
private static void BatchInterfaceTest() {

MongoDatabaseBatchUpdate MDBU = new MongoDatabaseBatchUpdate();
MDBU.sCollection = 'campaigns';
MDBU.sLimit = '10';
database.executebatch(MDBU);
}

@IsTest
private static void SchedulingBatchTest() {
MongoDatabaseBatchUpdate MDBU = new MongoDatabaseBatchUpdate();
MDBU.sCollection = 'campaigns';
MDBU.sLimit = '1';

Test.startTest();
ScheduledBatchHandler sh = new ScheduledBatchHandler();
sh.batchClass = MDBU;
sh.batchSize = 10;

String sch = '0 0 23 * * ?';
system.schedule('Campaign Processing Test', sch, sh);

Test.stopTest();
}

@isTest
private static void SchedulingCollectionTest() {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/questions/', 'Questions115JSON');
multimock.setStatusCode(200);

Test.startTest();
Test.setMock(HttpCalloutMock.class, multimock);

ScheduledBatchHandler sh = new ScheduledBatchHandler();
sh.sParams = new List<String> {'questions','QuestionParser_CT'};

String sch = '0 0 23 * * ?';
system.schedule('Questions Processing Test', sch, sh);

Test.stopTest();
}

@isTest
private static void SchedulingClassInvokeTest() {

ScheduledBatchHandler sh = new ScheduledBatchHandler();
sh.sClass = 'QuestionParser_CT';
String sch = '0 0 23 * * ?';

Test.startTest();

system.schedule('Questions Class Test', sch, sh);

Test.stopTest();
}

}