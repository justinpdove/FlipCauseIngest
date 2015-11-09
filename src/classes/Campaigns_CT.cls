public class Campaigns_CT extends Mongo_CT {
    
    public List<Rows> rows{get;set;}

    public class Rows {
        public sid sid{get;set;}
        public String campaign_status{get;set;}
        public ctdate created_at{get;set;}
        public List<String> fellows{get;set;}
        public List<Files> files{get;set;}
        public Boolean fish_forever{get;set;}
        public Location location{get;set;}
        public List<Milestone_CT> milestones{get;set;}
        public String mission{get;set;}
        public String name{get;set;}
        public String nid{get;set;}
        public List<String> partner_organizations{get;set;}
        public List<Posts> posts{get;set;}
        public sid programsid{get;set;}
        public List<String> program_managers{get;set;}
        public String project_code{get;set;}
        public String rare_region{get;set;}
        public String region{get;set;}
        public List<S3files_CT> s3files{get;set;}
        public String solution{get;set;}
        public String start_year{get;set;}
        public ctdate updated_at{get;set;}
        public List<sid> usersids{get;set;}
        public String splash_image{get;set;}
        public List<Weekly_flash_reports> weekly_flash_reports{get;set;}
    }

    public class Posts {
        public sid sid{get;set;}
        public List<String> authors{get;set;}
        public String body{get;set;}
        public ctdate creation_date{get;set;}
        public List<Files> files{get;set;}
        public String language{get;set;}
        public ctdate last_updated{get;set;}
        //public String nid{get;set;}
        public ctdate published_date{get;set;}
        public List<S3files_CT> s3files{get;set;}
        public String status{get;set;}
        public String summary{get;set;}
        public String title{get;set;}
        public String type{get;set;}
    }

    public class Location {
        public String country{get;set;}
        public String name{get;set;}
        public String latitude{get;set;}
        public String longitude{get;set;}
    }

    public class Files {
        public String attribution{get;set;}
        public String caption{get;set;}
        public String path{get;set;}
        public String title{get;set;}
        public String type{get;set;}
        public Boolean migrated{get;set;}
        public String uploaded{get;set;}
        public String name{get;set;}
        public String url{get;set;}
    }

   /*
    public class En {
        public String solution{get;set;}
    }
*/

    public class Weekly_flash_reports {
        public sid sid{get;set;}
        public List<String> ppm_explanation{get;set;}
        public List<String> compliance_issues{get;set;}
        public List<String> unmet_compliance_issues{get;set;}
        public String status{get;set;}
        public String campaign_status{get;set;}
        public String next_steps{get;set;}
        public ctdate due_date{get;set;}
        public String Comments{get;set;}
    }

    
    public static Campaigns_CT parse(String json) {
        return (Campaigns_CT) System.JSON.deserialize(json, Campaigns_CT.class);
    }
    
 }