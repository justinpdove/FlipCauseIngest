/**
 * Created by jdove on 11/18/15.
 *
 * Trigger executes main method from CreateOppsFromFlipcause class. First attempt at setting up basic trigger architecture
 * to allow for easier changes to the class, methods, or to add new classes and methods and control the order of
 * execution.
 */

trigger NewTransactions on Flipcause_Transactions__c (before insert) {

    List<Flipcause_Transactions__c> newTransactions = new List<Flipcause_Transactions__c>();

    for(Flipcause_Transactions__c newTrans : Trigger.new){
        newTransactions.add(newTrans);
    }

    CreateOppsFromFlipcause.main(newTransactions);
}