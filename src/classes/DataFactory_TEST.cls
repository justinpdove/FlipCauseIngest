//Create Test Data

@isTest
public class DataFactory_TEST {

public static Cohort__c CreateTestCohort (Boolean bCreate) {
Cohort__c coh = new Cohort__c();
if (bCreate) {
insert coh;
}
return coh;
}


public static Case CreateTestCase (Id cohortId, Boolean bCreate) {
Case nlc = new Case();
insert nlc;
nlc.Cohort__c = 'Test 1';
update nlc;
return nlc;
}

public static  Projects__c CreateTestProject (Id cohortId, Boolean bCreate) {

Projects__c np = new Projects__c (Cohort__c = cohortId, Name='Test 1', Dashboard_Id__c = '0');
if (bCreate) {
insert np;
}
return np;
}

public static  List<Tracking_Details__c> CreateTestTracking (Id caseId) {
Tracking__c track = new Tracking__c (Name = 'Track Test', Display_Order__c = 0, Dash_Table__c = true);
insert track;

Tracking_Details__c [] testtd = new List<Tracking_Details__c> ();
testtd.add(new Tracking_Details__c(Tracking__c = track.id, entry_date__c = system.today(), Pride_Application__c = caseId));
testtd.add(new Tracking_Details__c(Tracking__c = track.id, entry_date__c = system.today(), exit_date__c = system.today(),Pride_Application__c = caseId));
insert testtd;
return testtd;
}

public static  void SetupTestTracking () {
List<Tracking__c> testTracks = new List<Tracking__c>();
testTracks.add(new Tracking__c(Name = 'Lead', Reference_Name__c = 'Pride Lead'));
testTracks.add(new Tracking__c(Name = 'Expressions of Interest (EOI)', Reference_Name__c = 'EOI'));
testTracks.add(new Tracking__c(Name = 'Application', Reference_Name__c = 'Application'));

insert testTracks;
}

public static void setupCountries() {

List<PADefaults__c> def = new List<PADefaults__c> ();
def.add(new PADefaults__c(Name = 'test1', Picklist_Values__c = '--None--', Cohort__c = 'Guad9;Default', No_Salutation_Error_Msg__c = 'Test', No_Country_Error__c = 'Test CE', No_Org_Type_Error_Msg__c = 'TESTNO'));
insert def;

List<Countries__c> csettings = new List<Countries__c> ();
csettings.add(new Countries__c(Name= 'USA',Cohorts__c = 'Guad9', Country__c = 'USA', Sort_Order__c = 1));
insert csettings;
   
}


}