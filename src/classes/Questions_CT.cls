public class Questions_CT extends Mongo_CT {

    public class Choices {
        public String choice{get;set;}
        public Integer points{get;set;}
        public Boolean notes{get;set;}
    }

    public class Rows {
        public sid sid{get;set;}
        public Integer order{get;set;}
        public Boolean comments{get;set;}
        public Boolean next_steps{get;set;}
        public Boolean collapse{get;set;}
        public Boolean scoreable{get;set;}
        public String name{get;set;}
        public String kind{get;set;}
        public String question{get;set;}
        public String section{get;set;}
        public List<Choices> choices{get;set;}
        public ctdate updated_at{get;set;}
        public ctdate created_at{get;set;}
        public String autofill{get;set;}
        public String help{get;set;}
    }

    public List<Rows> rows{get;set;}
    
    public static Questions_CT parse(String json) {
        return (Questions_CT) System.JSON.deserialize(json, Questions_CT.class);
    }
    
    }