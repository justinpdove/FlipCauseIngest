public with sharing class bfc_updateprojectfunding {
/*PNC April 2011
Class to control update grid for Project Funding - link between Projects and Funding (Opty)
*/

public double pctotal {get;set;} //store overall %  - has to equal 100% for update can save
private final Opportunity opty; //funding record
List<cPFund> cPFunds; //list of records in wrapper class

   // The extension constructor initializes the private member variable acct by using the getRecord method from the standard controller. 
    
    public bfc_updateprojectfunding(ApexPages.StandardController stdController) {
        this.opty = (Opportunity)stdController.getRecord();
        pctotal = 0;
    }

//Main Get - selects all Project Funding, add adds to list of wrapper class records to enable deletion functionality
public List<cPFund> getcPFunds () {
if (cPFunds == null) {
cPFunds = new List<cPFund> ();
for (Project_Funding__c pf: [Select Name, Project__c, Allocation__c, Allocated_To__c, Allocated_Amount_Calc__c, Payment_Category__c from Project_Funding__c where Funding__c = :opty.Id order by Allocated_To__c ASC]) {
cPFunds.add(new cPFund(pf));
}
//Finally, calc % - should always be a 100% at this point, but in case of data issues
pctotal = calcpct(cPFunds);
}
return cPFunds;
}



//called from action function on page to update overall % 
public pagereference recalc() {
pctotal = calcpct(cPFunds);
return null;
}

public pagereference updatepf () {
//Main update function
List<Project_Funding__c> delrecords = new List<Project_Funding__c> ();
List<Project_Funding__c> upfrecords = new List<Project_Funding__c> ();

for (cPFund cpf: cPFunds ) {
//first check records marked for deletion = 0
system.debug('Check Delete 1' + cpf);
if (cpf.pfdelete == true) {
    if (cpf.pf.Allocation__c > 0 ) {
        system.debug('Check Delete 2' + cpf);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'All deleted Records must be set to 0%'));
        //if a record fails, clear deleted record list
        if (delrecords.size() > 0) {
        delrecords.clear();
        }
        return null;
      }
    else
    //if it is marked for deletion and % = 0, add to deletion list
        delrecords.add(cpf.pf);
    } 
} //end delete check

//now check allocation of remaing records = 100%
if (calcpct(cPFunds) <> 100) {
//it not return error
ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Allocation % must equal 100%'));
    if (delrecords.size() > 0) {
            delrecords.clear();
     }
    return null;
}
else {
//Re calc split amounts based on % so we can set field for Project Rollup 
    for (cPFund pfu : cPFunds) {
    pfu.pf.Allocated_Amount__c = pfu.pf.Allocated_Amount_Calc__c;
    upfrecords.add(pfu.pf);
    }
//Execute upsert and deletion
    try {
    upsert upfrecords;
    if  (delrecords.size() > 0) {
    system.debug('Any Data?' + delrecords);
    delete delrecords;
    cPFunds = null;
    }
    }
    Catch (Exception Ex) {
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Allocation % must equal 100%'));
    }
    }
    
return null;
} //end update


public pagereference newpf () { //create new record on page
cPFunds.add (new cPFund( new Project_Funding__c(Funding__c = opty.Id, Allocation__c = 0)));
return null;
}

//Calc % Allocation total
double calcpct (cPFund [] PFU) {
pctotal = 0;
for (cPFund p: PFU) {
//only include non deleted records
if (p.pfdelete == false && p.pf.Allocation__c != null) {
pctotal += p.pf.Allocation__c;
}
}
return pctotal;
}

public pageReference cancel(){ //cancel returns to the home page
        pageReference p = new ApexPages.StandardController(opty).view();
        p.setRedirect(true);
        return p;
}

  /* This is our wrapper/container class to enable records to be marked for deletion. */
public class cPFund{
        public Project_Funding__c pf {get; set;}
        public Boolean pfdelete {get; set;}
        
        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property.
        public cPFund(Project_Funding__c pfu){
            pf = pfu;
            pfdelete = false;
            }
}

} //end class