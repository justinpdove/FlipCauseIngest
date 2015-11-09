public class MongoDatabaseBatchUpdate implements Database.batchable <Integer>, Database.AllowsCallouts, Database.Stateful { 
public List<Integer> irows; 
public String sLimit; 
public String sCollection;    
MongoDatabaseBatchHandler MDBH;
   
   public Iterable<Integer> start(Database.batchableContext info){ 
   
    MDBH = new MongoDatabaseBatchHandler();
    MDBH.sCollection = sCollection;
    
    if (!test.IsRunningTest() ) {
        MDBH.BatchStart(integer.valueof(sLimit));
    }
       else {
           return new List<Integer>{0};
       }
   
    return MDBH.irows; 
    } 
       
   public void execute(Database.batchableContext info, List<Integer> scope){ 
    MDBH = new MongoDatabaseBatchHandler();
    
    if (!test.IsRunningTest() ) {
        MDBH.BatchExecute(scollection, scope, sLimit);
    }
    
   }     

   public void finish(Database.batchableContext info){     
   
   }
}