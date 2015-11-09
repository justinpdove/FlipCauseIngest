public class bfc_vftrackingdashboard {

public ApexPages.StandardSetController setDash {
        get {
            if(setDash == null) {
                setDash = new ApexPages.StandardSetController(Database.getQueryLocator([Select Target__c, Cohort_to_Date__c, Target_Date__c, Ended__c, Display_Stage__c, Current__c, Completed__c From Tracking__c where Dash_Table__c = true order by Display_Stage__c  ASC]));
            }
            return setDash;
        }
        set;
    }
    public List<Tracking__c> getTracking() {
         return (List<Tracking__c>) setDash.getRecords();
    }

static testmethod void bfc_test_controller() {

PageReference pageRef = Page.trackingreport1;
Test.setCurrentPage(pageRef);  

bfc_vftrackingdashboard bfc_vftrackingdashboard = new bfc_vftrackingdashboard();
bfc_vftrackingdashboard.getTracking();
}
}