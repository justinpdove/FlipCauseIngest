public with sharing class CTIntegrationController_CT {
public MongoDatabaseAccess mda {get;set;}
public Boolean bShowCampaignSubmitted {get;set;}
public Boolean bShowAnswersSubmitted {get;set;}
public MongoDBParser_CT mdbParser {get;set;}


public pageReference RefreshPrograms() {
mda = MongoCollectionUpdate_CT.ExecuteUpdate('programs', 'ProgramsParser_CT');
return null;
}

public pageReference RefreshScorecards() {
mda = MongoCollectionUpdate_CT.ExecuteUpdate('scorecards', 'ScorecardParser_CT');
return null;
}

public pageReference RefreshQuestions() {
mda = MongoCollectionUpdate_CT.ExecuteUpdate('questions', 'QuestionParser_CT');
return null;
}
/*

public pageReference RefreshCampaigns() {
MongoDatabaseBatchCreation.execute('campaigns', 1, 10);
bShowCampaignSubmitted = TRUE;
return null;
}

public pageReference RefreshAnswers() {
MongoDatabaseBatchCreation.execute('answers',1000, 1);
bShowAnswersSubmitted = TRUE;
return null;
}

public pageReference RefreshOrganizations() {
mda = MongoCollectionUpdate_CT.ExecuteUpdate('organizations', 'OrganizationsParser_CT');
return null;
}

public pageReference RefreshUsers() {
mda = MongoCollectionUpdate_CT.ExecuteUpdate('users', 'UserParser_CT');
return null;
}

*/



}