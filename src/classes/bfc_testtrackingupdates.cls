@isTest
private class bfc_testtrackingupdates {
//this class tests both bfc_settracking_details and bfc_insertintotracking since they enter data into the same tracking object and are part of the same functional requirement

@isTest
static void TestIndividualLead() {

DataFactory_TEST.SetupTestTracking();

//Testing bfc_insertintotracking
//Only Pride leads are tracked
Id plead = [Select Name, Id From RecordType where SobjectType = 'Lead' and Name  = 'Pride Lead' limit 1].id;
Id lead = [Select Name, Id From RecordType where SobjectType = 'Lead' and Name  = 'Lead' limit 1].id;
LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];

//First Test - create and convert lead which is NOT a pride lead and check no tracking data written
Lead nl = new Lead
(FirstName = 'Test',
RecordTypeId = lead,
LastName= 'TestLN',
Company='TestC',
Type__c = 'Government',
email='rare@bfcclient.com');

insert nl;

Tracking_Details__c [] testt1 = [Select t.Pride_Lead__c, t.Id From Tracking_Details__c t where t.Pride_Lead__c = :nl.id];
System.assertEquals(testt1.size(),0);

Database.LeadConvert lc = new database.LeadConvert();
lc.setLeadId(nl.id);

lc.setConvertedStatus(convertStatus.MasterLabel);

Database.LeadConvertResult lcr = Database.convertLead(lc);
System.assert(lcr.isSuccess());

testt1 = [Select t.Pride_Lead__c, t.Id From Tracking_Details__c t where t.Pride_Lead__c = :nl.id];
System.assertEquals(testt1.size(),0);

//Second test - create and convert lead which IS a pride lead and check no tracking data written, starting from a non-expression of interest
Lead nlp = new Lead
(FirstName = 'Test',
RecordTypeId = plead,
LastName= 'TestLN',
Company='TestC',
When_Referred__c = system.today(),
Rating = 'Interested',
email='rare@bfcclient.com');

insert nlp;

Tracking_Details__c [] testt1p = [Select t.Tracking__r.Name, t.name, t.status__c,t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.Pride_Lead__c = :nlp.id];
System.assertEquals(1,testt1p.size());
System.assertEquals('Lead',testt1p[0].Tracking__r.Name);
System.assertEquals(system.today(),testt1p[0].entry_date__c);
System.assertEquals(null,testt1p[0].exit_date__c);
System.assertEquals('Current',testt1p[0].status__c);

nlp.Pre_Application_Completed__c = true;
update nlp;

testt1p = [Select t.Tracking__r.Name, t.status__c,t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.id = :testt1p[0].id];
System.assertEquals('Lead',testt1p[0].Tracking__r.Name);
System.assertEquals(system.today(),testt1p[0].entry_date__c);
System.assertEquals(system.today(),testt1p[0].exit_date__c);
System.assertEquals('Completed',testt1p[0].status__c);

Tracking_Details__c [] testt1pe = [Select t.Tracking__r.Name, t.status__c,t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.Pride_Lead__c = :nlp.id and t.Exit_Date__c = null];
System.assertEquals(1,testt1pe.size());
System.assertEquals('Expressions of Interest (EOI)',testt1pe[0].Tracking__r.Name);
System.assertEquals(system.today(),testt1pe[0].entry_date__c);
System.assertEquals(null,testt1pe[0].exit_date__c);
System.assertEquals('Current',testt1pe[0].status__c);

//Final test - create and convert lead which IS a pride lead and check no tracking data written, starting from a expression of interest complete
Lead nlpe = new Lead
(FirstName = 'Test',
RecordTypeId = plead,
LastName= 'TestLN',
Company='TestC',
When_Referred__c = system.today(),
Rating = 'Interested',
Pre_Application_Completed__c = true,
email='rare@bfcclient.com');

insert nlpe;
//When the expression of interest is set to true on create, there shouldn't be a lead stage created in tracking 
testt1p = [Select t.Id From Tracking_Details__c t where t.Pride_Lead__c = :nlpe.id and t.Tracking__r.Name = 'Lead'];
System.assertEquals(0,testt1p.size());

Tracking_Details__c [] testt1pex = [Select t.Tracking__r.Name, t.status__c,t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.Pride_Lead__c = :nlpe.id];
System.assertEquals(1,testt1pex.size());
System.assertEquals('Expressions of Interest (EOI)',testt1pex[0].Tracking__r.Name);
System.assertEquals(system.today(),testt1pex[0].entry_date__c);
System.assertEquals(null,testt1pex[0].exit_date__c);
System.assertEquals('Current',testt1pex[0].status__c);

nlpe.Status= 'Contacted';
update nlpe;

//Test when Lead status is updated
testt1pex = [Select t.Tracking__r.Name, t.status__c,Lead_Status_Tracking__c, t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.Pride_Lead__c = :nlpe.id];
System.assertEquals(1,testt1pex.size());
System.assertEquals(null,testt1pex[0].exit_date__c);
System.assertEquals('Current',testt1pex[0].status__c);
System.assertEquals('Contacted',testt1pex[0].Lead_Status_Tracking__c);

/*Seems to be a problem in Apex with using database convert and after update triggers - so this causes an error and tests the error handing...
when it is fixed, the test can be changed to check what happens when a conversion occurs via UI (which does work)
*/
Database.LeadConvert lcp = new database.LeadConvert();
lcp.setLeadId(nlp.id);
lcp.setConvertedStatus(convertStatus.MasterLabel);
Database.LeadConvertResult lcrp = Database.convertLead(lcp);

}

@isTest
static void testbulkleaddata () {

DataFactory_TEST.SetupTestTracking();

// testing the governors
Id plead = [Select Name, Id From RecordType where SobjectType = 'Lead' and Name  = 'Pride Lead' limit 1].id;
Lead [] sbulk100 = new Lead []{};
        for (integer i=0;i<100;i++) {
            sbulk100.add(new Lead(
                FirstName = 'Test',
                RecordTypeId = plead,
                Company='TestC',
                email='rare@bfcclient.com',
                When_Referred__c = system.today(),
                Rating = 'Interested',
                LastName='xxTestLN: ' + String.valueof(i)));
                }
insert sbulk100;

Tracking_Details__c [] testt1p = [Select t.Id From Tracking_Details__c t where t.Pride_Lead__c in :sbulk100 and t.Tracking__r.Name = 'Lead' and t.entry_date__c = :system.today() and t.exit_date__c = null];
System.assertEquals(100,testt1p.size());

testt1p = [Select t.Id From Tracking_Details__c t where t.Pride_Lead__c in :sbulk100 and t.Tracking__r.Name = 'Expressions of Interest (EOI)'];
System.assertEquals(0,testt1p.size());


for (integer i=0;i<100;i++) {   
sbulk100[i].Pre_Application_Completed__c = true;
}

update sbulk100;    


testt1p = [Select t.Id From Tracking_Details__c t where t.Pride_Lead__c in :sbulk100 and t.Tracking__r.Name = 'Lead' and t.entry_date__c = :system.today() and t.exit_date__c = :system.today() ];
System.assertEquals(100,testt1p.size());

testt1p = [Select t.Id From Tracking_Details__c t where t.Pride_Lead__c in :sbulk100 and t.Tracking__r.Name = 'Expressions of Interest (EOI)' and t.entry_date__c = :system.today() and t.exit_date__c = null];
System.assertEquals(100,testt1p.size());
 
}

@isTest
static void TestIndividualApplication() {

DataFactory_TEST.SetupTestTracking();

//Test bfc_settracking_details
case nlc = new Case();
insert nlc;

Tracking_Details__c [] testt1p = [Select t.Tracking__r.Name, t.name, t.status__c,t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.Pride_Application__c = :nlc.id];
System.assertEquals(1,testt1p.size());
System.assertEquals('Expressions of Interest (EOI)',testt1p[0].Tracking__r.Name);
System.assertEquals(system.today(),testt1p[0].entry_date__c);
System.assertEquals(null,testt1p[0].exit_date__c);
System.assertEquals('Current',testt1p[0].status__c);

//First check that updating a field that DOESN'T change the status doesn't update the tracking information 
nlc.Fit_Assessment_Complete__c = true;
update nlc;

testt1p = [Select t.Tracking__r.Name, t.name, t.status__c,t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.Pride_Application__c = :nlc.id];
System.assertEquals(1,testt1p.size());
System.assertEquals('Expressions of Interest (EOI)',testt1p[0].Tracking__r.Name);
System.assertEquals(system.today(),testt1p[0].entry_date__c);
System.assertEquals(null,testt1p[0].exit_date__c);
System.assertEquals('Current',testt1p[0].status__c);

//Now move the status along by checking the application check box to move application from EOI to application - because workflow triggers the change, we use the same field in the test to trigger that change 
nlc.Application_Invite_Sent__c = true;
update nlc;

testt1p = [Select t.Tracking__r.Name, t.status__c,t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.id = :testt1p[0].id];
System.assertEquals('Expressions of Interest (EOI)',testt1p[0].Tracking__r.Name);
System.assertEquals(system.today(),testt1p[0].entry_date__c);
System.assertEquals(system.today(),testt1p[0].exit_date__c);
System.assertEquals('Completed',testt1p[0].status__c);

testt1p = [Select t.Tracking__r.Name, t.status__c,t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.Pride_Application__c = :nlc.id and t.Exit_Date__c = null];
System.assertEquals(1,testt1p.size());
System.assertEquals('Application',testt1p[0].Tracking__r.Name);
System.assertEquals(system.today(),testt1p[0].entry_date__c);
System.assertEquals(null,testt1p[0].exit_date__c);
System.assertEquals('Current',testt1p[0].status__c);

//Changing Regional Recommendation field can 'end' an application, so we check that this combination of trigger and formula fields acts as intended 
nlc.Regional_Recommendation__c = 'Rejected';
update nlc;

testt1p = [Select t.Tracking__r.Name, t.status__c,t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.Pride_Application__c = :nlc.id and t.Exit_Date__c != null];
System.assertEquals(1,testt1p.size());
System.assertEquals('Expressions of Interest (EOI)',testt1p[0].Tracking__r.Name);
System.assertEquals(system.today(),testt1p[0].entry_date__c);
System.assertEquals(system.today(),testt1p[0].exit_date__c);
System.assertEquals('Completed',testt1p[0].status__c);

testt1p = [Select t.Tracking__r.Name, t.status__c,t.entry_date__c,t.Exit_Date__c, t.Id From Tracking_Details__c t where t.Pride_Application__c = :nlc.id and t.Exit_Date__c = null];
System.assertEquals('Application',testt1p[0].Tracking__r.Name);
System.assertEquals(system.today(),testt1p[0].entry_date__c);
System.assertEquals(null,testt1p[0].exit_date__c);
System.assertEquals('Ended',testt1p[0].status__c);


}


}