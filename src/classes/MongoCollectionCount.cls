public class MongoCollectionCount {


    public List<Rows> rows {get;set;}

    public class Rows {
        public Integer n {get;set;}
        public Integer ok {get;set;}
    }

     public static MongoCollectionCount parse(String json) {
        return (MongoCollectionCount) System.JSON.deserialize(json, MongoCollectionCount.class);
    }
    
    }