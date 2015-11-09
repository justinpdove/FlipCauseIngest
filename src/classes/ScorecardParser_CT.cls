public class ScorecardParser_CT extends MongoDBParser_CT {

public Scorecards_CT ctScorecards {get;set;}
public List<Scorecard__c> soScorecards;
    
public override void parseData() {

try {


ctScorecards = Scorecards_CT.parse(sJson);
soScorecards = new List<Scorecard__c>();

for (Scorecards_CT.Rows ro: ctScorecards.rows) {
    Scorecard__c q = new Scorecard__c();
    RARE_Campaign__c rc = new RARE_Campaign__c();
    rc.CT_Id__c = ro.campaignsid.xoid;
    q.RARE_Campaign__r = rc;
        q.CT_Id__c = ro.sid.xoid;
        q.Status__c = ro.status;
        q.Grade__c = ro.grade;
        q.Rank__c = ro.rank;
        q.Reviewed__c = ro.reviewed;
        //q.Type__c = ro.section;
        if (ro.due_date != NULL) {
            //String [] sdate = ro.due_date.xdate.split('-');
            //Date myDate = Date.newInstance(integer.valueof(sdate[0]), integer.valueof(sdate[1]), integer.valueof(sdate[2].left(2)));
            q.due_date__c =  convertctdate(ro.due_date.xdate);
            q.name__c = 'Scorecard:' + q.due_date__c.format();
            
        }
        
        if (ro.submission_date != NULL) {
            q.Submission_Date__c = convertctdate(ro.submission_date.xdate);
            }
        
soScorecards.add(q);
}
}
Catch (Exception Ex) {
    system.debug('Scorecard Exception' + Ex);
}

}

public override void UpdateRecords() {    
    
Database.UpsertResult [] sr = Database.upsert(soScorecards, Schema.Scorecard__c.CT_Id__c, false);
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

private date convertctdate(Long ctDate) {
    DateTime myDatetime = DateTime.newInstance(ctDate);
    return myDatetime.date();    
}
    
}