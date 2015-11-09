public class S3files_CT extends Mongo_CT {
        
        public sid sid{get;set;}
        public ctdate submission_date{get;set;} //Note - this is not consistent in Mong - sometimes String, sometimes a ctdate
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