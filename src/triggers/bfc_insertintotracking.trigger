trigger bfc_insertintotracking on Lead (after insert,after update) {

//This code inserts records intot he Tracking Detail custom object, to enable management to track metrics for pride leads and applications
//All tracking details are linked to a parent Tracking record to enable totals to be calculated

Id tlead = [Select Id From Tracking__c where Reference_Name__c  = 'Pride Lead' limit 1].id;
Id explead = [Select Id From Tracking__c where Reference_Name__c  = 'EOI' limit 1].Id;

//The Code will need to check both new and updated records. 
List <Tracking_Details__c> tdinsert = new List<Tracking_Details__c>{};
List <Tracking_Details__c> tdupdate = new List<Tracking_Details__c>{};
List <Tracking_Details__c> wfupdate = new List<Tracking_Details__c>{};
Set <String> uLeads = new Set<String>{};
Set <String> wfLeads = new Set<String>{};

if (Trigger.isInsert) {
//For inserts, we determine if it is a lead or an expression of interest, and insert into Tracking Details linked to the correct parent.
for (lead l : Trigger.New) {
if (l.recordTypeId == '01230000000541C') {
	if (l.Pre_Application_Completed__c == true){
	tdinsert.add(new Tracking_Details__c(Tracking__c = explead, Lead_Status_Tracking__c = l.status, Pride_Lead__c = l.id, Entry_Date__c = system.today())); 
	}
	else
	{
	tdinsert.add(new Tracking_Details__c(Tracking__c = tlead, Lead_Status_Tracking__c = l.status, Pride_Lead__c = l.id, Entry_Date__c = system.today()));	
	}
} 
}
}

/*For updates, we need to work out a few more things. 
If it is moving from Lead to EOI, we need to exit the Lead Tracking Detail records, and create a new EOI record


*/
if (Trigger.isUpdate) {
	for (integer i=0; i<trigger.new.size();i++){
		if (trigger.new[i].recordTypeId == '01230000000541C') {
//We check here to see if the record is moving from Lead to EOI
			if (trigger.old[i].Pre_Application_Completed__c <> trigger.new[i].Pre_Application_Completed__c) 
														{
//If so we create a new EOI record
					tdinsert.add(new Tracking_Details__c(Tracking__c = explead, Lead_Status_Tracking__c = trigger.new[i].status, Pride_Lead__c = trigger.new[i].id, Entry_Date__c = system.today())); 
//and add the lead to a list to update the Lead Tracking Detail record
					uLeads.add(trigger.old[i].Id);
														}
			else if
			((trigger.old[i].Status <> trigger.new[i].Status) ||
			(trigger.old[i].Date_Seeking_Admission__c <> trigger.new[i].Date_Seeking_Admission__c) ||
			(trigger.old[i].Applying_for_Program_at__c <> trigger.new[i].Applying_for_Program_at__c))
			{ 	
			wfLeads.add(trigger.new[i].Id);
			}											
														
//If the lead is being coverted, we just need to exit out any open tracking details for those records																											}
				if (trigger.new[i].isConverted == true)
				 {
				 uLeads.add(trigger.new[i].Id); 
				 }
//end trigger
		}															
}
}


//For records that have been completed (i.e the lead has moved to EOI) we set the exit date to today
For (Tracking_Details__c td: tdupdate = [Select Id, Exit_Date__c,Workflow_update__c From Tracking_Details__c where Exit_Date__c = null AND Pride_Lead__c in :uLeads]) {
td.Exit_Date__c = system.today();
td.Workflow_update__c = system.today();
}
//When Status/Cohort info has been updated, we set the workflow updated field to trigger the updates on the tracking details
For (Tracking_Details__c td: wfupdate = [Select Id, Workflow_update__c  From Tracking_Details__c where Pride_Lead__c in :WFLeads]) {
td.Workflow_update__c = system.today();
}
try {
update tdupdate;
update wfupdate;
}
catch (Exception ex) {
//There's no reason these should fail, so we catch to fail gracefully and report the problem in case some unexpected error occurs	
system.debug(ex);
}
try
{
insert tdinsert;
}
//There's no reason these should fail, so we catch to to fail gracefully and report the problem in case some unexpected error occurs
catch (Exception e) {
system.debug(e);
}
}