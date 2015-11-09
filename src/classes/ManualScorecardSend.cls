public class ManualScorecardSend {
	
    List<Rare_Campaign__c> rcResults = [SELECT Id FROM Rare_Campaign__c where Status__c = 'Active'];
    
    
}