/*
 * Created by jdove on 11/5/15.
 *
 * This class will take data inserted into the Flipcause_Transactions__c object and create Households, Persons,
 * Opportunities, and Payments.
 */

public with sharing class CreateOppsFromFlipcause {

    public static void main(List<Flipcause_Transactions__c> newFlipTransactions) {
        List<Flipcause_Transactions__c> newDonors = new List<Flipcause_Transactions__c>();
        List<Flipcause_Transactions__c> currentDonors = new List<Flipcause_Transactions__c>();

//      Add Emails from new FlipCause transactions into a set; emails will be passed into getConIdByEmail method.
        Set<String> contactEmailSet = new Set<String>();
        for(Flipcause_Transactions__c newFlips : newFlipTransactions){
            if(!String.isBlank(newFlips.Email__c)){
                try{
                    contactEmailSet.add(newFlips.Email__c);
                } catch(Exception e){
                    System.debug('This email is already in the set: ' + newFlips.Email__c);
                }
            }
        }

//      Create a new map from the emails in the set
        Map<String, Id> emailToContactMap = getConIdsByEmail(contactEmailSet);

//      Iterate through new transactions, check to see if they exist based on the emailToContactMap
//      If they exist, create records via newOppsCurrentDonors, else create records via newOppsNewDonors method
        for (Flipcause_Transactions__c newFlips : newFlipTransactions){
            if(emailToContactMap.containsKey(newFlips.Email__c)){
//              If the email exists, add the contact Id to the transaction record in the FlipCause transaction table,
//              which is a  lookup field. Through the Contact lookup, you can get the AccountId to create Opps.
                newFlips.Contact_Id__c = emailToContactMap.get(newFlips.Email__c);
//              update newFlips;
                currentDonors.add(newFlips);
            } else {
                newDonors.add(newFlips);
            }
        }

        newOppsCurrentDonors(currentDonors);
        newOppsNewDonors(newDonors);
    }

/*
 *    newOppsNewDonors method simply takes the data from the Flipcause_Transactions__c object
 *    and creates a new Household, Contact, Opportunity, Payment, and Project Allocation record.
 *    This method should be called only after determining that a particular donor does not currently
 *    exist.
 */

    private static void newOppsNewDonors(List<Flipcause_Transactions__c> newFlipcauseTransactions) {
        String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year'
                                    AND StartDate <= TODAY and EndDate >= TODAY].FiscalYearSettings.Name;

        for(Flipcause_Transactions__c newFlips : newFlipcauseTransactions) {
            Account household = new Account(
                    Name='The ' + newFlips.First_Name__c + ' ' + newFlips.Last_Name__c + ' Household'
            );
            insert household;

            Contact con = new Contact(
                    AccountId = household.Id,
                    FirstName = newFlips.First_Name__c,
                    LastName = newFlips.Last_Name__c,
                    RecordTypeId = '0123000000054Oz', // Hardcoding is bad!
                    Contact_Type__c = 'Individual - Member',
                    Status__c = 'Donor',
                    LeadSource = 'Web',
                    Referral_Date__c = newFlips.Transaction_Date__c,
                    Email = newFlips.Email__c,
                    MailingStreet = newFlips.Address__c,
                    MailingCity = newFlips.City__c,
                    MailingState = newFlips.State__c,
                    Phone = newFlips.Phone__c,
                    MailingPostalCode = newFlips.Postal_Code__c
            );
            insert con;

            Opportunity fund = new Opportunity(
                    AccountId = household.Id,
                    RecordTypeId = '012300000005TlN', // Hardcoding is bad!
                    Name = con.FirstName + ' ' + con.LastName + ' - Donation ' + newFlips.Transaction_Date__c,
                    CloseDate = newFlips.Transaction_Date__c,
                    Gift_Allocated_to_Segment__c = 'Individual',
                    Amount = newFlips.Donation_Amount__c,
                    Probability = 100,
                    StageName = 'Closed Won',
                    Comments__c = newFlips.Message__c
            );
            insert fund;

            OpportunityContactRole role = new OpportunityContactRole(
                    ContactId = con.Id,
                    OpportunityId = fund.Id,
                    Role = 'Donor'
            );
            insert role;

            Payments__c payment = new Payments__c(
                    RecordTypeId = '012300000005VFC', // Hardcoding is bad!
                    Opportunity__c = fund.Id,
                    Payment_Date__c = newFlips.Transaction_Date__c,
                    Payment_Amount__c = newFlips.Amount__c,
                    Pledge_Year__c = currentFiscalYear,
                    Payment_Status__c = 'Received',
                    Payment_Method__c = newFlips.Card_Brand__c
            );
            insert payment;

        }
    }

    private static void newOppsCurrentDonors(List<Flipcause_Transactions__c> currentDonors){
//      TODO – Need to lookup how to create a global variable.
        Set<Id> currentDonorIds = new Set<Id>();
        String currentFiscalYear = [SELECT FiscalYearSettings.Name FROM Period WHERE Type = 'Year'
                                    AND StartDate <= TODAY and EndDate >= TODAY].FiscalYearSettings.Name; // This is so dumb ... why can't I create a global variable???

        for(Flipcause_Transactions__c cd : currentDonors) {
            if(cd.Contact_Id__c != null){
                currentDonorIds.add(cd.Contact_Id__c);
            }
        }

        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, AccountId, FirstName, LastName FROM Contact WHERE Id IN :currentDonorIds]);

        for(Flipcause_Transactions__c cd : currentDonors) {
            Opportunity fund = new Opportunity(
                    AccountId = contactMap.get(cd.Contact_Id__c).AccountId,
                    RecordTypeId = '012300000005TlN', // Hardcoding is bad!
                    Name = contactMap.get(cd.Contact_Id__c).FirstName + ' ' + contactMap.get(cd.Contact_Id__c).LastName + ' - Donation ' + cd.Transaction_Date__c,
                    CloseDate = cd.Transaction_Date__c,
                    Gift_Allocated_to_Segment__c = 'Individual',
                    Amount = cd.Donation_Amount__c,
                    Probability = 100,
                    StageName = 'Closed Won',
                    Comments__c = cd.Message__c
            );
            insert fund;

            OpportunityContactRole role = new OpportunityContactRole(
                    ContactId = cd.Contact_Id__c,
                    OpportunityId = fund.Id,
                    Role = 'Donor'
            );
            insert role;

            Payments__c payment = new Payments__c(
                    RecordTypeId = '012300000005VFC', // Hardcoding is bad!
                    Opportunity__c = fund.Id,
                    Payment_Date__c = cd.Transaction_Date__c,
                    Payment_Amount__c = cd.Amount__c,
                    Pledge_Year__c = currentFiscalYear,
                    Payment_Status__c = 'Received',
                    Payment_Method__c = cd.Card_Brand__c
            );
            insert payment;
        }
    }

    /*
     *  The only Id that connects Salesforce Contacts to FlipCause donors is email address. I want to query for all e-mail
     *  addresses we have and return a map of email addresses to Ids for Contacts that exist.
     */

    private static Map<String, Id> getConIdsByEmail(Set<String> flipEmails) {
        List<AggregateResult> emailContacts = [SELECT Email, Id, Count(Name) theCount FROM Contact WHERE Email IN :flipEmails GROUP BY Email, Id ORDER BY Email ASC]; // This doesn't work ... the count will always be 1 because the Ids will be different

        Map<String, Id> emailToContactMap = new Map<String, Id>();

//      TODO - Add logic to choose between more than 1 contact instead of tossing any emails that show up more than once.
        for(AggregateResult con : emailContacts){
            if(!(con.get('theCount') != 1)){  // For now, if there is more than one result per e-mail, then we'll ignore it and create a new contact.
                emailToContactMap.put((String)con.get('Email'),(Id)con.get('Id'));
            }
        }

        return emailToContactMap;
    }

}