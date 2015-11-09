public class bfc_pfoverride {

private final Project_Funding__c pf;

public bfc_pfoverride(ApexPages.StandardController stdController) {
        this.pf = (Project_Funding__c)stdController.getRecord();
        
}

public pagereference oredirect() {
pageReference p = new PageReference('/apex/pfupdategrid?id=' + pf.funding__c);
        p.setRedirect(true);
        return p;
}

}