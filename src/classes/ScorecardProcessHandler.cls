public class ScorecardProcessHandler {

private List<RARE_Campaign__c> scorecampaigns;
private List<Scorecard__c> newscorecards;

public void GenerateNewScorecards (List<Id> camps) {

scorecampaigns = [Select Id, Name, 
(Select Id, Name FROM Score_Cards__r Order By Submission_Date__c DESC NULLS LAST LIMIT 1),
(Select Id, Member_Name__c, Member_Name__r.Email, Scorecard_Role__c FROM Campaign_Roles__r WHERE Active__C = TRUE AND Scorecard_Role__c IN ('Submitter', 'Approver') )
FROM RARE_Campaign__c WHERE Id IN :camps];

Set<Id> scorecardstocopy = new Set<Id>();
for (RARE_Campaign__c scamp: scorecampaigns) {

    if (scamp.Score_Cards__r.isEmpty() == FALSE) {
        scorecardstocopy.add(scamp.Score_Cards__r[0].Id);
    }

}

newscorecards = new List<Scorecard__c> ();
List< Scorecard_Answer__c > newscorecardanswers = new List< Scorecard_Answer__c > ();


List<Scorecard__c> oldscorecards = [Select Id, Name, Comment__c, RARE_Campaign__c,
(Select Id, Questions__c, Select_QC_Ids__c, Question_Type2__c, Display_Order__c from Scorecard_Answers__r Order BY Display_Order__c ASC)
    FROM Scorecard__c
    WHERE Id IN :scorecardstocopy];    

for (Scorecard__c osc: oldscorecards) {

    Scorecard__c nsc = new Scorecard__c(RARE_Campaign__c = osc.RARE_Campaign__c, Status__c = 'Active', RecordTypeId = '012800000007kFG');
    newscorecards.add(nsc);
    
        for (Scorecard_Answer__c sca: osc.Scorecard_Answers__r) {
            Scorecard_Answer__c scatemp = new Scorecard_Answer__c();
            scatemp.RecordTypeId = '012800000007kFE';
            scatemp.Scorecard__r = nsc;
            scatemp.Questions__c = sca.Questions__c;
            scatemp.Select_QC_Ids__c = sca.Select_QC_Ids__c;
            scatemp.Display_Order__c = sca.Display_Order__c;
            scatemp.Question_Type2__c = sca.Question_Type2__c;
            newscorecardanswers.add(scatemp);
        }
}


insert newscorecards;
for (Scorecard_Answer__c nsca: newscorecardanswers) {
  // is there a relationship to a parent?
                if (nsca.Scorecard__r != null) {
                    nsca.Scorecard__c = nsca.Scorecard__r.Id; 
                }
}

insert newscorecardanswers;

}

public void generateSubmissionNotice() {
List<Scorecard_Submission__c> NewScorecardSubmissions = new List<Scorecard_Submission__c>();

Map<Id, RARE_Campaign__c> scorecampaigns = new Map<Id, RARE_Campaign__c> (scorecampaigns);

for (Scorecard__c newsc: newscorecards) {
newsc.Submission_Status__c = 'Send Submission Email';
    if (scorecampaigns.containskey(newsc.RARE_Campaign__c) ) {
        RARE_Campaign__c temprc = scorecampaigns.get(newsc.RARE_Campaign__c);
        if (temprc.Campaign_Roles__r.isEmpty() == FALSE) {
        
        for (Team_Roles__c tc: temprc.Campaign_Roles__r) {
            Scorecard_Submission__c ssub = new Scorecard_Submission__c();
            ssub.Scorecard__c = newsc.Id;
            ssub.Role__c = tc.Scorecard_Role__c;
            ssub.Team_Roles__c = tc.Id;
            ssub.Email_Address__c = tc.Member_Name__r.Email;
            NewScorecardSubmissions.add(ssub);
        }
        
        }
    
    }
     
}

insert NewScorecardSubmissions;
update newscorecards;
}

public class ScorecardAnswerSetup {
public Scorecard_Answer__c sa {get;set;}
public Questions__c saquestion {get;set;}
public Boolean bInclude {get;set;}

public ScorecardAnswerSetup (Integer iDisplayOrder, Questions__c question ) {

sa = new Scorecard_Answer__c();
sa.Questions__c = question.Id;
saquestion = question;
sa.Display_Order__c = iDisplayOrder;
}
}

public static List<Questions__c> getAllQuestions () {
    return [Select Id, Name, Question_Text__c FROM Questions__c WHERE RecordTypeId = '012800000007kFC' ORDER By NAME ASC];
}

public static void setAnswerChoices(List<Id> scorecardsIds) {
          Map<Id, Question_Choice__c> qcmap = new Map<Id, Question_Choice__c> ( [Select Id, Points__c FROM Question_Choice__c]);
        
          List<Scorecard_Answer__c> sa = [Select Id, Select_QC_Ids__c from Scorecard_Answer__c WHERE Scorecard__c IN :scorecardsIds];
          List<Question_Choice_Selection__c> questionchoices = new List<Question_Choice_Selection__c>();  
          
          for (Scorecard_Answer__c satemp: sa) {
            List<String> sChoices;
            Decimal iScore = 0;
            if (satemp.Select_QC_Ids__c != NULL) {
                sChoices = satemp.Select_QC_Ids__c.split(';');
                for (String s: sChoices) {
                    if (qcMap.containskey(s)) {
                       iScore += qcmap.get(s).Points__c;
                           String sKey = satemp.Id + ':' + s;
                           questionchoices.add(new Question_Choice_Selection__c(Scorecard_Answer__c = satemp.Id, Question_Choice__c = s, Key__c = sKey));
                    }
               }
           }
           
           satemp.Score__c = iScore;
               }
          
         update sa;
         upsert questionchoices key__c;
        
    }

}