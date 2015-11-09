@isTest
public class AllCountriesControllerTest {

    static void testCampaignData(){ 
    	RARE_Campaign__c cmpgn1 = new RARE_Campaign__c(Name='Test Campaign 1', Country2__c='America', Status__c='Active',Primary_PPM__c='jdove');
    	RARE_Campaign__c cmpgn2 = new RARE_Campaign__c(Name='Test Campaign 2', Country2__c='Brazil', Status__c='Active',Primary_PPM__c='jdove');
    	RARE_Campaign__c cmpgn3 = new RARE_Campaign__c(Name='Test Campaign 3', Country2__c='Indonesia', Status__c='Active',Primary_PPM__c='jdove');
    
    	insert cmpgn1;
        insert cmpgn2;
        insert cmpgn3;
        }
    
    static void controllerTest(){
        AllCountriesController activecc = new AllCountriesController();
        system.assertEquals(3,activecc.getCountries()); 
    }

}