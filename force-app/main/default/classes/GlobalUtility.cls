public class GlobalUtility {

    private static GlobalUtility instance = null; // private static variable referencing the class
    
    //Constructor initializes the map of the custom metadata
    private GlobalUtility() {}
    
    //Creating a Singleton pattern that creates a new instance of the class if it doesn't already exist.
    //If it already exists, then simply return a reference to that object
    public static GlobalUtility getInstance() {
        // lazy load the custom metadata - only initialize if it doesn't already exist
        if(instance == null) instance = new GlobalUtility();
        return instance;
    }

}