public class ScorecardAnswers_CT extends Mongo_CT {

    public List<Rows> rows {get;set;}

    public class Rows {
        public sid sid {get;set;}
        public List<String> choices {get;set;}
        public Integer score {get;set;}
        public sid questionsid {get;set;}
        public sid scorecardsid {get;set;}
        public Boolean reviewed {get;set;}
        public ctdate updated_at {get;set;}
        public ctdate created_at {get;set;}
        public String section {get;set;}
    }

    public static ScorecardAnswers_CT parse(String json) {
        return (ScorecardAnswers_CT) System.JSON.deserialize(json, ScorecardAnswers_CT.class);
    }
    }