public class ActiveCountriesController {
        
    public Integer getCountries() {
        
        Integer totalCountries = 0;
        
        AggregateResult[] results = [SELECT Count(ID), Country2__c Country
                                     FROM RARE_Campaign__c
                                     WHERE Status__c IN ('Active','completed')
                                     AND Country2__c != NULL
                                     GROUP BY Country2__c];
        
        for(AggregateResult ar : results){
            totalCountries = totalCountries + 1;
        }
        
        system.debug(totalCountries);
        return totalCountries;
    
    }
        
}