@istest
private class bfc_testproposalteamcalc {

//Set up data
static testmethod void bfc_test_updateviapfund() {

Account taccount = new Account (Name = 'PA Test Data');
insert taccount;

Opportunity tfund1 = new Opportunity (Name = 'Test Fund 1', Amount=1000, AccountId = taccount.Id, StageName = 'Submission/Ask', Proposal_Mail_Date__c = system.today().adddays(5), closedate = system.today().adddays(30));
insert tfund1;

Cohort__c testcohort = DataFactory_TEST.CreateTestCohort(TRUE);

Projects__c tproj = DataFactory_TEST.CreateTestProject(testcohort.Id, FALSE);
tproj.Project_status__c = 'Active';
insert tproj;


List<Proposal_Team__c> testptteam = new List<Proposal_Team__c> ();
testptteam.add(new Proposal_Team__c ( Percentage_Split__c = 50, Funding_Record_Name__c = tfund1.Id));
testptteam.add(new Proposal_Team__c ( Percentage_Split__c = 30, Funding_Record_Name__c = tfund1.Id));
insert testptteam;

//Check insert worked
system.assertequals(2, [Select count() from Proposal_Team__c where Funding_Record_Name__c = :tfund1.Id]); 

//Now insert project funds
List<Project_Funding__c> testpfunds = new List<Project_Funding__c> ();
testpfunds.add(new Project_Funding__c (Project__c = tproj.Id, Funding__c = tfund1.Id, Allocated_To__c = '2011', Allocation__c = 60));
testpfunds.add(new Project_Funding__c (Project__c = tproj.Id, Funding__c = tfund1.Id, Allocated_To__c = '2012', Allocation__c = 40));

test.starttest();
insert testpfunds;
test.stoptest();

//Check Project Teams updated correctly...
//First get, % for the stage we used
Decimal defpct = [Select DefaultProbability From OpportunityStage where MasterLabel = 'Submission/Ask'].DefaultProbability;
Decimal optyamount = (tfund1.Amount * defpct)/100; //expected revenue
Decimal optyamounty1 = (optyamount * testpfunds[0].Allocation__c) /100; // 150
Decimal optyamounty2 = (optyamount * testpfunds[1].Allocation__c) /100; // 100

///now get all calc results
List<Proposal_Team_Calc__c> testcalc = [Select Allocated_Amount__c, Allocated_Year__c from Proposal_Team_Calc__c where Proposal_Team__c IN :testptteam order by Allocated_Year__c, Allocated_Amount__c ASC];
system.debug(testcalc);
system.assertequals(4, testcalc.size() ) ;

system.assertequals('2011', testcalc[0].Allocated_Year__c);
system.assertequals('2011', testcalc[1].Allocated_Year__c);

system.assertequals('2012', testcalc[2].Allocated_Year__c);
system.assertequals('2012', testcalc[3].Allocated_Year__c);


system.assertequals( (optyamounty1 * testptteam[1].Percentage_Split__c) / 100 , testcalc[0].Allocated_Amount__c);
system.assertequals( (optyamounty2 * testptteam[1].Percentage_Split__c) / 100 , testcalc[2].Allocated_Amount__c);

system.assertequals( (optyamounty1 * testptteam[0].Percentage_Split__c) / 100 , testcalc[1].Allocated_Amount__c);
system.assertequals( (optyamounty2 * testptteam[0].Percentage_Split__c) / 100 , testcalc[3].Allocated_Amount__c);


} //end test 1


static testmethod void bfc_test_updateviapteam() {

Account taccount = new Account (Name = 'PA Test Data');
insert taccount;

Opportunity tfund1 = new Opportunity (Name = 'Test Fund 1', Amount=1000, AccountId = taccount.Id, StageName = 'Submission/Ask', Proposal_Mail_Date__c = system.today().adddays(5), closedate = system.today().adddays(30));
insert tfund1;

Cohort__c testcohort = DataFactory_TEST.CreateTestCohort(TRUE);

Projects__c tproj = DataFactory_TEST.CreateTestProject(testcohort.Id, FALSE);
tproj.Project_status__c = 'Active';
insert tproj;

//Now insert project funds
List<Project_Funding__c> testpfunds = new List<Project_Funding__c> ();
testpfunds.add(new Project_Funding__c (Project__c = tproj.Id, Funding__c = tfund1.Id, Allocated_To__c = '2011', Allocation__c = 60));
testpfunds.add(new Project_Funding__c (Project__c = tproj.Id, Funding__c = tfund1.Id, Allocated_To__c = '2012', Allocation__c = 40));
insert testpfunds;


List<Proposal_Team__c> testptteam = new List<Proposal_Team__c> ();
testptteam.add(new Proposal_Team__c ( Percentage_Split__c = 50, Funding_Record_Name__c = tfund1.Id));
testptteam.add(new Proposal_Team__c ( Percentage_Split__c = 30, Funding_Record_Name__c = tfund1.Id));

test.starttest();
insert testptteam;
test.stoptest();

//Check insert worked
system.assertequals(2, [Select count() from Proposal_Team__c where Funding_Record_Name__c = :tfund1.Id]); 


//Check Project Teams updated correctly...
//First get, % for the stage we used
Decimal defpct = [Select DefaultProbability From OpportunityStage where MasterLabel = 'Submission/Ask'].DefaultProbability;
Decimal optyamount = (tfund1.Amount * defpct)/100; //expected revenue
Decimal optyamounty1 = (optyamount * testpfunds[0].Allocation__c) /100; // 150
Decimal optyamounty2 = (optyamount * testpfunds[1].Allocation__c) /100; // 100

///now get all calc results
List<Proposal_Team_Calc__c> testcalc = [Select Allocated_Amount__c, Allocated_Year__c from Proposal_Team_Calc__c where Proposal_Team__c IN :testptteam order by Allocated_Year__c, Allocated_Amount__c ASC];
system.debug(testcalc);
system.assertequals(4, testcalc.size() ) ;

system.assertequals('2011', testcalc[0].Allocated_Year__c);
system.assertequals('2011', testcalc[1].Allocated_Year__c);

system.assertequals('2012', testcalc[2].Allocated_Year__c);
system.assertequals('2012', testcalc[3].Allocated_Year__c);


system.assertequals( (optyamounty1 * testptteam[1].Percentage_Split__c) / 100 , testcalc[0].Allocated_Amount__c);
system.assertequals( (optyamounty2 * testptteam[1].Percentage_Split__c) / 100 , testcalc[2].Allocated_Amount__c);

system.assertequals( (optyamounty1 * testptteam[0].Percentage_Split__c) / 100 , testcalc[1].Allocated_Amount__c);
system.assertequals( (optyamounty2 * testptteam[0].Percentage_Split__c) / 100 , testcalc[3].Allocated_Amount__c);



} //end test 2

static testmethod void bfc_test_deletepfupdate() {
//test when we delete a Project Funding Record

Account taccount = new Account (Name = 'PA Test Data');
insert taccount;

Opportunity tfund1 = new Opportunity (Name = 'Test Fund 1', Amount=1000, AccountId = taccount.Id, StageName = 'Submission/Ask', Proposal_Mail_Date__c = system.today().adddays(5), closedate = system.today().adddays(30));
insert tfund1;

Cohort__c testcohort = DataFactory_TEST.CreateTestCohort(TRUE);

Projects__c tproj = DataFactory_TEST.CreateTestProject(testcohort.Id, FALSE);
tproj.Project_status__c = 'Active';
insert tproj;

//Now insert project funds
List<Project_Funding__c> testpfunds = new List<Project_Funding__c> ();
testpfunds.add(new Project_Funding__c (Project__c = tproj.Id, Funding__c = tfund1.Id, Allocated_To__c = '2011', Allocation__c = 20));
testpfunds.add(new Project_Funding__c (Project__c = tproj.Id, Funding__c = tfund1.Id, Allocated_To__c = '2012', Allocation__c = 20));
testpfunds.add(new Project_Funding__c (Project__c = tproj.Id, Funding__c = tfund1.Id, Allocated_To__c = '2013', Allocation__c = 60));
insert testpfunds;

//Create Proposal Team Records
List<Proposal_Team__c> testptteam = new List<Proposal_Team__c> ();
testptteam.add(new Proposal_Team__c ( Percentage_Split__c = 100, Funding_Record_Name__c = tfund1.Id));
insert testptteam;

//set up some test calc records so we can check delete on Project Funding fires, and clean up works
//have to set up manually since we can't call @future twice in test
List<Proposal_Team_Calc__c> tpcalc = new List<Proposal_Team_Calc__c> () ;

String skey = String.valueof(tfund1.Id) + String.valueof(testptteam[0].Id); 

tpcalc.add( new Proposal_Team_Calc__c (Allocated_Amount__c = 50, Allocated_Year__c = '2011', Proposal_Team__c = testptteam[0].Id, key__c = skey+'2011' ));
tpcalc.add( new Proposal_Team_Calc__c (Allocated_Amount__c = 50, Allocated_Year__c = '2012', Proposal_Team__c = testptteam[0].Id, key__c = skey+'2012' ));
tpcalc.add( new Proposal_Team_Calc__c (Allocated_Amount__c = 100, Allocated_Year__c = '2013', Proposal_Team__c = testptteam[0].Id, key__c = skey+'2013' ));
insert tpcalc;

testpfunds[0].Allocation__c = 50;
testpfunds[1].Allocation__c = 50;
testpfunds[2].Allocation__c = 0;
update testpfunds;

//rest trigger helper
triggerhelper.recursiveHelper(false);

test.starttest();
delete testpfunds[2];
test.stoptest();

//Check insert worked
system.assertequals(1, [Select count() from Proposal_Team__c where Funding_Record_Name__c = :tfund1.Id]); 
//Check Upsert works and updates, not inserts
system.assertequals(2, [Select count() from Proposal_Team_Calc__c where Proposal_Team__c = :testptteam[0].Id]); 

//Check Project Teams updated correctly...
//First get, % for the stage we used
Decimal defpct = [Select DefaultProbability From OpportunityStage where MasterLabel = 'Submission/Ask'].DefaultProbability;
Decimal optyamount = (tfund1.Amount * defpct)/100; //expected revenue
Decimal optyamounty1 = (optyamount * testpfunds[0].Allocation__c) /100; // 150
Decimal optyamounty2 = (optyamount * testpfunds[1].Allocation__c) /100; // 100

///now get all calc results
List<Proposal_Team_Calc__c> testcalc = [Select Allocated_Amount__c, Allocated_Year__c from Proposal_Team_Calc__c where Proposal_Team__c IN :testptteam order by Allocated_Year__c, Allocated_Amount__c ASC];
system.debug(testcalc);
system.assertequals(2, testcalc.size() ) ;

system.assertequals('2011', testcalc[0].Allocated_Year__c);
system.assertequals('2012', testcalc[1].Allocated_Year__c);


system.assertequals( (optyamounty1 * testptteam[0].Percentage_Split__c) / 100 , testcalc[0].Allocated_Amount__c);
system.assertequals( (optyamounty2 * testptteam[0].Percentage_Split__c) / 100 , testcalc[1].Allocated_Amount__c);



} //end test 3




} //end class