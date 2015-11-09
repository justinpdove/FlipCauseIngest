trigger UpdateCurrentGrade on Scorecard__c (after insert, after update) {
	
    Set<id> Campaigns = new Set<Id>();
    
    For (Scorecard__c sc: Trigger.New) {
        Campaigns.add(sc.Rare_Campaign__c);
    }
    
    Rare_Campaign__c [] rc = [Select Id, Current_Grade__c, (Select Id, Grade__c FROM Score_Cards__r WHERE Submission_Date__c != NULL ORDER BY Submission_Date__c DESC LIMIT 1)
                              FROM Rare_Campaign__c WHERE Id IN :Campaigns];
    
    FOR (Rare_Campaign__c rarec: rc) {
     
    	if (rarec.Score_Cards__r.size() > 0){    
        	rarec.Current_Grade__c = rarec.Score_Cards__r[0].Grade__c;
    	} else {
        	rarec.Current_Grade__c = NULL;
    	}
    }
    
    update rc;
}