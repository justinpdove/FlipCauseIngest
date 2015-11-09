public with sharing class MongoCampaignParserController {
private final Rare_Campaign__c rcampaign;
    public MongoCampaignParserController(ApexPages.StandardController controller) {
    rcampaign = (Rare_Campaign__c)controller.getrecord();
    }

public CampaignsParser_CT cpct {get;set;}
public MongoDatabaseAccess mda {get;set;}
public Rare_Campaign__c rc {get;set;}
public List<Milestone__c> milestones {get;set;}
public List<Flash_Card__c> flashcards {get;set;}
public Boolean bSuccess {get;set;}

public pageReference ReturntotRC() {
return new PageReference('/' + rcampaign.Id);
}


public PageReference parseData() {
try {
mda = new MongoDatabaseAccess();
mda.sEndPoint = 'https://mongodb.rare.org/rarect_prod/campaigns/?filter_project_code=' + rcampaign.Project_code__c + '&limit=-1';
mda.execute();
system.debug(mda.sResponse);
if (mda.bSuccess) {
    cpct = new CampaignsParser_CT();
    cpct.parsedata(mda.sResponse);
    cpct.updatecampaigns();
}
}
Catch (Exception Ex) {
}
return null;
}



}