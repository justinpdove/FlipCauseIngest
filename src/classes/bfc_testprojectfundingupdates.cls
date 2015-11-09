@istest
class bfc_testprojectfundingupdates {

//Set up data
static testmethod void bfc_test_pfupdategrid() {

Account taccount = new Account (Name = 'PA Test Data');
insert taccount;

Opportunity tfund1 = new Opportunity (Name = 'Test Fund 1', Amount=1000, AccountId = taccount.Id, StageName = 'Submission/Ask', Proposal_Mail_Date__c = system.today().adddays(5), closedate = system.today().adddays(30));
insert tfund1;

Cohort__c testcohort = DataFactory_TEST.CreateTestCohort(TRUE);

Projects__c tproj = DataFactory_TEST.CreateTestProject(testcohort.Id, FALSE);
tproj.Project_status__c = 'Active';
insert tproj;

//Create Controller
bfc_updateprojectfunding tpfc = new bfc_updateprojectfunding(new ApexPages.StandardController(tfund1));    
//Check Page Exists
PageReference tpf = Page.pfupdategrid;
Test.setCurrentPage(tpf);
//Do initial get
tpfc.getcpfunds();
//Check % is zero as no records yet
system.assertequals(0, tpfc.pctotal);
//Create new record 
tpfc.newpf();
//set list as on page
LIST<bfc_updateprojectfunding.cPFund> tpfunds = new LIST<bfc_updateprojectfunding.cPFund> ();
//re-get with new record
tpfunds = tpfc.getcpfunds();
//set without % to check error validation
tpfunds[0].pf.Allocated_To__c = String.valueOf(system.today().year());
tpfunds[0].pf.project__c = tproj.Id;
//should catch error
try {
tpfc.updatepf();
}
Catch (Exception Ex) {
}
//set allocation to 100%
tpfunds[0].pf.Allocation__c = 100.00;
//tpfc.recalc();
//should now save without error
tpfc.updatepf();
//Check record exists in DB
system.assertequals(1, [Select count() from project_funding__c where funding__c = :tfund1.Id]);

//refresh page
tpfc.getcpfunds();
//check % updated
system.assertequals(100.00, tpfc.pctotal);

//create second record and check % validation
tpfc.newpf();
tpfunds = tpfc.getcpfunds();
//Set details
tpfunds[1].pf.Allocated_To__c = String.valueOf(system.today().year()+ 1);
tpfunds[1].pf.project__c = tproj.Id;
tpfunds[1].pf.Allocation__c = 60.00;
//check overall % allocation error validation caught
try {
tpfc.updatepf();
}
Catch (Exception Ex) {
}

//now set % correctly
tpfunds[0].pf.Allocation__c = 40.00;
tpfunds[1].pf.Allocation__c = 60.00;
//should save correctly
tpfc.updatepf();
//Check both records exists in DB
system.assertequals(2, [Select count() from project_funding__c where funding__c = :tfund1.Id]);
//re-get
tpfc.getcpfunds();
//check % still correct
system.assertequals(100.00, tpfc.pctotal);

//now delete second record and check validations
tpfunds[1].pfdelete = true;
//should fail
try {
tpfc.updatepf();
}
Catch (Exception Ex) {
}

//page is refreshed
tpfc.getcpfunds();

//now set deleted % correctly
tpfunds[1].pf.Allocation__c = 00.00;
//should still fail - need to update all %
try {
tpfc.updatepf();
}
Catch (Exception Ex) {
}

//Refresh
tpfc.getcpfunds();

//so update first record to 100
tpfunds[0].pf.Allocation__c = 100.00;

//should now succeed
try {
tpfc.updatepf();
}
Catch (Exception Ex) {
}

//Check only record exists in DB
system.assertequals(1, [Select count() from project_funding__c where funding__c = :tfund1.Id]);

//Refresh
tpfc.getcpfunds();

tpfc.recalc();
system.assertequals(100.00, tpfc.pctotal);
tpfc.cancel();

//check trigger UIDeletion on surviving record
project_funding__c tdeletion = [Select Id, Allocated_Amount__c, 
                                Funding__c from project_funding__c 
                                where funding__c = :tfund1.Id];
try {
delete tdeletion;
}
Catch (Exception e2) {
system.assert(e2.getmessage().contains('Please set % Allocation to 0'));
}

//check allocated amount = Expected Amount (25% of Opty Amount)
system.assertequals(250, tdeletion.Allocated_Amount__c);


//Check Opty Trigger works...

tfund1.amount = 2000;
update tfund1;
//check allocated amount = new Expected Amount (25% of Opty Amount)
tdeletion = [Select Id, Allocated_Amount__c, 
                                Funding__c from project_funding__c 
                                where funding__c = :tfund1.Id];

//check when Opty Amount was updated, that the Funding Records are updated
system.assertequals(500, tdeletion.Allocated_Amount__c);
//Finally, let's test override page controller:

bfc_pfoverride testpfover = new bfc_pfoverride(new ApexPages.StandardController(tdeletion));
String tpage = testpfover.oredirect().geturl();
system.assertequals('/apex/pfupdategrid?id=' + tfund1.id, tpage);

}

} //end test