@isTest
private class Cohorts_TEST {

@isTest
private static void TestCampaign() {  
                       
       bfc_cohortdashcomponentcontroller cdcc = new bfc_cohortdashcomponentcontroller();
       cdcc.dashcohort = 'Bogor 4';
       cdcc.getcohorttracking();
       
} 

@isTest
private static void CohortDashboard() {

//Test bfc_settracking_details
Cohort__c testcohort = DataFactory_TEST.CreateTestCohort(TRUE);
Case testpa = DataFactory_TEST.CreateTestCase(testcohort.Id, TRUE);

Projects__c testnp = DataFactory_TEST.CreateTestProject(testcohort.Id, TRUE);
Tracking_Details__c [] testtd = DataFactory_TEST.CreateTestTracking(testpa.Id);
  
//Test where all components are create new
PageReference pageRef = Page.cohorttracking_0;
//We put this to simulate when the page is called from a Dashboard 
pageRef.getParameters().put('test', 'test');
Test.setCurrentPage(pageRef);  
bfc_cohortdashboardscontroller bfc_cohortdashboardscontroller = new bfc_cohortdashboardscontroller();
bfc_cohortdashboardscontroller.getcohorttracking();
system.assertequals(1,bfc_cohortdashboardscontroller.cohorttracking[0].Dash_Current__c);
system.assertequals(1,bfc_cohortdashboardscontroller.cohorttracking[0].Dash_Completed__c);
}


@isTest
static void bfc_test_LeadExtension() {
DataFactory_TEST.SetupTestTracking();
DataFactory_TEST.setupCountries();

PageReference pageRef = Page.eoi_gen_es;  
//test no param   
Test.setCurrentPage(pageRef);
//now with known param
ApexPages.currentPage().getParameters().put('cht', 'Guad9');
Test.setCurrentPage(pageRef);
//first test - with no matches

Lead tlead = new Lead ();
LeadExtension testle1 = new LeadExtension(new ApexPages.StandardController(tlead));

ApexPages.currentPage().getParameters().put('cht', 'Guad9');
system.assertequals('Guad9', testle1.getcohort());

testle1.getCountries();
testle1.getOrgTypes();
testle1.getSalutations();
testle1.getshowconfirmation();

testle1.geneoi.LastName = 'Test PA Con 1';
testle1.geneoi.Email = 'testtc1@bfcclient.com';
testle1.geneoi.Street = 'Test Street 1';
testle1.geneoi.City = 'Test City 1';
testle1.geneoi.State = 'VA';
testle1.geneoi.PostalCode = '22201';
testle1.geneoi.Country = 'USA';
testle1.geneoi.Company = 'PA Test TA1';

testle1.save();    
}// end test       

@isTest
static void test_pricepagescontroller() {
DataFactory_TEST.SetupTestTracking();
DataFactory_TEST.setupCountries();

//Set up test data
Account ta1 = New Account(RecordTypeId = '0123000000054PE', Name = 'PA Test TA1');
insert ta1;
Account ta2 = New Account(RecordTypeId = '0123000000054PE', Name = 'PA Test TA2');
insert ta2;
Contact tc1 = New Contact(RecordTypeId = '0123000000054Ou', AccountId = ta1.Id, FirstName = 'Test1', LastName = 'PC Test TC1', Email = 'testtc1@bfcclient.com');
insert tc1;
//ta2 starts at TA1, but test 2 should move them to TA2
Contact tc2 = New Contact(RecordTypeId = '0123000000054Ou', AccountId = ta1.Id, FirstName = 'Test2', LastName = 'PC Test TC2', Email = 'testtc2@bfcclient.com');
insert tc2;

test.starttest();
PageReference pageRef = Page.prideapplication;  
//test no param   
Test.setCurrentPage(pageRef);
//now with known param
ApexPages.currentPage().getParameters().put('cht', 'Guad9');
Test.setCurrentPage(pageRef);
//first test - with no matches
bfc_prideonlineform testpa1 = new bfc_prideonlineform();
ApexPages.currentPage().getParameters().put('cht', 'Guad9');
system.assertequals('Guad9', testpa1.getcohort());
testpa1.getcohort();
testpa1.getCountries();
testpa1.getOrgTypes();
testpa1.getSalutations();
testpa1.getahideshow();
testpa1.getchideshow();
testpa1.getpContact();
testpa1.getpaccount();
testpa1.getpcase();
testpa1.getshowconfirmation();


//test toggles disable sections and destroy objects
system.assertequals(FALSE,testpa1.showcon);
testpa1.pcase.Prospective_CM_Identified__c= 'Yes';
testpa1.ToggleCon();
system.assertequals(TRUE,testpa1.showcon);
system.assertequals(FALSE,testpa1.showorg);
testpa1.pcase.Prospective_CM_Employed_by_LAP__c = 'No';
testpa1.ToggleOrg();
system.assertequals(TRUE,testpa1.showorg);
testpa1.getcmContact();
testpa1.getcmAccount();

testpa1.pcase.Prospective_CM_Identified__c= 'No';
testpa1.ToggleCon();
system.assertequals(FALSE,testpa1.showcon);
system.assertequals(NULL,testpa1.cmcontact);

testpa1.pcase.Prospective_CM_Employed_by_LAP__c = 'Yes';
testpa1.ToggleOrg();
system.assertequals(FALSE,testpa1.showorg);
system.assertequals(NULL,testpa1.cmaccount);

testpa1.pcontact.LastName = 'Test PA Con 1';
testpa1.pcontact.Email = 'TestuPACon1@bfcclient.com';
testpa1.pcontact.MailingCountry = 'United Kingdom';
testpa1.paccount.name = 'Test XX uOrg 1';

//Test custom picklists
testpa1.pcontact.MailingCountry = 'None';
testpa1.save();
testpa1.pcontact.MailingCountry = 'United Kingdom';
testpa1.paccount.Segment__c = 'None';
testpa1.save();
testpa1.paccount.Segment__c = 'BINGO';
testpa1.pcontact.Salutation = 'None';
testpa1.save();
testpa1.pcontact.Salutation = 'Dr';

testpa1.save();
Account taccount = [Select Id from Account where Name = 'Test XX uOrg 1'];
Contact tcontact = [Select Id from Contact where email = 'TestuPACon1@bfcclient.com'];

Case tcase1 = [Select ContactId, Country__c,Campaign_Manager__c from Case where AccountId = :taccount.Id];
system.assertequals(tcontact.Id,tcase1.ContactId);
//Check Campaign Manager not set, and not set to same as new Contact
system.assertequals(null,tcase1.Campaign_Manager__c);
//Check Country Set
system.assertequals('United Kingdom',tcase1.Country__c);

//Now Test With All Existing
bfc_prideonlineform testpa2 = new bfc_prideonlineform();
ApexPages.currentPage().getParameters().put('cht', 'Guad9');
testpa2.getpContact();
testpa2.getpaccount();
testpa2.getpcase();
testpa2.pcontact.LastName = 'Test PA Con 1';
testpa2.pcontact.Email = 'testtc1@bfcclient.com';
testpa2.pcontact.MailingStreet = 'Test Street 1';
testpa2.pcontact.MailingCity = 'Test City 1';
testpa2.pcontact.MailingState = 'VA';
testpa2.pcontact.MailingPostalCode = '22201';
testpa2.pcontact.MailingCountry = 'USA';
testpa2.paccount.name = 'PA Test TA1';
//test toggles enable sections
system.assertequals(FALSE,testpa2.showcon);
testpa2.pcase.Prospective_CM_Identified__c= 'Yes';
testpa2.ToggleCon();
system.assertequals(TRUE,testpa2.showcon);
system.assertequals(FALSE,testpa2.showorg);
testpa2.pcase.Prospective_CM_Employed_by_LAP__c = 'No';
testpa2.ToggleOrg();
system.assertequals(TRUE,testpa2.showorg);

testpa2.getcmAccount();
testpa2.getcmContact();
testpa2.cmcontact.LastName = 'Test CM 2 XX';
testpa2.cmcontact.Email = 'testtc2cm@bfcclient.com';
testpa2.cmaccount.Name = 'PA Test TA2';

//testpa1.pcase
testpa2.save();

Contact tcontact2 = [Select MailingStreet, MailingCity , MailingState, MailingPostalCode, MailingCountry from Contact where Id = :tc1.Id];
system.assertequals('Test Street 1',tcontact2.MailingStreet);
system.assertequals('Test City 1',tcontact2.MailingCity);
system.assertequals('VA',tcontact2.MailingState);
system.assertequals('22201',tcontact2.MailingPostalCode);
system.assertequals('USA',tcontact2.MailingCountry);

Contact tcontact3 = [Select Id from Contact where email = 'testtc2cm@bfcclient.com'];
Account taccount3 = [Select Id from Account where Name = 'PA Test TA2'];

Case tcase2 = [Select ContactId, Country__c, Campaign_Manager__c, Campaign_Manager__r.AccountId from Case where AccountId = :ta1.Id];
system.assertequals(tc1.Id,tcase2.ContactId);
//Check Campaign Manager set, and not set to same as new Contact
system.assertequals(tcontact3.Id,tcase2.Campaign_Manager__c);
system.assertequals(taccount3.Id,tcase2.Campaign_Manager__r.AccountId);
//Check Country Set
system.assertequals('USA',tcase2.Country__c);

//Test Contact = Campaign Manager when Contact is new
bfc_prideonlineform testpa3 = new bfc_prideonlineform();
ApexPages.currentPage().getParameters().put('cht', 'Guad9');
testpa3.getpContact();
testpa3.getpaccount();
testpa3.getpcase();

//Check toggles

testpa3.pcontact.LastName = 'Test uPA Con 3';
testpa3.pcontact.Email = 'testtc3@bfcclient.com';
testpa3.paccount.name = 'PA uTest TA3';
testpa3.getcmContact();
testpa3.cmcontact.LastName = 'Test uPA Con 3a';
testpa3.cmcontact.Email = '';
//No Org for Camapign Manager - so should be set to Main org
testpa3.save();

Contact tcontact3a = [Select Id from Contact where email = 'testtc3@bfcclient.com'];
Contact tcontact3b = [Select Id from Contact where LastName = 'Test uPA Con 3a'];
Account taccount3a = [Select Id from Account where Name = 'PA uTest TA3'];

Case tcase3 = [Select ContactId, Country__c, Campaign_Manager__c, Campaign_Manager__r.AccountId from Case where AccountId = :taccount3a.Id];
system.assertequals(tcontact3a.Id,tcase3.ContactId);
//Check Campaign Manager is NOT set to same as new Contact, but created as new
system.assertequals(tcontact3b.Id,tcase3.Campaign_Manager__c);
//Check Org is main Org
system.assertequals(taccount3a.Id,tcase3.Campaign_Manager__r.AccountId);

//Test FF info 
bfc_prideonlineform testpa4 = new bfc_prideonlineform();
ApexPages.currentPage().getParameters().put('cht', 'Guad9');
testpa4.getpContact();
testpa4.getpaccount();
testpa4.getpcase();

//Check toggles

system.assertequals(FALSE,testpa4.showcon);
testpa4.pcase.Prospective_FF_Identified__c= 'Yes';
testpa4.ToggleConFF();
system.assertequals(TRUE,testpa4.showFFcon);
system.assertequals(FALSE,testpa4.showFForg);
testpa4.pcase.Prospective_FF_Employed_by_LAP__c = 'No';
testpa4.ToggleOrgFF();
system.assertequals(TRUE,testpa4.showFForg);

testpa4.getffAccount();
testpa4.getffContact();

testpa4.pcontact.LastName = 'Test uPA Con 4';
testpa4.pcontact.Email = 'testtc4@bfcclient.com';
testpa4.paccount.name = 'PA FF uTest TA4';
testpa4.ffcontact.LastName = 'Test FF PA Con 4';
testpa4.ffcontact.Email = 'testfft4@bfcclient.com';
testpa4.ffaccount.Name = 'PA Test New FF Org 4';

testpa4.save();


Contact tcontact4 = [Select Id from Contact where email = 'testtc4@bfcclient.com'];
Contact tcontactff4 = [Select Id from Contact where email = 'testfft4@bfcclient.com'];
Account taccount4 = [Select Id from Account where Name = 'PA Test New FF Org 4'];

Case tcase4 = [Select ContactId, Fisheries_Fellows__c, Fisheries_Fellows__r.AccountId from Case where ContactId = :tcontact4.Id];
system.assertequals(tcontact4.Id,tcase4.ContactId);
//Check FF IS created and set
system.assertequals(tcontactff4.Id,tcase4.Fisheries_Fellows__c);
//Check Org is main Org
system.assertequals(taccount4.Id,tcase4.Fisheries_Fellows__r.AccountId);

test.stoptest();
}

}