public class bfc_prideonlineform {
   
//These are the holding variables for the page
    public Case pcase;
    public Case pcasenumber {get;set;}
        
    public Contact pcontact;    
    public Contact cmcontact;    
    public Account paccount;    
    public Account cmaccount;
    //for new fellows data
    public Contact ffcontact;    
    public Account ffaccount;    
    
        
//We only show certain sections if there is a Campaign Manager - these control that visibility    
    @testvisible Boolean showorg = false;
    @testvisible Boolean showcon = false;
    @testvisible Boolean accountprocessed = false;
//We only show certain sections if there is a Fishery Fellow - these control that visibility    
    @testvisible Boolean showfforg = false;
    @testvisible Boolean showffcon = false;
    @testvisible Boolean ffaccountprocessed = false;


//Confirmation page is the same page with just one section visible - this controls that visibility    
    @testvisible Boolean showconfirmation = false;
//We pass in the cohort to enable certain dropdowns to be cohort specific    
    String cohort;
    List<SelectOption> options;
    List<SelectOption> optionsal;
    List<SelectOption> optionotype;
    String PickDefault;
    List<String> custompickerrors = new String[3];
    List<PADefaults__c> def;
    PADefaults__c pickdefaults;
 
    public bfc_prideonlineform() {
       def = PADefaults__c.getall().values();
       
       for (PADefaults__c d: def) {

        if (d.cohort__c.contains(getcohort())) {
           pickdefaults = d;
           break;
           }
    }
    
    }
          
//if the dropdown is changed to there is a Campaign Manager, enable the Campaign Manager section to be displayed      
public String ToggleCon() {
if (pcase.Prospective_CM_Identified__c == 'Yes') {
showcon = true;
} 
else
{
//If they change the Campaign Manager dropdown back to No, destroy the Account and Contact variables created    
if (cmaccount!= null){
cmaccount = null;
}
if (cmcontact!= null){
cmcontact = null;
}
showcon = false; 
}

return null;
}
//If the Campaign Manager does not work at the main org, enable the section to be shown
public String ToggleOrg() {
if (pcase.Prospective_CM_Employed_by_LAP__c == 'No') {
showorg = true;
} else { showorg = false; }
return null;
}

//if the dropdown is changed to there is a Fishery Fellow, enable the FF section to be displayed      
public String ToggleConFF() {
if (pcase.Prospective_FF_Identified__c == 'Yes') {
showffcon = true;
} 
else
{
//If they change the Campaign Manager dropdown back to No, destroy the Account and Contact variables created    
if (ffaccount!= null){
ffaccount = null;
}
if (ffcontact!= null){
ffcontact = null;
}
showffcon = false; 
}

return null;
}

//If the FF does not work at the main org, enable the section to be shown
public String ToggleOrgFF() {
if (pcase.Prospective_FF_Employed_by_LAP__c == 'No') {
showfforg = true;
} else { showfforg = false; }
return null;
}

//set the boolean for the render values 
public Boolean getahideshow() {
return showorg;
}

//set the boolean for the render values
public Boolean getchideshow() {
return showcon;
}

//set the FF booleans for the render values 
public Boolean getaffhideshow() {
return showfforg;
}

//set the boolean for the render values
public Boolean getcffhideshow() {
return showffcon;
}


//set the boolean for the render value
public Boolean getshowconfirmation() {
return showconfirmation;
}

//cohort is passed in - but if there is none, display default values
public String getcohort() {
if (ApexPages.currentPage().getParameters().get('cht') != null) {
cohort = ApexPages.currentPage().getParameters().get('cht');
}
else {
cohort = 'Default';
}
return cohort;
}

//create page variables for Contact
public Contact getpContact(){
if (pcontact == null){
pcontact = new Contact();
pcontact.recordtypeid = '0123000000054Ou';
}
return pcontact;    
}

//create page variables for Case
public Case getpcase(){
if (pcase == null){
pcase = new Case();
}
return pcase;    
}

//create page variables for Org
public Account getpaccount(){
if (paccount == null){
paccount = new Account();
paccount.RecordTypeId = '0123000000054PE';
}
return paccount;    
}

//create page variables for Campaign Manager Org
public Account getcmaccount(){
if (cmaccount == null){
cmaccount = new Account();
cmaccount.RecordTypeId = '0123000000054PE';
}
return cmaccount;    
}

//create page variables for Campaign Manager Contact
public Contact getcmContact(){
if (cmcontact == null) {
cmcontact = new Contact();
cmcontact.recordtypeid = '0123000000054Ou';

if (pickdefaults.Bio_Default_Text__c != NULL) {
    cmcontact.Campaign_Manager_Bio_L__c = pickdefaults.Bio_Default_Text__c;
    cmcontact.Campaign_Manager_Bio__c = pickdefaults.Bio_Default_Text__c;
}
}

return cmcontact;    
}

//create page variables for FF Org
public Account getffaccount(){
if (ffaccount == null){
ffaccount = new Account();
ffaccount.RecordTypeId = '0123000000054PE';
}
return ffaccount;    
}

//create page variables for FF Contact
public Contact getffContact(){
if (ffcontact == null) {
ffcontact = new Contact();
ffcontact.recordtypeid = '0123000000054Ou';
}
return ffcontact;    
}

//Before we save the Contact from the page, we check for an existing match based on email address
public Contact checkforContact(Contact cmatch, Boolean addrupdate){
Contact matchcontact = new Contact();
Contact[] pccheck = [Select Id from Contact where email = :cmatch.email order by lastmodifieddate desc];
//If there's more than one match, we choose the most recently updated
if (pccheck.size() > 0) {
matchcontact = pccheck[0];

//we always update Degree and Bio Information
matchcontact.Has_BA_degree__c = cmatch.Has_BA_degree__c;
matchcontact.Campaign_Manager_Bio__c = cmatch.Campaign_Manager_Bio__c;
//If there is a match, set the entered address to update contact in SF if required
if (addrupdate == TRUE) {
matchcontact.FirstName = cmatch.firstname;
matchcontact.LastName = cmatch.lastname;
matchcontact.Phone = cmatch.phone;
matchcontact.Title = cmatch.Title;
matchcontact.MailingStreet = cmatch.MailingStreet;
matchcontact.MailingCity = cmatch.MailingCity;
matchcontact.MailingState = cmatch.MailingState;
matchcontact.MailingCountry = cmatch.MailingCountry;
matchcontact.MailingPostalCode = cmatch.MailingPostalCode; }
}
else
{
//if not match, use contact as entered  
matchcontact= cmatch;
}
return matchcontact;
}

//Before we save the Org from the page, we check for an existing match based on Org Name
public Account checkforAccount(Account amatch){
Account matchAccount = new Account();
Account[] pacheck = [Select Id from Account where name = :amatch.name];
if (pacheck.size() > 0) {
matchAccount = pacheck[0];
}
else
{
matchAccount = amatch;
}
return matchAccount;
}

//Different cohorts have different options (e.g. a Spanish form could still need to present different countries for different cohorts)
//So we store lists in custom settings

public String getPickDefault(){
if (PickDefault == null) {
    
            PickDefault = pickdefaults.Picklist_Values__c;
            custompickerrors[0] = pickdefaults.No_Salutation_Error_Msg__c;
            custompickerrors[1] = pickdefaults.No_Country_Error__c;
            custompickerrors[2] = pickdefaults.No_Org_Type_Error_Msg__c;
    }
return PickDefault; 
}


public List<SelectOption> getCountries(){
if (options == null)
{
options = new List<SelectOption>();
options.add(new SelectOption('None',getPickDefault()));
List<Countries__c> gd = Countries__c.getall().values();
for (Countries__c c: gd) {
if (c.cohorts__c.contains(getcohort())) {
options.add(new SelectOption(c.Country__c,c.Country__c));
}
}
}
return options; 
}

public List<SelectOption> getSalutations(){
if (optionsal == null)
{
optionsal = new List<SelectOption>();
optionsal.add(new SelectOption('None',getPickDefault()));
List<Salutations__c> sal = Salutations__c.getall().values();
for (Salutations__c s: sal) {
if (s.cohort__c.contains(getcohort())) {
optionsal.add(new SelectOption(s.Salutations__c,s.Salutations__c));
}
}
}
return optionsal; 
}

public List<SelectOption> getOrgTypes(){
if (optionotype == null)
{
optionotype = new List<SelectOption>();
optionotype.add(new SelectOption('None',getPickDefault()));
List<Organization_Type__c> ot = Organization_Type__c.getall().values();
for (Organization_Type__c o: ot) {
if (o.cohort__c.contains(getcohort())) {
optionotype.add(new SelectOption(o.Org_Type_Name__c,o.Org_Type_Name__c));
}
}
}
return optionotype; 
}

//The final submit function
public PageReference save(){
//In case we rollback the form, we need to reset the paaccount

try{

if (pcontact.Salutation == 'None')
{
throw new My1Exception(custompickerrors[0]);  

}

if (pcontact.MailingCountry == 'None')
{
throw new My1Exception(custompickerrors[1]); 
}

if (paccount.Segment__c == 'None')
{
throw new My1Exception(custompickerrors[2]); 
}



//First check to see if Contact/Org exists
Contact casecontact = checkforContact(pcontact, true);
Account caseaccount = checkforAccount(paccount);
//upsert Org first = we need to upsert Contact a bit later
caseaccount.Applying_for_Cohort__c = getcohort();
upsert caseaccount;


//As well as checking to see main Contact exists, we also check the Campaign Manager info it it was entered. We create two variables to store the query
Contact cmpmgrcontact;
Account cmpmgraccount;

if (cmaccount!=null ) 
{
cmpmgraccount =  checkforAccount(cmaccount);
cmpmgraccount.Applying_for_Cohort__c = getcohort();
upsert cmpmgraccount;
}
else
{
cmpmgraccount = caseaccount;
}

//if Account Id is null, set it to the Org we've already upserted

if (casecontact.AccountId == null)
{

casecontact.AccountId = caseaccount.id;
}
//now update Contact
casecontact.Applying_for_Cohort__c = getcohort();
upsert casecontact;

//Campaign Manager Updates
if (cmcontact != null) {
cmpmgrcontact = cmcontact;
cmpmgrcontact.AccountId = cmpmgraccount.Id;
cmpmgrcontact.Applying_for_Cohort__c = getcohort();
insert cmpmgrcontact;
}

//FF Data
//As well as checking to see main Contact exists, we also check the Campaign Manager info it it was entered. We create two variables to store the query
Contact ff1contact;
Account ff1account;

if (ffaccount!=null ) 
{
ff1account =  checkforAccount(ffaccount);
ff1account.Applying_for_Cohort__c = getcohort();
upsert ff1account;
}
else
{
ff1account = caseaccount;
}

if (ffcontact != null) {
ff1contact = ffcontact;
ff1contact.AccountId = ff1account.Id;
ff1contact.Applying_for_Cohort__c = getcohort();
insert ff1contact;
}

//Finally, set values for Case and insert
pcase.Cohort__c = getcohort();
pcase.Priority = 'Interested';
pcase.ContactId = casecontact.Id;
pcase.AccountId = caseaccount.Id; 
pcase.Country__c = casecontact.MailingCountry;
if (pcase.Barrier_Removal_Activities_at_Site_IN__c != null) {
pcase.Barrier_Removal_Activities_at_Site__c = pcase.Barrier_Removal_Activities_at_Site_IN__c;
}
//update Campaign Manager Reference
if (cmpmgrcontact != null){
pcase.Campaign_Manager__c = cmpmgrcontact.Id;
}
//update FF Lookup
if (ff1contact != null){
pcase.Fisheries_Fellows__c = ff1contact.Id;
}

//finally, insert the application, and trigger the auto response email
Database.DMLOptions opts = new Database.DMLOptions();
opts.EmailHeader.triggerAutoResponseEmail = true;
opts.EmailHeader.triggerUserEmail = true;
opts.assignmentRuleHeader.useDefaultRule= true;
pcase.setOptions(opts);

insert pcase;
//Refresh to get number
pcasenumber = [Select Id, CaseNumber from Case where Id = :pcase.Id];
//Now display page with confirmation
showconfirmation = true;
return null;
}
catch (Exception ex) {
//Since error messages are translated, we'll go with standard errors. If it later proves necessary though, we'll create a new exception class
ApexPages.addMessages(ex);
system.debug(ex);
return null;
}
//end save
}



}