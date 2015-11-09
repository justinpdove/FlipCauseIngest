trigger PreventUIDeletion on Project_Funding__c (Before Delete) {

for (Project_Funding__c p: Trigger.Old) {

if (p.Allocation__c > 0) {
p.adderror('Please set % Allocation to 0 via Project Funding Update Screen before deleting');
}

}

}