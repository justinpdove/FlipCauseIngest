@isTest
public class MongoIntegration_TESTS {

@isTest
private static void MongoBaseParser() {
    MongoDBParser_CT mct = new MongoDBParser_CT();
    mct.parseData();
    mct.UpdateRecords();    
}

@isTest
private static void ProgramsParseTest() {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/programs/', 'Programs115JSON');
multimock.setStatusCode(200);

Program__c testp = new Program__c();
testp.Name = 'Test Program';
testp.CT_Id__c = '5371ba243436345962310000';
insert testp;

CTIntegrationController_CT ctic = new CTIntegrationController_CT();


test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    ctic.RefreshPrograms();
    test.stoptest();
 
 system.assertequals(TRUE, ctic.mda.bSuccess);
 List<Program__c> programs = [Select Id, Name, Region__c FROM Program__c];
 system.assertequals(42, programs.size()); 
 
 Program__c testpconfirm = [Select Name, CT_Id__c FROM Program__c WHERE Id = :testp.Id];
 system.assertequals('PEP4', testpconfirm.Name);
}

@isTest
private static void ParseProgramCoverage () {

Programs_CT testp = Programs_CT.parse(getJSON('Programs115JSON'));

system.assertequals(testp.rows[0].Name, 'Guad10');
system.assertequals(testp.rows[0].region, 'Latin America');
system.assertequals(testp.rows[0].rare_region, 'Guad');
system.assertequals(testp.rows[0].sid.xoid, '52df196f3436342d96000000');
system.assertequals(testp.rows[0].created_at.xdate, 1390352751000L);
system.assertequals(testp.rows[0].updated_at.xdate, 1403726854000L);

system.assertequals(0, testp.offset);
system.assertequals(42, testp.total_rows);

}



@isTest
private static void QuestionsParseTest() {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/questions/', 'Questions115JSON');
multimock.setStatusCode(200);

Questions__c testq = new Questions__c();
testq.Name = 'Test Question';
testq.CT_Id__c = '53611c2a343634038c040000';
insert testq;

CTIntegrationController_CT ctic = new CTIntegrationController_CT();


test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    ctic.RefreshQuestions();
    test.stoptest();
 
 system.assertequals(TRUE, ctic.mda.bSuccess);
 List<Questions__c> questions = [Select Id, Name, Question_Text__c, Type__c FROM Questions__c ORDER BY NAME ASC];
 system.assertequals(23, questions.size()); 
 
 system.assertequals('a.', questions[0].name);
 system.assertequals('Capacity', questions[0].Type__c);

}


@isTest
private static void ParseQuestionCoverage () {

Questions_CT testq = Questions_CT.parse(getJSON('Questions115JSON'));
system.debug(testq.rows[0]);

system.assertequals(null, testq.rows[0].autofill);

system.assert(testq.rows[0].choices[0].choice.contains('0-19 points'));
system.assertequals(null, testq.rows[0].choices[0].notes);
system.assertequals(1, testq.rows[0].choices[0].points);

system.assertequals(true, testq.rows[0].collapse);
system.assertequals(true, testq.rows[0].comments);

//system.assert(testq.rows[0].help.contains('demonstrated the behavior (in any capacity)'));

system.assertequals('radio', testq.rows[0].kind);
system.assertequals('a.', testq.rows[0].name);
system.assertequals(true, testq.rows[0].next_steps);
system.assertequals(1, testq.rows[0].order);
system.assert(testq.rows[0].question.contains('latest Pride Skills assessment')); 
system.assertequals(true, testq.rows[0].scoreable);
system.assertequals('capacity', testq.rows[0].section);

system.assertequals(testq.rows[0].sid.xoid, '53611c2a343634038c000000');

}

@isTest
private static void ScorecardsParseTest() {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/scorecards/', 'Scorecards115JSON');
multimock.setStatusCode(200);

RARE_Campaign__c testrc = new RARE_Campaign__c();
testrc.CT_Id__c = '52dee53a3436340879170000';
testrc.Name = 'Test RC';
testrc.Primary_PPM__c = 'Test PPM';
insert testrc;

CTIntegrationController_CT ctic = new CTIntegrationController_CT();


test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    ctic.RefreshScorecards();
    test.stoptest();
 
 system.assertequals(TRUE, ctic.mda.bSuccess);
 List<Scorecard__c> scorecards = [Select Id, Name, Capacity_Score__c, Conservation_Score__c, Constituency_Score__c,
 Due_Date__c, Grade__c, Name__c, Rank__c, Reviewed__c, Score__c, Status__c, Submission_Date__c, Total_Score__c
 FROM Scorecard__c];
 system.assertequals(6, scorecards.size());
 
 system.assertequals('green', scorecards[0].Grade__c); 
 system.assertequals(true, scorecards[0].Reviewed__c); 
 system.assertequals(3, scorecards[0].Rank__c); 
 
 Date testd = Date.NewInstance(2014,4,24);
 system.assertequals(testd, scorecards[0].Due_Date__c); 
 
 testd = Date.NewInstance(2014,5,5);
 system.assertequals(testd, scorecards[0].Submission_Date__c); 
 
 system.assertequals('approved', scorecards[0].Status__c); 
 system.assertequals(0, scorecards[0].Total_Score__c); 
 }

@isTest
private static void ParseScorecardCoverage () {

Scorecards_CT testsc = Scorecards_CT.parse(getJSON('Scorecards115JSON'));
system.debug(testsc.rows[0]);
system.assertequals(14, testsc.rows[0].capacity_score);
system.assertequals(4, testsc.rows[0].conservation_score);
system.assertequals(4, testsc.rows[0].constituency_score);
//system.assert(testsc.rows[0].due_date.xdate.startswith('2014-04-24') );
//system.assert(testsc.rows[0].submission_date.xdate.startswith('2014-04-29') );

system.assertequals('constituency', testsc.rows[0].current_section);
system.assertequals('green', testsc.rows[0].grade);
system.assertequals(5, testsc.rows[0].rank);
system.assertequals(NULL, testsc.rows[0].report_id);
system.assertequals(true, testsc.rows[0].reviewed);
system.assertequals(NULL, testsc.rows[0].saver_id);
system.assertequals(22, testsc.rows[0].score);
system.assertequals('approved', testsc.rows[0].status);

system.assertequals(testsc.rows[0].sid.xoid, '536146d934363422a7010000');
system.assertequals(testsc.rows[0].campaignsid.xoid, '52dee6a034363408791a0000');
//system.assert(testsc.rows[0].created_at.xdate.startswith('2014-04-30') );
//system.assert(testsc.rows[0].updated_at.xdate.startswith('2014-08-13') );

}

@isTest
private static void ScorecardAnswerParseTest() {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/answers/?skip=0&limit=-1000', 'ScorecardAnswers115JSON');
multimock.setStatusCode(200);

RARE_Campaign__c testrc = new RARE_Campaign__c();
testrc.CT_Id__c = '52dee53a3436340879170000';
testrc.Name = 'Test RC';
testrc.Primary_PPM__c = 'Test PPM';
insert testrc;

Scorecard__c score = new Scorecard__c();
score.RARE_Campaign__c = testrc.Id;
score.CT_Id__c = '536146d934363422a7010000';
insert score;

Questions__c ctquestion = new Questions__c();
ctquestion.Name = 'e.';
ctquestion.CT_Id__c = '53611c2a343634038c000000';
insert ctquestion;

ctquestion = new Questions__c();
ctquestion.Name = 'f.';
ctquestion.CT_Id__c = '53611c2a343634038c010000';
insert ctquestion;



List<Integer> iList = new List<Integer> {0};
MongoDatabaseBatchHandler mdbh = new MongoDatabaseBatchHandler();
test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    mdbh.BatchExecute('answers', iList, '1000');
    test.stoptest();
 
 List< Scorecard_Answer__c > scorecardanswers = [Select Id, Questions__c, Scorecard__c  FROM Scorecard_Answer__c];
 system.assertequals(2, scorecardanswers.size());
 
 
 }

@isTest
private static void ParseScorecardAnswersCoverage () {

ScorecardAnswers_CT testsca = ScorecardAnswers_CT.parse(getJSON('Answers115JSON'));
system.debug(testsca.rows[33]);
system.assertequals('constituency', testsca.rows[33].section);
system.assertequals(5, testsca.rows[33].score);
system.assertequals(true, testsca.rows[33].reviewed);


system.assertequals('0', testsca.rows[33].choices[0]);
system.assertequals('1', testsca.rows[33].choices[1]);

system.assertequals(testsca.rows[33].sid.xoid, '544521ab3436345e8f0c0000');
system.assertequals(testsca.rows[33].questionsid.xoid, '53611c2a343634038c0d0000');
system.assertequals(testsca.rows[33].scorecardsid.xoid, '544513ee34363452db010000');

system.assertequals(testsca.rows[33].created_at.xdate, 1413816747010L);

}

@isTest
private static void CampaignParseTest() {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/campaigns/?filter_project_code=KALIMA&limit=-1', 'CampaignKalima115JSON');
multimock.setStatusCode(200);

Program__c testp = new Program__c();
testp.Name = 'Test Program';
testp.CT_Id__c = '5371ba103436345962060000';
insert testp;

RARE_Campaign__c testrc = new RARE_Campaign__c();
testrc.CT_Id__c = '52dec90e3436347dd3b00800';
testrc.Name = 'KALIMA Test';
testrc.Project_Code__c = 'KALIMA';
testrc.Primary_PPM__c = 'Test PPM';
insert testrc;

MongoCampaignParserController mcpc = new MongoCampaignParserController(new ApexPages.StandardController(testrc));

test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    mcpc.parseData();
    mcpc.ReturntotRC();
 test.stoptest();
 
 system.assertequals(TRUE, mcpc.mda.bSuccess);
 Rare_Campaign__c testconfirm = [Select Id, Name, Status__c, (Select Id, Name, Due_Date__c from Milestones__r Order BY Due_Date__c ASC ), (Select Id, Name, Date__c from Flash_Cards__r Order BY Date__c ASC) FROM Rare_Campaign__c];
 /*
 system.assertequals('Sagnay, Camarines Sur, Philippines - Sustainable Fisheries', testconfirm.Name);
 system.assertequals('Active', testconfirm.Status__c);
 system.assertequals(60,testconfirm.Milestones__r.size());
 
 system.assertequals(date.newinstance(2012, 09, 05), testconfirm.Milestones__r[0].Due_Date__c); 
 system.assertequals(date.newinstance(2016, 12, 31), testconfirm.Milestones__r[59].Due_Date__c); //10:21:14:272 USER_DEBUG [42]|DEBUG|2016-12-31 00:00:00
  
 system.assertequals(43, testconfirm.Flash_Cards__r.size());
 
 system.assertequals(date.newinstance(2014, 01, 26), testconfirm.Flash_Cards__r[0].Date__c); //10:21:14:272 USER_DEBUG [46]|DEBUG|2014-01-26 00:00:00
 system.assertequals(date.newinstance(2014, 11, 16), testconfirm.Flash_Cards__r[42].Date__c); //10:21:14:273 USER_DEBUG [47]|DEBUG|2014-11-16 00:00:00
 */
 
}

@isTest
private static void CampaignParseTestMilestoneFiles() {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/campaigns/?filter_project_code=BFARSA&limit=-1', 'CampaignBFARSA115JSON');
multimock.setStatusCode(200);

Program__c testp = new Program__c();
testp.Name = 'Test Program';
testp.CT_Id__c = '5371ba243436345962310000';
insert testp;

RARE_Campaign__c testrc = new RARE_Campaign__c();
testrc.CT_Id__c = '52dec9093436347dd3120000';
testrc.Name = 'BFARSA Test';
testrc.Project_Code__c = 'BFARSA';
testrc.Primary_PPM__c = 'Test PPM';
insert testrc;

MongoCampaignParserController mcpc = new MongoCampaignParserController(new ApexPages.StandardController(testrc));

test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    mcpc.parseData();
    mcpc.ReturntotRC();
 test.stoptest();
 
 system.assertequals(TRUE, mcpc.mda.bSuccess);
 Rare_Campaign__c testconfirm = [Select Id, Name, Status__c, (Select Id, Name, Due_Date__c from Milestones__r Order BY Due_Date__c ASC ), (Select Id, Name, Date__c from Flash_Cards__r Order BY Date__c ASC) FROM Rare_Campaign__c];
 /*
 system.assertequals('Sagnay, Camarines Sur, Philippines - Sustainable Fisheries', testconfirm.Name);
 system.assertequals('Active', testconfirm.Status__c);
 system.assertequals(60,testconfirm.Milestones__r.size());
 
 system.assertequals(date.newinstance(2012, 09, 05), testconfirm.Milestones__r[0].Due_Date__c); 
 system.assertequals(date.newinstance(2016, 12, 31), testconfirm.Milestones__r[59].Due_Date__c); //10:21:14:272 USER_DEBUG [42]|DEBUG|2016-12-31 00:00:00
  
 system.assertequals(43, testconfirm.Flash_Cards__r.size());
 
 system.assertequals(date.newinstance(2014, 01, 26), testconfirm.Flash_Cards__r[0].Date__c); //10:21:14:272 USER_DEBUG [46]|DEBUG|2014-01-26 00:00:00
 system.assertequals(date.newinstance(2014, 11, 16), testconfirm.Flash_Cards__r[42].Date__c); //10:21:14:273 USER_DEBUG [47]|DEBUG|2014-11-16 00:00:00
 */
 
}

@isTest
private static void CampaignParseCoverage() {

Campaigns_CT testc = Campaigns_CT.parse(getJSON('CampaignBFARSA115JSON'));
//system.debug(testc.rows[0]);

system.assertequals('52dec9093436347dd3120000', testc.rows[0].sid.xoid);
system.assertequals('5371ba243436345962310000', testc.rows[0].programsid.xoid);
system.assertequals('BFARSA', testc.rows[0].project_code);

//system.assert(testc.rows[0].created_at.xdate.startswith('2014-01-21') );
//system.assert(testc.rows[0].updated_at.xdate.startswith('2014-10-28') );

system.assertequals('completed', testc.rows[0].campaign_status);
system.assertequals(false, testc.rows[0].fish_forever);

system.assertequals('Philippines', testc.rows[0].location.country);
system.assertequals('Sagnay, Camarines Sur', testc.rows[0].location.name);
system.assertequals('13.6', testc.rows[0].location.latitude);
system.assertequals('123.52', testc.rows[0].location.longitude);

system.assertequals('', testc.rows[0].mission);
system.assertequals('Sagnay, Camarines Sur, Philippines - Sustainable Fisheries', testc.rows[0].name);
system.assertequals('41184', testc.rows[0].nid);
system.assertequals('Southeast Asia', testc.rows[0].region);
system.assertequals('Philippines', testc.rows[0].rare_region);

system.assertequals('52decbac3436347dd39f4000', testc.rows[0].partner_organizations[0]);
system.assertequals('jsilapan', testc.rows[0].program_managers[0]);

system.assertequals('Sustainable Fisheries', testc.rows[0].solution);
system.assertequals('2012', testc.rows[0].start_year);
system.assertequals('https://rarect_prod.s3.amazonaws.com/uploads%2Fcampaigns%2FPhilippines%2FSagnay%2C+Camarines%20Sur-2012%2Fbfarsa.jpg', testc.rows[0].splash_image);


system.assertequals('jbalasta', testc.rows[0].fellows[0]);

Campaigns_CT.Posts testpost = testc.rows[0].posts[0];
system.assertequals('52dec9173436347dd3d30a00', testpost.sid.xoid);

system.assertequals('published', testpost.status);
system.assert(testpost.summary.contains('Organizational Development (OD) and Baseline Marine Protected Area Effectiveness Assessment Tool (MEAT)  Workshop'));
system.assert(testpost.title.contains('Atulayan Fish Sanctuary and Marine Reserve'));
system.assertequals('blog', testpost.type);
system.assertequals('en', testpost.language);
system.assert(testpost.authors.isEmpty());
system.debug(testpost.body);
system.assert(testpost.body.contains('Organizational Development (OD) and Baseline Marine Protected Area Effectiveness Assessment Tool (MEAT)  Workshop'));

/*
authors{get;set;}
files{get;set;}
*/



//system.assert(testpost.creation_date.xdate.startswith('2012-09-08') );
//system.assert(testpost.last_updated.xdate.startswith('2012-09-08') );
//system.assert(testpost.published_date.xdate.startswith('2012-09-08') );

S3files_CT sfiletest = testc.rows[0].posts[2].s3files[0];

system.assertequals('52dec9173436347dd3d60a00', sfiletest.sid.xoid);

//system.assert(sfiletest.photo_date.startswith('2012-09-09') );
//system.assert(sfiletest.submission_date.startswith('2014-01-21') );
system.debug(sfiletest.submission_date);


system.assertequals('images', sfiletest.file_type);
system.assertequals('Campaign for Sustainable Fishing - Sagnay, Camarines Sur, Luzon (PEP 4 Campaign - Philippines)', sfiletest.campaign_name);

system.assertequals('(none)', sfiletest.caption);
system.assertequals('(none)', sfiletest.credit);
system.assertequals('(none)', sfiletest.location);
system.assertequals(true, sfiletest.migrated);

system.assertequals('reef_team_pix.jpg', sfiletest.file_name);
system.assertequals('http://s3.amazonaws.com/rarect_prod/rareplanet.org/files/reef_team_pix.jpg', sfiletest.url);


Milestone_CT testmilestone = testc.rows[0].milestones[4];

    //system.assert(testmilestone.approval_date.xdate.startswith('2014-04-02'));
    //system.assert(testmilestone.created_at.xdate.startswith('2014-01-21'));
    //system.assert(testmilestone.due_date.xdate.startswith('2014-04-03'));
    //system.assert(testmilestone.submission_date.xdate.startswith('2014-04-11'));
    system.debug(testmilestone.submission_date);
    
    //system.assert(testmilestone.updated_at.xdate.startswith('2014-10-28'));
    system.assertequals('52df1f2b3436342d96170000', testmilestone.sid.xoid);
    
    system.assertequals(null, testmilestone.file);
    system.assertequals(false, testmilestone.imported);
    system.assertequals('Work Plan Month 9', testmilestone.name);
    system.assertequals('Implementation', testmilestone.phase);
    system.assertequals('95', testmilestone.score);
    system.assertequals('Approved', testmilestone.status);
    system.assertequals(null, testmilestone.type);
  
  system.assertequals(null,testmilestone.s3files[0].campaign_name);
  system.assertequals(null,testmilestone.s3files[0].caption);
  system.assertequals(null,testmilestone.s3files[0].credit);
  system.assertequals('Workplan 9.xlsx',testmilestone.s3files[0].file_name);
  system.assertequals('images',testmilestone.s3files[0].file_type);
  system.assertequals(null,testmilestone.s3files[0].location);
  system.assertequals(true,testmilestone.s3files[0].migrated);
  //system.assertequals(null,testmilestone.s3files[0].photo_date);
  system.assertequals('544fbad334363434f9870300', testmilestone.s3files[0].sid.xoid);
  system.assertequals('https://rarect_prod.s3.amazonaws.com/uploads/campaigns/Philippines/Sagnay-2012/milestones/Work Plan Month 9/Workplan 9.xlsx', testmilestone.s3files[0].url);
  
  Campaigns_CT.Weekly_flash_reports weeklyflash = testc.rows[0].weekly_flash_reports[0];

  system.assertequals(null,weeklyflash.campaign_status);
  system.assertequals(null,weeklyflash.next_steps);
  system.assertequals(null,weeklyflash.Comments);
  //system.assert(weeklyflash.due_date.xdate.startswith('2014-01-26'));
   
  system.assertequals('Not Submitted',weeklyflash.status);
  system.assert(weeklyflash.compliance_issues.isempty());
  system.assert(weeklyflash.ppm_explanation.isempty());
  system.assert(weeklyflash.unmet_compliance_issues.isempty());
  
  system.assertequals('5362ad4934363411b9640000', weeklyflash.sid.xoid);
    
//ppm_explanation=(), 
//unmet_compliance_issues=()]
}

@isTest
private static void CampaignParseCoverageFiles() {

Campaigns_CT testc = Campaigns_CT.parse(getJSON('CampaignKalima115JSON'));
Campaigns_CT.Files testfile = testc.rows[0].files[0];

system.assertequals(null, testfile.attribution);
system.assertequals(null, testfile.caption);
system.assertequals(null, testfile.name);
system.assertequals('http://s3.amazonaws.com/rarect_prod/rareplanet.org/files/Agroforestry_0.pdf', testfile.path);
system.assertequals('Agroforestry Manual - Bahasa Indonesia', testfile.title);
system.assertequals('doc', testfile.type);
system.assertequals(null, testfile.uploaded);
system.assertequals(null, testfile.url);

}


@isTest
private static void CampaignParseTestError() {

MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
multimock.setStaticResource('https://mongodb.rare.org/rarect_prod/campaigns/?filter_project_code=KALIMA&limit=-1', 'CTCampaignKALIMA');
multimock.setStatusCode(200);

Program__c testp = new Program__c();
testp.Name = 'Test Program';
testp.CT_Id__c = '5371ba103436345962060000';
insert testp;

RARE_Campaign__c testrc = new RARE_Campaign__c();
testrc.CT_Id__c = '52dec90e3436347dd3b00800';
testrc.Name = 'KALIMA Test';
testrc.Project_Code__c = 'KALIMA';
testrc.Primary_PPM__c = 'Test PPM';
insert testrc;

MongoCampaignParserController mcpc = new MongoCampaignParserController(new ApexPages.StandardController(testrc));

test.starttest();
    Test.setMock(HttpCalloutMock.class, multimock);
    mcpc.parseData();
    mcpc.ReturntotRC();
 test.stoptest();
 
 system.assertequals(TRUE, mcpc.mda.bSuccess);
 
}

   

public static String getJSON(String sResource) {
    StaticResource sr = [Select Id, Body from StaticResource WHERE Name = :sResource];
    String sJSON = sr.Body.toString();
    sJson = sJson.replace('_id', 'sid');
    sJson = sJson.replace('$', 'x');
    return sJson;
}


}