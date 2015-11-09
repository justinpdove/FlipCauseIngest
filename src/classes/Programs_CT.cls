public class Programs_CT extends Mongo_CT{

  
    public List<Rows> rows {get;set;}

    public class Rows {
        public sid sid {get;set;}
        public ctdate created_at {get;set;}
        //public List<Milestone_CT> milestones {get;set;}
        public String name {get;set;}
        public String rare_region {get;set;}
        public String region {get;set;}
        public ctdate updated_at {get;set;}
    }

   /*
    public class File {
        public String name {get;set;}
        public String url {get;set;}
    }

    */
    
    public static Programs_CT parse(String json) {
        return (Programs_CT) System.JSON.deserialize(json, Programs_CT.class);
    }
    
    /*
    public static List<Programs_CT> parseaslist(String json) {
        return (List<Programs_CT>) System.JSON.deserialize(json, List<Programs_CT>.class);
    }
    */
    
    }