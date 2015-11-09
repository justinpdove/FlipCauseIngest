public class MongoDatabaseAccess {

public String sEndPoint {get;set;}
public Boolean bSuccess {get;set;}
public String sResponse {get;set;}
    
    
    public void Execute () {
        bSuccess = FALSE;
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setMethod('GET');
      
        system.debug(sEndPoint);
      
        req.setEndpoint(sEndPoint);
        String sHeader = getAuthHeader();
      
        req.setHeader('Authorization', sHeader);
        try {
            HttpResponse res = http.send(req);
            //System.debug('MONGO Response' + res.getBody());
                if (res.getStatusCode() == 200) {
                bSuccess = TRUE;
                    String sJson = res.getBody();
                    sJson = sJson.replace('_id', 'sid');
                    sJson = sJson.replace('$', 'x');
                    sResponse = sJSON;
                   }
                else {
                sResponse = res.getStatus();    
                }
            }   
        Catch (Exception Ex) {
            sResponse = Ex.getMessage();
        }
    }
    
    private String getAuthHeader() {
        CT_Access_Credentials__c ctcreds = CT_Access_Credentials__c.getinstance();
        String sHeader;
        /*
        String sHeader = 'Digest ';
        sHeader += 'username="' + ctcreds.Username__c + '", ';
        sHeader += 'realm="' + ctcreds.realm__c + '", ';
        sHeader += 'nonce="' + ctcreds.nonce__c + '", ';
        sHeader += 'uri="' + ctcreds.Default_URI__c + '", ';
        sHeader += 'qop=' + ctcreds.qop__c + ', ';
        sHeader += 'nc=' + ctcreds.nc__c + ', ';
        sHeader += 'cnonce="' + ctcreds.cnonce__c + '", ';
        sHeader += 'response="' + ctcreds.Response__c + '", ';
        sHeader += 'opaque=""';
        */
        sHeader = 'Basic ' + ctcreds.Basic_Token__c;
        //system.debug(sHeader);
        return sHeader;   
    }

    public Integer getCount(String sCollection) {
    sEndPoint = 'https://mongodb.rare.org/rarect_prod/$cmd/?filter_count=' + sCollection +'&limit=1';
    Execute ();
    if (bSuccess) {
        MongoCollectionCount mc = MongoCollectionCount.parse(sResponse);
        return mc.rows[0].n;
    }
    return 0;
    }


}