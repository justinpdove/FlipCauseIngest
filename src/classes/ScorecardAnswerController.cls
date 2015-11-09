public class ScorecardAnswerController {
    public transient List<ScorecardAnswerWrapper> SAW {get;set;}
    public transient Scorecard__c score {get;set;}
    public String scid {get;set;}
    public String teamid {get;set;}
    private Scorecard_Submission__c user;
    public String sNewValues {get;set;}
    public Boolean bShowSubmit {get;set;} 
    public Boolean bShowApprove {get;set;} 
        
    public ScorecardAnswerController() {
    //Look for scorecard Id
     if (ApexPages.currentPage().getParameters().get('scid') != NULL) {
         scid = ApexPages.currentPage().getParameters().get('scid');
         setupWrapper();
         sNewValues = '';
         bShowSubmit = TRUE;
         //Default Approve to False
         bShowApprove = FALSE;
     }
     //Look for Team Role for this scorecard as stored in Scorecard Submission Object
     if (ApexPages.currentPage().getParameters().get('trid') != NULL) {
            setupRoles(ApexPages.currentPage().getParameters().get('trid'));
     }
    }
    
    private void setupRoles(String trid) {
    List<Scorecard_Submission__c> subs = [Select Id, Role__c FROM Scorecard_Submission__c WHERE Id = :trid];
        if (subs.isEmpty() == FALSE) {
            teamid = subs[0].Id;
            if (subs[0].Role__c == 'Approver') {
                bShowSubmit = FALSE;
                bShowApprove = TRUE;    
            }
        }
    } 
        
        private void setupWrapper() {
            SAW = new List<ScorecardAnswerWrapper> ();
            Map<Id, Questions__c> qmap = new Map<Id, Questions__c> ( [Select Id, Name, Question_Text__c, Answer_Type__c, (Select Order__c, Points__c, Option_Text__c FROM Question_Choices__r Order by Order__c ASC) 
                                                                        FROM Questions__c WHERE RecordTypeId = '012800000007kFC']);
            List<Scorecard__c> scorecards = [Select Id, Name, Comment__c, Approver_s_Comments__c , score__c, Grade__c, RARE_Campaign__r.Name, 
                                        (Select Id, Questions__c, Select_QC_Ids__c from Scorecard_Answers__r Order BY Display_Order__c ASC)
                                        FROM Scorecard__c WHERE Id = :scid];    
            if (scorecards.size() > 0) {
                score = scorecards[0];
            
                for (Scorecard_Answer__c sa: score.Scorecard_Answers__r) {
                    ScorecardAnswerWrapper sawtemp = new ScorecardAnswerWrapper(sa);
                    
                    sawtemp.question = qmap.get(sa.Questions__c);
                    sawtemp.qchoices = qmap.get(sa.Questions__c).Question_Choices__r;
                    system.debug(qmap.get(sa.Questions__c)); 
                    SAW.add(sawtemp);
                }  
            }   
        }
            
        
    public class ScorecardAnswerWrapper {
        public String scorecardId {get;set;}
        public Scorecard_Answer__c sca {get;set;}
        public String selectedchoices {get;set;}
        public Questions__c question {get;set;}
        public List<Question_Choice__c> qchoices {get;set;}
    
        public ScorecardAnswerWrapper (Scorecard_Answer__c scaparam ) {
            selectedchoices = '';
            sca = scaparam;
            if (!String.IsEmpty(sca.Select_QC_Ids__c ) ) {
                selectedchoices = sca.Select_QC_Ids__c;
            }
            
        }
    }
    
    public pagereference ReceiveUpdates() {
        system.debug(sNewValues);
        return null;
    }    
    
    @RemoteAction
    public static Void ReceiveUpdates(String sNewValues, String sType, List<String> sScorecard) {
        
        system.debug(sScorecard);
        String scid = sScorecard[0];
        Scorecard__c score = new ScoreCard__c (Id = scid);
        score.Grade__c = sScorecard[1];
        score.Comment__c = sScorecard[2];
        
        if (sScorecard.size() == 4) {
            score.approver_s_Comments__c = sScorecard[3];
        }
        
        if (sType == 'Submit') {
            score.Submission_Date__c = system.today();
            score.Submission_Status__c = 'Submitted';
        }
        
        else if (sType == 'Approve') {
        score.Submission_Status__c = 'Approved';
        }
        
        else if (sType == 'Reject') {
        score.Submission_Status__c = 'Rejected';
        }
        
        update score;
        
        List<String> sNewValueList = sNewValues.split(',');
        List<Scorecard_Answer__c> newSCValues = new List<Scorecard_Answer__c>();
        for (String s: sNewValueList) {
            String [] sValueTemp = s.Split(':');
            
            Scorecard_Answer__c sctemp = new Scorecard_Answer__c(Id = sValueTemp[0], Select_QC_Ids__c  = NULL);
            if (sValueTemp.size() == 2) {
                sctemp.Select_QC_Ids__c  = sValueTemp[1];
            }
            newSCValues.add(sctemp);
        }
        system.debug(sNewValueList);
        update newSCValues;
        
       if (sType == 'Approve') {
           ScorecardProcessHandler.setAnswerChoices(new List<Id> {scId});
        }  
    }      
}