public class EOIDefaults {
//utility class to generate customized picklists for VF Pages

public static List<SelectOption> coptions; //countries
public static List<SelectOption> soptions; //salutations
public static List<SelectOption> otoptions; //org types

//Return just countries for the Cohort specified
public static List<SelectOption> getCountries(String pickdefault, String cohort){
if (coptions == null) {
Map<Decimal,String> sortedcountries = new Map<Decimal,String> ();
coptions = new List<SelectOption>();
coptions.add(new SelectOption('None',pickdefault));
List<Countries__c> gd = Countries__c.getall().values();
for (Countries__c c: gd) {
if (c.cohorts__c.contains(cohort)) {
sortedcountries.put(c.Sort_Order__c,c.Country__c);
}
}

List<Decimal> sortorder = new List<Decimal> ();
sortorder.addall(sortedcountries.keyset());
sortorder.sort();

for (Decimal i: sortorder) {
coptions.add(new SelectOption(sortedcountries.get(i),sortedcountries.get(i)));
}
}
return coptions; 
}


//Return just Salutations for the Cohort specified
public static List<SelectOption> getSalutations(String pickdefault, String cohort){
if (soptions == null) {
Map<Decimal,String> sortedsalu = new Map<Decimal,String> ();
soptions = new List<SelectOption>();
soptions.add(new SelectOption('None',pickdefault));
List<Salutations__c> gd = Salutations__c.getall().values();
for (Salutations__c c: gd) {
if (c.cohort__c.contains(cohort)) {
sortedsalu.put(c.Sort_Order__c,c.Salutations__c);
}
}

List<Decimal> sortorder = new List<Decimal> ();
sortorder.addall(sortedsalu.keyset());
sortorder.sort();

for (Decimal i: sortorder) {
soptions.add(new SelectOption(sortedsalu.get(i),sortedsalu.get(i)));
}
}
return soptions; 
}

//Return just Org Types for the Cohort specified
public static List<SelectOption> getOrgTypes(String pickdefault, String cohort){
if (otoptions == null) {
Map<Decimal,String> sortedot = new Map<Decimal,String> ();
otoptions = new List<SelectOption>();
otoptions.add(new SelectOption('None',pickdefault));
List<Organization_Type__c> gd = Organization_Type__c.getall().values();
for (Organization_Type__c c: gd) {
if (c.cohort__c.contains(cohort)) {
sortedot.put(c.Sort_Order__c,c.Org_Type_Name__c);
}
}

List<Decimal> sortorder = new List<Decimal> ();
sortorder.addall(sortedot.keyset());
sortorder.sort();

for (Decimal i: sortorder) {
otoptions.add(new SelectOption(sortedot.get(i),sortedot.get(i)));
}
}
return otoptions; 
}


}