/**
 * Created by jdove on 11/5/15.
 *
 * This class will take data inserted into the Flipcause_Transactions__c object and create Households, Persons,
 * Opportunities, and Payments.
 */

public with sharing class CreateOppsFromFlipcause {


//    TODO - Create a method that checks for existing donors using e-mail address

    public static void newOppsNewDonors(List<Flipcause_Transactions__c> newFlipcauseTransactions) {
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

}