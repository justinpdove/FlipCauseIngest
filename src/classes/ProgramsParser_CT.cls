public class ProgramsParser_CT extends MongoDBParser_CT {

public Programs_CT ctPrograms {get;set;}
public List<Program__c> soPrograms;
    
public override void parseData() {
try {

ctPrograms = Programs_CT.parse(sJson);
soPrograms = new List<Program__c>();

    for (Programs_CT.Rows ro: ctPrograms.rows) {
        Program__c p = new Program__c();
        system.debug(ro);    
        p.Name = ro.Name;
        p.Region__c = ro.Region;        
            
        if (ro.sid != NULL) {
                p.CT_Id__c = ro.sid.xoid;
        }
        
    soPrograms.add(p);
    }

}
Catch (Exception Ex) {
    system.debug(Ex);        
}    

}

public override void UpdateRecords() {    
    
    database.upsertresult [] sr = database.upsert(soPrograms, schema.Program__c.CT_Id__c, false);
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