global class ScheduledBatchHandler implements Schedulable{

global Database.Batchable<Integer> batchClass{get;set;}
global Integer batchSize {get;set;} 
global String sClass {get;set;}
global List<String> sParams {get;set;}


global void execute(SchedulableContext sc) {
if (batchClass != NULL) {
    database.executebatch(batchClass, batchSize);
}
else if( sClass != NULL) {
    Type t = Type.forName(sClass);
    Object s = t.newinstance(); 
}
else if (sParams != NULL) {
MongoCollectionUpdate_CT.ScheduledExecuteUpdate(sParams[0], sParams[1]); 
}

}

}