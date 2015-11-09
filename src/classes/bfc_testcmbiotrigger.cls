@istest
class bfc_testcmbiotrigger {

//Set up data
static testmethod void bfc_test_controller() {

Account taccount = new Account (Name = 'PA Test Trigger');
insert taccount;

Contact tcontact = new Contact();
tcontact.LastName = 'Test PA Con 1';
tcontact.Email = 'testtc1@bfcclient.com';
tcontact.MailingStreet = 'Test Street 1';
tcontact.MailingCity = 'Test City 1';
tcontact.MailingState = 'VA';
tcontact.MailingPostalCode = '22201';
tcontact.MailingCountry = 'USA';
tcontact.Campaign_Manager_Bio_L__c = 'Test Long Bio Update';
tcontact.accountId = taccount.Id;
insert tcontact;

Case tcase = new Case();

tcase.Campaign_Manager__c = tcontact.Id;
insert tcase;

//check bio is updated on Case
Case tconfirm = [Select Id, Campaign_Manager_Bio_Long__c from Case where Id = :tcase.Id];
system.assertequals('Test Long Bio Update',tconfirm.Campaign_Manager_Bio_Long__c);

//Update Bio on Contact and check bio stays same on Case
tcontact.Campaign_Manager_Bio_L__c = 'Test Long Bio Update U2';
update tcontact;

tconfirm = [Select Id, Campaign_Manager_Bio_Long__c from Case where Id = :tcase.Id];
system.assertequals('Test Long Bio Update',tconfirm.Campaign_Manager_Bio_Long__c);

//Set case cm bio back to null, and check now updated again
tcase.Campaign_Manager_Bio_Long__c = null;
update tcase;

tconfirm = [Select Id, Campaign_Manager_Bio_Long__c from Case where Id = :tcase.Id];
system.assertequals('Test Long Bio Update U2',tconfirm.Campaign_Manager_Bio_Long__c);

tcase.Status = 'Rejected';
update tcase;

tcase.Campaign_Manager_Bio_Long__c = null;
update tcase;

//Check bio not updated when case closed
tconfirm = [Select Id, Campaign_Manager_Bio_Long__c from Case where Id = :tcase.Id];
system.assertequals(null,tconfirm.Campaign_Manager_Bio_Long__c);

}

} //end class