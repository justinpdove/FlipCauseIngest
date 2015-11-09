public with sharing class LeadExtension {

    private final Lead geneoi;
    
    public LeadExtension (ApexPages.StandardController controller) {
        this.geneoi = (Lead)controller.getRecord();
    }

//Confirmation page is the same page with just one section visible - this controls that visibility    
    Boolean showconfirmation = false;
//We pass in the cohort to enable certain dropdowns to be cohort specific    
    String cohort;
    List<SelectOption> options;
    List<SelectOption> optionsal;
    List<SelectOption> optionotype;
    String PickDefault;
    List<String> custompickerrors = new String[3];
          

//set the boolean for the render value
public Boolean getshowconfirmation() {
return showconfirmation;
}

//cohort is passed in - but if there is none, display default values
public String getcohort() {
if (ApexPages.currentPage().getParameters().get('cht') != null) {
cohort = ApexPages.currentPage().getParameters().get('cht');
}
else 
{cohort = 'Default';}
return cohort;
}


//Different cohorts have different options (e.g. a Spanish form could still need to present different countries for different cohorts)
//So we store lists in custom settings

public String getPickDefault(){
if (PickDefault == null)
{
List<PADefaults__c> def = PADefaults__c.getall().values();
for (PADefaults__c d: def) {
if (d.cohort__c.contains(getcohort())) {
PickDefault = d.Picklist_Values__c;
custompickerrors[0] = d.No_Salutation_Error_Msg__c;
custompickerrors[1] = d.No_Country_Error__c;
custompickerrors[2] = d.No_Org_Type_Error_Msg__c;
}
}
}
return PickDefault; 
}

public List<SelectOption> getCountries(){
if (options == null) {
options = EOIDefaults.getCountries(getPickDefault(), getcohort());
}
return options; 
}

public List<SelectOption> getSalutations(){
if (optionsal == null) {
optionsal = EOIDefaults.getSalutations(getPickDefault(), getcohort());
}
return optionsal; 
}

public List<SelectOption> getOrgTypes(){
if (optionotype == null) {
optionotype = EOIDefaults.getOrgTypes(getPickDefault(), getcohort());
}
return optionotype; 
}

public PageReference save(){
          geneoi.RecordTypeId = '01230000000541C';
          geneoi.Web_Cohort__c = getcohort();
            Database.DMLOptions opts = new Database.DMLOptions();
            opts.EmailHeader.triggerAutoResponseEmail = true;
            opts.EmailHeader.triggerUserEmail = true;
            opts.assignmentRuleHeader.useDefaultRule= true;
            geneoi.setOptions(opts);
          insert geneoi;
          showconfirmation = true;
          return null;
}

 
}// end all