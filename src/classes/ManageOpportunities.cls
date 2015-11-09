public class ManageOpportunities {
/* With reference to Steve Andersen's post: http://gokubi.com/archives/two-interesting-ways-to-architect-apex-triggers */ 


public static void isafterupdate(Map<Id, Opportunity> newomap, Map<Id, Opportunity> oldomap ) {

Set<Id> otoprocess = new Set<Id> () ;

for (Id oid : newomap.keyset() ) {
if (newomap.get(oId).expectedrevenue <> oldomap.get(oId).expectedrevenue) {
otoprocess.add(oId);
} 
}


if (otoprocess.size () > 0 ) {

Project_Funding__c [] pftoupdate = [Select Id, Allocation__c, Allocated_Amount__c, Allocated_Amount_Calc__c from project_funding__c where funding__c in :otoprocess];

for (Project_Funding__c pf: pftoupdate) {
//only update when a % is set
    if (pf.Allocation__c != null ) {
        pf.Allocated_Amount__c = pf.Allocated_Amount_Calc__c;
    }
  }
update pftoupdate;
}
}

}