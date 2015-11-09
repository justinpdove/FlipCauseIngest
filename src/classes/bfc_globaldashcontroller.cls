public with sharing class bfc_globaldashcontroller {

public string fyear { get; set; }
public list<Tracking__c> gtracking = new List<Tracking__c>();

    
public list<Tracking__c> getgtracking() {

Integer queryRowLimit = Limits.getLimitQueryRows();

if (queryRowLimit == 500) {
//We are therefore in test mode:
queryRowLimit = 100;
//We set to 100 to make sure the page break code is being included but we don't exceed the governors
}


gtracking = [Select Target__c, Target_FY_10__c, Reference_Name__c, Target_Date__c, Display_Stage__c, Dash_Ended__c, Dash_Current__c, Dash_Completed__c,Dash_Cohort_to_Date__c, (Select Id, Tracking__c, Status__c From Tracking_Details__r WHERE Reporting_Year__c = :fyear Limit :queryRowLimit) From Tracking__c WHERE Dash_Table__c = true order by Display_Stage__c ASC];

For (Tracking__c t: gtracking) {
Integer dCurrent = 0;
Integer dCompleted = 0;
Integer dEnded = 0;
    for (Tracking_Details__c td : t.Tracking_Details__r ) {
      if (td.Status__c == 'Current') {
         dCurrent +=1;
      }
      if (td.Status__c == 'Completed') {
        dCompleted +=1;
      }
      if (td.Status__c == 'Ended') {
        dEnded +=1;
      }
    }  
t.Dash_Current__c = dCurrent;
t.Dash_Completed__c = dCompleted;
t.Dash_Ended__c = dEnded;
if (t.Reference_Name__c == 'Fit Assessment' || t.Reference_Name__c == 'EOI' || t.Reference_Name__c == 'Evaluation') {
t.Dash_Cohort_to_Date__c = dCurrent + dCompleted + dEnded;
}
else
t.Dash_Cohort_to_Date__c = dCurrent + dCompleted;
}

return gtracking;
}

static testMethod void TestCampaign() {  
       
                
       	bfc_globaldashcontroller cdcc = new bfc_globaldashcontroller();
        cdcc.fyear = 'FY 09';
        cdcc.getgtracking();
          
}   
}