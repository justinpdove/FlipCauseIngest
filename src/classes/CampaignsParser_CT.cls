public class CampaignsParser_CT {

//public Programs ctPrograms {get;set;}
public Boolean bSuccess {get;set;}
public Rare_Campaign__c rc {get;set;}
public List<Milestone__c> milestones {get;set;}
public List<Flash_Card__c> flashcards {get;set;}
public Map<String, CT_File__c> ctfiles {get;set;}
public List<CT_Post__c> ctposts {get;set;}
public String sEndPoint {get;set;}

public void parseData(String sJson) {
try {
Campaigns_CT msc = Campaigns_CT.parse(sJson);


milestones = new List<Milestone__c> ();
flashcards = new List<Flash_Card__c> ();
ctfiles = new Map<String, CT_File__c> ();
ctposts = new List<CT_Post__c>();

for (Campaigns_CT.Rows ro: msc.rows) {
rc = new Rare_Campaign__c();
rc.CT_Id__c  = ro.sid.xoid;

if (ro.name != NULL) {
    rc.name = ro.name.left(80);
    rc.Full_Name__c = ro.name.left(255);
}

rc.Mission__c = ro.mission;
rc.Solution__c = ro.solution;    
rc.Status__c = ro.campaign_status;
rc.Project_Code__c = ro.project_code;
    if (ro.programsid != NULL) {
    Program__c pr = new Program__c ();
        pr.CT_Id__c = ro.programsid.xoid;
        rc.Program__r = pr;
    }
rc.Primary_PPM__c = 'Holding';    
rc.Start_Year__c = ro.start_year;
rc.Image_URL__c = ro.splash_image;
rc.Rare_Region__c = ro.rare_region;

if (ro.program_managers != NULL) {
    rc.Program_Managers__c = String.join(ro.program_managers, ';');
}
if (ro.fellows != NULL) {
    rc.fellows__c = String.join(ro.fellows, ';');
}

if (ro.updated_at != NULL) {
                rc.CT_Updated_Date__c = convertctdate(ro.updated_at.xdate);
            }


if (ro.Location != NULL) {
    rc.Project_Location__latitude__s = Decimal.valueof(ro.Location.latitude);
    rc.Project_Location__longitude__s = Decimal.valueof(ro.Location.longitude);
    rc.Country2__c = ro.Location.Country;
}

Rare_Campaign__c rclookup = new Rare_Campaign__c();
rclookup.CT_Id__c  = rc.CT_Id__c ;


//Posts
if (ro.posts != NULL) {
    for (Campaigns_CT.Posts ctpost: ro.posts) {
    CT_Post__c cttemppost = new CT_Post__c();
        cttemppost.RARE_Campaign__r = rclookup;
        
        //system.debug(ctpost.s3files);
        
        cttemppost.CT_Id__c = ctpost.sid.xoid;
        cttemppost.Status__c = ctpost.status;
        cttemppost.Title__c = ctpost.title;
        cttemppost.Formatted_Body__c = ctpost.body;
        
        if (ctpost.published_date != NULL) {
                cttemppost.Date__c = convertctdate(ctpost.published_date.xdate);
        }
        
        if (ctpost.s3files != NULL) {
            CT_Post__c ctpostlookup = new CT_Post__c();
            ctpostlookup.CT_ID__c = cttemppost.CT_Id__c;
        
        for (S3files_CT cts3file: ctpost.s3files) {
            CT_File__c ctfiletemp = new CT_File__c();
            ctfiletemp.CT_Post__r = ctpostlookup;
            
            if (cts3file.url != NULL) {
                ctfiletemp.Path__c = cts3file.url.left(255);
            }
            
            ctfiletemp.CT_Id__c = cts3file.sid.xoid; 
            ctfiletemp.S3_File__c = TRUE;
            ctfiletemp.Title__c = cts3file.file_name;
            ctfiletemp.Type__c = cts3file.file_type;
            
            if (cts3file.submission_date != NULL) {
                ctfiletemp.Submission_Date__c = convertctdate(cts3file.submission_date.xdate);
            }
            
        ctfiles.put(ctfiletemp.CT_Id__c, ctfiletemp);
        }      
    }    
    ctposts.add(cttemppost);    
    }
}

//Files
if (ro.files != NULL) {
    for (Campaigns_CT.Files ctfile: ro.files) {
    CT_File__c ctfiletemp = new CT_File__c();
        ctfiletemp.RARE_Campaign__r = rclookup;
        ctfiletemp.Attribution__c = ctfile.attribution;
        
        if (ctfile.path != NULL) {
           ctfiletemp.Path__c = ctfile.path.left(255);
           ctfiletemp.CT_Id__c = ctfile.path.left(255); //no id on Files?
        }
        
        ctfiletemp.Title__c = ctfile.title;
        ctfiletemp.Type__c = ctfile.type;
        
    ctfiles.put(ctfiletemp.CT_Id__c, ctfiletemp);
        }
    }

if (ro.s3files != NULL) {
    for (S3files_CT cts3file: ro.s3files) {
    CT_File__c ctfiletemp = new CT_File__c();
        ctfiletemp.RARE_Campaign__r = rclookup;
        
        if (cts3file.url != NULL) {
                ctfiletemp.Path__c = cts3file.url.left(255);
        }
        
        ctfiletemp.CT_Id__c = cts3file.sid.xoid; 
        ctfiletemp.S3_File__c = TRUE;
        ctfiletemp.Title__c = cts3file.file_name;
        ctfiletemp.Type__c = cts3file.file_type;
        
        if (cts3file.submission_date != NULL) {
                ctfiletemp.Submission_Date__c = convertctdate(cts3file.submission_date.xdate);
        }
        
    ctfiles.put(ctfiletemp.CT_Id__c, ctfiletemp);
        }
    }

//Milestones
    if (ro.milestones != NULL) {
        for (Milestone_CT ms: ro.milestones) {
        Milestone__c mtemp = new Milestone__c();
            mtemp.Rare_Campaign__r = rclookup;
            mtemp.name__c = ms.name;
            mtemp.CT_Id__c = ms.sid.xoid;
            mtemp.status__c = ms.status;
            if (ms.score != NULL) {
                mtemp.Grade__c = integer.valueof(ms.score);
            }
            mtemp.Phase__c = ms.Phase;
            
            if (ms.due_date != NULL) {
                mtemp.Due_Date__c = convertctdate(ms.due_date.xdate);
            }
            
            if (ms.approval_date != NULL) {
                mtemp.Approved_Date__c = convertctdate(ms.approval_date.xdate);
            }
            
            if (ms.updated_at != NULL) {
                mtemp.CT_Updated_Date__c = convertctdate(ms.updated_at.xdate);
            }
            
            
            if (ms.submission_date != NULL) {
                mtemp.Submitted_Date__c = convertctdate(ms.submission_date.xdate);
            }
            
            
            if (ms.s3files != NULL) {
                for (Milestone_CT.S3files cts3file: ms.s3files) {
                        CT_File__c ctfiletemp = new CT_File__c();
                        ctfiletemp.RARE_Campaign__r = rclookup;
                        
                        Milestone__c ms3temp = new Milestone__c();
                        ms3temp.CT_Id__c = mtemp.CT_Id__c ;
                        
                        ctfiletemp.milestone__r = ms3temp;
                        
                        if (cts3file.url != NULL) {
                            ctfiletemp.Path__c = cts3file.url.left(255);
                        }
                        
                        //ctfiletemp.Path__c = cts3file.url;
                        ctfiletemp.CT_Id__c = cts3file.sid.xoid; 
                        ctfiletemp.S3_File__c = TRUE;
                        ctfiletemp.Title__c = cts3file.file_name;
                        ctfiletemp.Type__c = cts3file.file_type;
                        
                        if (cts3file.submission_date != NULL) {
                                ctfiletemp.Submission_Date__c = convertctdate(cts3file.submission_date.xdate);
                        }
                    ctfiles.put(ctfiletemp.CT_Id__c, ctfiletemp);
                        }
                    }
            
    milestones.add(mtemp);
        }
}
    if (ro.weekly_flash_reports != NULL) {
for (Campaigns_CT.Weekly_flash_reports ms: ro.weekly_flash_reports) {
    Flash_Card__c mtemp = new Flash_Card__c();
       
        mtemp.Rare_Campaign__r = rclookup;
        
        mtemp.CT_id__c = ms.sid.xoid;
        mtemp.status__c = ms.status;
        mtemp.Campaign_Status__c = ms.campaign_status;
        mtemp.Comments__c = ms.Comments;
        if (ms.due_date != NULL) {
            mtemp.date__c = convertctdate(ms.due_date.xdate);
        }
        
        if (ms.next_steps != NULL) {
            mtemp.Next_Steps__c = ms.next_steps;
        }
        
        if (ms.ppm_explanation != NULL) {
            mtemp.PPM_Explanation__c = String.Join(ms.ppm_explanation, ';');
        }
        
        if (ms.unmet_compliance_issues != NULL) {
            mtemp.Unmet_Compliance_Issues__c = String.join(ms.unmet_compliance_issues, ';');
        }
        
        if (ms.compliance_issues != NULL) {
            mtemp.Compliance_Issue__c = String.join(ms.compliance_issues, ';');
        }
        
        
flashcards.add(mtemp);
}
}

}
}

    catch (Exception Ex) {
    system.debug(ex);
    Error_Log__c cterror = new Error_Log__c();
    cterror.Error_Message__c = ex.getmessage();
    cterror.Request_URL__c = sEndPoint;
    insert cterror;
    bSuccess = FALSE;
}

}
public void UpdateCampaigns() {    
    try {
    upsert rc CT_Id__c;
    
    if (milestones != NULL) {
        upsert milestones CT_Id__c;
    }
    
    if (flashcards != NULL) {
        upsert flashcards CT_Id__c;
    }
    
    if (ctposts != NULL) {
        upsert ctposts CT_Id__c;
    }
  
    if (ctfiles.values() != NULL) {
        upsert ctfiles.values() CT_Id__c;
    }
    
    
    bSuccess = TRUE;
    }
catch (Exception Ex) {
    system.debug(ex);
    Error_Log__c cterror = new Error_Log__c();
    cterror.Error_Message__c = ex.getmessage();
    cterror.Request_URL__c = sEndPoint;
    insert cterror;
    bSuccess = FALSE;
}

}

/*
private date convertctdate(String ctDateString) {
 String [] sdate = ctDateString.split('-');
 Date myDate = Date.newInstance(integer.valueof(sdate[0]), integer.valueof(sdate[1]), integer.valueof(sdate[2].left(2)));
 return myDate;    
}
*/
private date convertctdate(Long ctDate) {
 //String [] sdate = ctDateString.split('-');
 DateTime myDatetime = DateTime.newInstance(ctDate);
 return myDatetime.date();    
}
}