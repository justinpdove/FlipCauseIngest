trigger SubmitRecordsforProposalTeamUpdate on Project_Funding__c (After Insert, After Update, After Delete) {

Set<Id> optysforupdate = new Set<Id> () ;

if(!triggerhelper.b){

if (Trigger.IsInsert || Trigger.IsUpdate) {
triggerhelper.recursiveHelper(true);
for (Project_Funding__c p: Trigger.New) {
optysforupdate.add(p.funding__c);
}
}

if (Trigger.IsDelete) {
triggerhelper.recursiveHelper(true);
for (Project_Funding__c p: Trigger.old) {
optysforupdate.add(p.funding__c);
}
}

if (optysforupdate.size () > 0 ) {
bfc_proposalteamupdate.updateteamcalc(optysforupdate);
}

}
}