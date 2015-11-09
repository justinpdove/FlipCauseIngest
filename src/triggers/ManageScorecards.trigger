trigger ManageScorecards on Scorecard__c (after insert, after update) {

Set<Id> Campaigns = new Set<Id> ();
for (Scorecard__c sc: Trigger.New) {
    Campaigns.add(sc.Rare_Campaign__c);
}

Rare_Campaign__c [] rc = [Select Id, Current_Scorecard_Value__c, (Select Id, Total_Score__c FROM Score_Cards__r WHERE Submission_Date__c != NULL ORDER BY Submission_Date__c DESC LIMIT 1)
                          FROM Rare_Campaign__c WHERE Id IN :Campaigns];

For (Rare_Campaign__c rarec: rc) {

    if (rarec.Score_Cards__r.size() > 0) {
        rarec.Current_Scorecard_Value__c = rarec.Score_Cards__r[0].Total_Score__c;
    }
    else {
        rarec.Current_Scorecard_Value__c = 0;
    }

}

update rc;


}