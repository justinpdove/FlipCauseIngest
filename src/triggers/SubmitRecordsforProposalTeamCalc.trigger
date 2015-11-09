trigger SubmitRecordsforProposalTeamCalc on Proposal_Team__c (After Insert, After Update) {

//Fired when a new record is created/update on the Proposal Team Screen

Set<Id> optysforupdate = new Set<Id> () ;

/*Since we update via an @future, we don't want to fire twice, 
so use trigger helper to avoid @future calling @future
*/

if(!triggerhelper.b){

if (Trigger.IsInsert || Trigger.IsUpdate) {
    triggerhelper.recursiveHelper(true);

for (Proposal_Team__c p: Trigger.New) {
optysforupdate.add(p.Funding_Record_Name__c);
}
}

//Since @future, we send opty records to be updated via a set
if (optysforupdate.size () > 0 ) {
bfc_proposalteamupdate.updateteamcalc(optysforupdate);
}

}

}