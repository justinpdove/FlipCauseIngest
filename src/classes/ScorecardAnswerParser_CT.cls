public class ScorecardAnswerParser_CT {

public String sJson {get;set;}
public ScorecardAnswers_CT ctAnswer {get;set;}
public Map<String, Object> m {get;set;}
public Integer isuccess {get;set;}
public List< Scorecard_Answer__c > soAnswers;
    
public void parseData() {

try {


ctAnswer = ScorecardAnswers_CT.parse(sJson);
soAnswers = new List< Scorecard_Answer__c >();

for (ScorecardAnswers_CT.Rows ro: ctAnswer.rows) {

    Scorecard_Answer__c qa = new Scorecard_Answer__c();
    
    Questions__c q = new Questions__c();
    Scorecard__c sc = new Scorecard__c();
    qa.CT_Id__c = ro.sid.xoid;
    
        q.CT_Id__c = ro.questionsid.xoid;
        sc.CT_Id__c = ro.scorecardsid.xoid;
        
        qa.Questions__r = q;
        qa.scorecard__r = sc; 
     
        qa.Question_Type2__c = ro.section;
        qa.Score__c = ro.score;
        if (ro.Choices != NULL) {
            system.debug(ro.Choices);
            String sChoices = String.Join(ro.Choices, ';');
            qa.Selected_Choices__c = sChoices;
        }
soAnswers.add(qa);
 
}
        

}

Catch (Exception Ex) {
    system.debug('Answers Exception' + Ex);
}

}

public void UpdateAnswers() {    
    
Database.UpsertResult [] sr = Database.upsert(soAnswers, Schema.Scorecard_Answer__c.CT_Id__c, false);
  isuccess = 0;

for (database.upsertresult sro: sr) {
    if (sro.issuccess() ) {
        isuccess ++;
    }
    else {
        system.debug(sro);
    }

  }
    
}
    
}