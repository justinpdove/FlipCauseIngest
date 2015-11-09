public class bfc_proposalteamupdate {

@future
public static void updateteamcalc (Set<Id> optysforupdate) {
 triggerhelper.recursiveHelper(true);
Map<Id, Map<String, Decimal>> fundingmap = new Map<Id, Map<String, Decimal>> ();

 AggregateResult[] groupedResults =               
        [SELECT 
        Allocated_To__c at,
        Funding__c fund,
        sum(Allocated_Amount__c) aa
        FROM Project_Funding__c 
        WHERE Funding__c IN :optysforupdate
        GROUP BY Funding__c, Allocated_To__c ];
        
    for (AggregateResult ar : groupedResults)  
    
    {
                Map<String, Decimal> yearmap;       
                    if (fundingmap.containskey( (Id)ar.get('fund') ) ) {
                           yearmap  = fundingmap.get( (Id)ar.get('fund') );
                                                        }
                    else {
                        yearmap  = new Map<String, Decimal> () ;
                    }                       
                    
                    yearmap.put( (String)ar.get('at'), (Decimal)ar.get('aa') );
                    fundingmap.put( (Id)ar.get('fund'), yearmap);
    }
   system.debug(fundingmap);
    
List<Proposal_Team_Calc__c> ptc = new List<Proposal_Team_Calc__c> () ;
Set<String> recordsforcleanup = new Set<String> ();

For (Proposal_Team__c pt: [Select Id, Funding_Record_Name__c, Percentage_Split__c from Proposal_Team__c where Funding_Record_Name__c IN :optysforupdate]) {

if (fundingmap.containskey (pt.Funding_Record_Name__c) ) {
Map <String, Decimal> fyearmap = fundingmap.get( pt.Funding_Record_Name__c );
for (String s: fyearmap.keyset() ) {
String skey = String.valueof(pt.Funding_Record_Name__c) + String.valueOf(pt.Id) + s; 
recordsforcleanup.add(skey);
ptc.add (new Proposal_Team_Calc__c (Proposal_Team__c = pt.Id, Allocated_Year__c = s, Allocated_Amount__c =  ( fyearmap.get(s) *  pt.Percentage_Split__c ) / 100, key__c = skey ) );
}
} //end if

} //end loop
upsert ptc key__c;

//clean up
Proposal_Team_Calc__c [] ptclean = [Select Id from Proposal_Team_Calc__c where Proposal_Team__r.Funding_Record_Name__c IN :optysforupdate AND Key__c NOT IN :recordsforcleanup];
delete ptclean;

} //end method

} //end class