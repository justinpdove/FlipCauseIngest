@isTest
private class ScorecardTracker_TESTS{

//@testSetup
//private static void setupScorecardData() {

@isTest
private static void NewScorecardProcess() {

List<Questions__c> tquestions = new List<Questions__c>();
tquestions.add(new Questions__c(Name = 'Q1', Answer_Type__c = 'radio', Question_Text__c = 'q 123', RecordTypeId = '012800000007kFC'));
tquestions.add(new Questions__c(Name = 'Q2', Answer_Type__c = 'radio', Question_Text__c = 'q 456', RecordTypeId = '012800000007kFC'));
tquestions.add(new Questions__c(Name = 'Q3', Answer_Type__c = 'checkbox', Question_Text__c = 'q 789', RecordTypeId = '012800000007kFC'));

insert tquestions;

List<Question_Choice__c> testqc = new List<Question_Choice__c> ();


for (Questions__c q: tquestions) {

    for (integer i= 1; i<4; i++) {
        testqc.add(new Question_Choice__c(Order__c = 1, Points__c = i, Option_Text__c = 'Test O' + i, Questions__c = q.id));
    }

}

insert testqc;

Program__c tprogram = new Program__c (Name = 'Test Program');
insert tprogram;

RARE_Campaign__c tcampaign = new RARE_Campaign__c(Name = 'Test Campaign 1', Program__c = tprogram.Id, Primary_PPM__c = 'Test');
insert tcampaign;

Account tRareAccount = new Account (Name = 'T Rare');
insert tRareAccount;

List<Contact> cons = new List<Contact> ();
cons.add(new Contact (LastName = 'MS', FirstName = 'Test1', AccountId = tRareAccount.Id, Email = 'rare1@bfcclient.com'));
cons.add(new Contact (LastName = 'PM', FirstName = 'Test2', AccountId = tRareAccount.Id, Email = 'rare2@bfcclient.com'));
cons.add(new Contact (LastName = 'CD', FirstName = 'Test3', AccountId = tRareAccount.Id, Email = 'rare3@bfcclient.com'));

insert cons;


List<Team_Roles__c> testr = new List<Team_Roles__c>();
testr.add(new Team_Roles__c(Member_Name__c = cons[0].Id, Rare_Campaign__c = tcampaign.Id, Start_Date__c = system.today(), Active__c = TRUE, Member_Type__c = 'Monitoring Specialist'));
testr.add(new Team_Roles__c(Member_Name__c = cons[1].Id, Rare_Campaign__c = tcampaign.Id, Start_Date__c = system.today(), Active__c = TRUE, Member_Type__c = 'Program Manager'));
testr.add(new Team_Roles__c(Member_Name__c = cons[2].Id, Rare_Campaign__c = tcampaign.Id, Start_Date__c = system.today(), Active__c = TRUE, Member_Type__c = 'Cohort Director'));
insert testr;

SetupNewScoreCardExtension setupnsc = new SetupNewScoreCardExtension(new ApexPages.StandardController(tcampaign));
//Add Questions
for (ScorecardProcessHandler.ScorecardAnswerSetup sap: setupnsc.NewScoreCardAnswers) {
    sap.bInclude = TRUE;
}
//Generate Template
setupnsc.createScorecard();
setupnsc.SendScorecard();

Map<Id, Questions__c> qmap = new Map<Id, Questions__c> ( [Select Id, Name, Question_Text__c, Answer_Type__c, (Select Order__c, Points__c, Option_Text__c FROM Question_Choices__r Order by Order__c ASC) from Questions__c]);

List<Scorecard__c> scorecards = [Select Id, Name, (Select Id, Questions__c, Select_QC_Ids__c from Scorecard_Answers__r Order BY Display_Order__c ASC) FROM Scorecard__c ORDER BY CREATEDDATE DESC];    

Scorecard_Submission__c sub = [Select Id FROM Scorecard_Submission__c  WHERE Team_Roles__c =  :testr[0].Id];

PageReference scapage = Page.ScoreCardAnswers;
Test.setCurrentPage(scapage); 
ApexPages.currentPage().getParameters().put('scid', scorecards[1].Id);
ApexPages.currentPage().getParameters().put('trid', sub.Id);

ScorecardAnswerController testsac = new ScorecardAnswerController();
//Now submit via async remote action

String sAnswerValues = '';

for (Scorecard_Answer__c sca: scorecards[0].Scorecard_Answers__r) {
Questions__c q = qmap.get(sca.Questions__c);
List<Question_Choice__c> qctemp = q.Question_Choices__r; 
sAnswerValues += sca.Id + ':' + qctemp[0].Id + ','; 
}

List<String> sValues = new List<String>();
sValues.add(scorecards[1].Id);
sValues.add('green');
sValues.add('A Comment for the ages');

//Save
ScorecardAnswerController.ReceiveUpdates(sAnswerValues, 'Save', sValues);

//Submit
ScorecardAnswerController.ReceiveUpdates(sAnswerValues, 'Submit', sValues);

sValues.add('An Approver Comment for the ages');    
//Approve
ScorecardAnswerController.ReceiveUpdates(sAnswerValues, 'Approve', sValues);
    
    /*
    public transient List<ScorecardAnswerWrapper> SAW {get;set;}
    public transient Scorecard__c score {get;set;}
    public String scid {get;set;}
    public String teamid {get;set;}
    private Scorecard_Submission__c user;
    public String sNewValues {get;set;}
    public Boolean bShowSubmit {get;set;} 
    public Boolean bShowApprove {get;set;} 
    */    
   

}


}