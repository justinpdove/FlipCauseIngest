trigger bfc_campaignmgrbio on Case (before insert, before update) {

/*Cross Object Lookups don't work on Long Text Fields, 
so we'll use code to copy a Contact's CM Bio Field to an Application when it is blank
*/

Set<Id> cms = new Set<Id>();

for (Case c: trigger.new) {
if (c.Campaign_Manager__c != null && c.Campaign_Manager_Bio_Long__c == null) {
cms.add(c.Campaign_Manager__c);
}
}

Map<Id, Contact> cmmap = new Map<ID, Contact>([Select Id, Campaign_Manager_Bio_L__c from Contact where Id in :cms]);

for (Case cu: trigger.new) {
if (cu.Campaign_Manager__c != null && cu.Campaign_Manager_Bio_Long__c == null && cu.isClosed == false) {
if (cmmap.containskey(cu.Campaign_Manager__c)) {
cu.Campaign_Manager_Bio_Long__c = cmmap.get(cu.Campaign_Manager__c).Campaign_Manager_Bio_L__c;
}

}
}


}