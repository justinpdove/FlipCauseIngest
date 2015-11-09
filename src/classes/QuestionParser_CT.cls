public class QuestionParser_CT extends MongoDBParser_CT {

public Questions_CT ctQuestions {get;set;}
public List<Questions__c> soQuestions;
public List<Question_Choice__c> soQuestionChoices;
    
public override void parseData() {

try {


ctQuestions = Questions_CT.parse(sJson);
soQuestions = new List<Questions__c>();
soQuestionChoices = new List<Question_Choice__c>(); 

for (Questions_CT.Rows ro: ctQuestions.rows) {
    Questions__c q = new Questions__c();
        q.Name = ro.Name;
        if (ro.question.length() > 255) {
            q.Question_Text__c = ro.question.substring(0,255);
        }
        else {
            q.Question_Text__c = ro.question;
        }
        
        q.CT_Id__c = ro.sid.xoid;
        q.Type__c = ro.section;

        soQuestions.add(q);

 if (ro.choices != NULL) {
        for (Integer i = 0; i <  ro.choices.size(); i++) {
         
            Questions_CT.Choices qc = ro.choices[i];
         
            Questions__c qp = new Questions__c();
            qp.ct_id__c = ro.sid.xoid;
            Question_Choice__c qctemp = new Question_Choice__c();
            qctemp.Questions__r = qp;
            qctemp.Points__c = qc.points;
            qctemp.Order__c = i;
            qctemp.ct_id__c =  qp.ct_id__c + ':' + qctemp.Order__c;
       
            if (qc.choice != NULL) {
                String sChoice = qc.choice;
                if (qc.choice.length() > 255) {
                    sChoice = sChoice.substring(0,255);
                }
            qctemp.Option_Text__c = sChoice;
            }
            soQuestionChoices.add(qctemp);
        }
}


}
        

}

Catch (Exception Ex) {
    system.debug('Questions Exception' + Ex);
}

}

public override void UpdateRecords() {    
    
Database.UpsertResult [] sr = Database.upsert(soQuestions, Schema.Questions__c.CT_Id__c, false);
Database.UpsertResult [] sr2 = Database.upsert(soQuestionChoices, Schema.Question_Choice__c.CT_Id__c, false);

isuccess = 0;

for (database.upsertresult sro: sr) {
    if (sro.issuccess() ) {
        isuccess ++;
    }
    else {
        system.debug(sro);
    }

  }
    
for (database.upsertresult sro: sr2) {
    if (sro.issuccess() ) {
        isuccess ++;
    }
    else {
        system.debug(sro);
    }

}
      
}
    
}