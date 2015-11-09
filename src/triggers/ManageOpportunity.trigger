//Peter Churchill, March 30 2011
trigger ManageOpportunity on Opportunity (after update) { 
    
    ManageOpportunities.isafterupdate(Trigger.NewMap, Trigger.OldMap); 
        
}