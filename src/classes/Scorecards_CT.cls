public class Scorecards_CT extends Mongo_CT{

    public class Rows {
        public  sid sid {get;set;}
        public  sid campaignsid {get;set;}
        public Integer capacity_score {get;set;}
        public Integer conservation_score {get;set;}
        public Integer constituency_score {get;set;}
        public ctdate created_at {get;set;}
        public String current_section {get;set;}
        public ctdate due_date {get;set;}
        public String grade {get;set;}
        public Integer rank {get;set;}
        public sid report_id {get;set;}
        public Boolean reviewed {get;set;}
        public sid saver_id {get;set;}
        public Integer score {get;set;}
        public String status {get;set;}
        public ctdate submission_date {get;set;}
        public ctdate updated_at {get;set;}
    }


    public List<Rows> rows {get;set;}
    
    public static Scorecards_CT parse(String json) {
        return (Scorecards_CT) System.JSON.deserialize(json, Scorecards_CT.class);
    }
    
    }