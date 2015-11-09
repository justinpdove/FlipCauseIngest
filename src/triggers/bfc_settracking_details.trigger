/*
This trigger is designed to enable RARE to track the progress of applications through their process. Every time an application is updated via workflow, we write/update
records in the Tracking Details Object - a new one for the new status, and update the record for the old status to be complete, and the date it was completed 
*/

trigger bfc_settracking_details on Case (after insert, after update) {

List <Tracking_Details__c> tdinsert = new List<Tracking_Details__c>{};
List <Tracking_Details__c> tdupdate = new List<Tracking_Details__c>{};
List <Tracking_Details__c> tdrecommend = new List<Tracking_Details__c>{};
Set <String> uCases = new Set<String>{};
Set <Id> uRecommendCases = new Set<Id>{};

//We have to match up the stage later on to the parent stage value in the Tracking Object, so we can track totals, targets etc
Map<String, Id> tList = new Map<String, Id>();
for(Tracking__c t:[Select Reference_Name__c, Id From Tracking__c]) 
    { 
     {tList.put(t.Reference_Name__c, t.Id);}
    } 

if (Trigger.isInsert) {
//For inserts, the process is simple - set a new record in the tracking object, matched to the parent Tracking Record for that status        
for (Case c:Trigger.New){
//Key Status is the way we find the values when we want to update them later. Though more complex than just looking for a value with a empty exit date, it is also more precise
		if (tList.containsKey(c.Status))
	{
		tdinsert.add(new Tracking_Details__c(Key_Status__c = c.Status, Tracking__c = tList.get(c.Status), Pride_Application__c = c.id, Entry_Date__c = system.today()));
	}
	
}
}
if (Trigger.isUpdate) {
//The Regional Recommendation field overrides the application status - rejected/deferred means that that application is ended, and we capture at which stage that occurs...
for (integer i=0; i<trigger.new.size();i++){
if (trigger.old[i].Regional_Recommendation__c <> trigger.new[i].Regional_Recommendation__c) {
			uRecommendCases.add(trigger.new[i].Id);
}
}
}

//For updates, when a status moves, we update the tracking detail record for the old status value. However, because workflow triggers the status change, we want to make sure that trhe trigger fires after workflow has fired - i.e the secind time around
//So we use the bfc_checktriggerfiring class to make sure we only trigger the second time around	
if(bfc_checktriggerfiring.hasAlreadyDone()){
if (Trigger.isUpdate && Trigger.isAfter) {
	for (integer i=0; i<trigger.new.size();i++){
			if (trigger.old[i].Status <> trigger.new[i].Status) {

					if (tList.containsKey(trigger.new[i].Status))
					{
//So for updates, we do two things - first, write a new record in tracking details for the new Application Status  
						tdinsert.add(new Tracking_Details__c(Key_Status__c = trigger.new[i].Status, Tracking__c = tList.get(trigger.new[i].Status), Pride_Application__c = trigger.new[i].id, Entry_Date__c = system.today()));
					}
				String id18 = trigger.old[i].Id;
				//And then we add to the update list the record of the old application/status combination so we can update the exit date
			uCases.add(trigger.old[i].Status + id18.substring(0,15));
			system.debug(trigger.old[i].Status + id18.substring(0,15));

}
}	
}
}

//So for records to be updated, we update the exit date to the current date
For (Tracking_Details__c td: tdupdate = [Select Id, Exit_Date__c From Tracking_Details__c where TrackingKey__c in :uCases]) {
td.Exit_Date__c = system.today();
}
//So for records where recommended field was changed, we trigger a workflow on tracking details. A workflow gives RARE more flexibility to change the behavior in the future if they decide to change the process
For (Tracking_Details__c tdr: tdrecommend = [Select Id, Workflow_update__c From Tracking_Details__c where Pride_Application__c in :uRecommendCases]) {
tdr.Workflow_update__c = system.today();
}

//These inserts/updates shouldn't fail, so we'll just catch the exception in sys debug statement so we can see why they are failing in the debug logs if that every happens
try {
update tdupdate;
}
catch (Exception ex) {
system.debug(ex);
}

try {
update tdrecommend;
}
catch (Exception ex) {
system.debug(ex);
}

try {
insert tdinsert;
}
catch (Exception ex) {
system.debug(ex);
}

//First time around, we set the boolean so we know to run this the second time around
bfc_checktriggerfiring.setAlreadyDone();
}