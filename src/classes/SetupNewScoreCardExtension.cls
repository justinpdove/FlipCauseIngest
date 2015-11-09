public with sharing class SetupNewScoreCardExtension {
private final Rare_Campaign__c campaign;

public List<ScorecardProcessHandler.ScorecardAnswerSetup> NewScoreCardAnswers {get;set;}    
    
    public SetupNewScoreCardExtension(ApexPages.StandardController controller) {
        campaign = (Rare_Campaign__c)controller.getrecord();
        setupNewQuestions();
    }

private void setupNewQuestions() {

NewScoreCardAnswers = new List<ScorecardProcessHandler.ScorecardAnswerSetup> (); 

List<Questions__c> questions = ScorecardProcessHandler.getAllQuestions();

for (integer i=0; i < questions.size(); i++) {
    ScorecardProcessHandler.ScorecardAnswerSetup sap = new ScorecardProcessHandler.ScorecardAnswerSetup(i + 1, questions[i]);
    NewScoreCardAnswers.add(sap);
}


}

public pageReference createScorecard() {
Scorecard__c sc = new Scorecard__c(Rare_Campaign__c = campaign.Id, Status__c = 'Active');
insert sc;
List<Scorecard_Answer__c> newsa = new List<Scorecard_Answer__c> ();

for (ScorecardProcessHandler.ScorecardAnswerSetup sap: NewScoreCardAnswers) {
    if (sap.bInclude) {
        sap.sa.Scorecard__c = sc.Id;
        newsa.add(sap.sa);
    }
    
}
    
insert newsa;
    return new PageReference('/'+sc.Id);    
}

public PageReference SendScorecard() {
    ScorecardProcessHandler sph = new ScorecardProcessHandler();
    sph.GenerateNewScorecards(new List<Id>{campaign.Id});
    sph.generateSubmissionNotice();
    return new PageReference('/'+ campaign.Id);   
}

}