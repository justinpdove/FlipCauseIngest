public class MongoDatabaseBatchHandler {
    public String sCollection;
    public Integer sOffset;
    public List<integer> irows;
    
    public void BatchStart(Integer ilimit) {
    
    MongoDatabaseAccess mda = new MongoDatabaseAccess();
        Integer iTotalCount = mda.getCount(sCollection);

        irows = new List<Integer>();
        for (integer i =0; i< iTotalCount; i+= ilimit) {
            irows.add(i);
        }
        system.debug(irows);
    }

    public void BatchExecute(String sCollection, List<Integer> iScope, String sLimit) {
    List<CampaignsParser_CT> ctlist = new List<CampaignsParser_CT>();
        MongoDatabaseAccess mda = new MongoDatabaseAccess();
        for (Integer i: iscope) {
            mda.sEndPoint = 'https://mongodb.rare.org/rarect_prod/' + sCollection + '/?skip=' + String.Valueof(i) + '&limit=-' + sLimit;
            mda.execute();
            //system.debug(mda.sResponse);
            if (mda.bSuccess) {
            if (sCollection == 'campaigns') {
                CampaignsParser_CT cpct = new CampaignsParser_CT();
                cpct.sEndPoint = mda.sEndPoint;
                cpct.parsedata(mda.sResponse);
                ctlist.add(cpct);
            
                
            }
            else if (sCollection == 'answers') {
                ScorecardAnswerParser_CT ppct = new ScorecardAnswerParser_CT();
                ppct.sJson = mda.sResponse;
                ppct.parseData();
                ppct.UpdateAnswers();
            }
               
            }
        
    }   
    if (sCollection == 'campaigns') {
            for (CampaignsParser_CT cp: ctlist) {
                    cp.updatecampaigns();
            }
    }
    
}

}