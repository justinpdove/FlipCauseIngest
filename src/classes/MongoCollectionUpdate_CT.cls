public class MongoCollectionUpdate_CT {

public static MongoDatabaseAccess ExecuteUpdate(String sCollection, String sParser) {
    MongoDatabaseAccess mda = new MongoDatabaseAccess();
    mda.sEndPoint = 'https://mongodb.rare.org/rarect_prod/' + sCollection + '/';
    Type t = Type.forName(sParser);
    MongoDBParser_CT mdbParser = (MongoDBParser_CT)t.newinstance();  
    
    mda.execute();
        system.debug(mda.bSuccess);
        system.debug(mda.sResponse);

    if (mda.bSuccess) { 
        mdbParser.sJson = mda.sResponse;
        mdbParser.parseData();
        mdbParser.UpdateRecords();
    }
    
    return mda;
}

@future (callout=true)
public static void ScheduledExecuteUpdate (String sCollection, String sParser) {
    MongoCollectionUpdate_CT.ExecuteUpdate(sCollection, sParser);
}

}