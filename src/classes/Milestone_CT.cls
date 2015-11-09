public class Milestone_CT extends Mongo_CT{

        public Sid sid{get;set;}
        public ctdate due_date{get;set;}
        public String phase{get;set;}
        public String status{get;set;}
        public File file{get;set;}
        public Boolean imported{get;set;}
        public String name{get;set;}
        public ctdate updated_at{get;set;}
        public ctdate created_at{get;set;}
        public List<S3files> s3files{get;set;} //local class due to Mongo Inconsistencies
        public ctdate approval_date{get;set;}
        public String score{get;set;}
        public ctdate submission_date{get;set;}
        public String type{get;set;}
           
        
    public class File {
        public String name{get;set;}
        public String url{get;set;}
    }
    
    public class S3files {
        
        public sid sid{get;set;}
        public ctdate submission_date{get;set;}
        public String file_type{get;set;}
        public String url{get;set;}
        public String file_name{get;set;}
        //public String photo_date{get;set;}
        public String credit{get;set;}
        public String caption{get;set;}
        public String location{get;set;}
        public Boolean migrated{get;set;}
        public String campaign_name{get;set;}
}
    
}