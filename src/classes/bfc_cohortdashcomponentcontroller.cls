public class bfc_cohortdashcomponentcontroller {

  public string dashcohort { get; set; }
  public list<Tracking__c> cohorttracking = new List<Tracking__c>();
      
public list<Tracking__c> getcohorttracking() {

cohorttracking = [Select Reference_Name__c, Display_Stage__c, Dash_Ended__c, Dash_Current__c, Dash_Completed__c,Dash_Cohort_to_Date__c, (Select Id, Tracking__c, Status__c From Tracking_Details__r where Application_Cohort__c = :dashcohort) From Tracking__c where Dash_Table__c = true order by Display_Stage__c ASC];

For (Tracking__c t: cohorttracking) {
Integer dCurrent = 0;
Integer dCompleted = 0;
Integer dEnded = 0;
    for (Tracking_Details__c td : t.Tracking_Details__r ) {
      if (td.Status__c == 'Current') {
      system.debug(td.Id);
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

return cohorttracking;
}

  
}