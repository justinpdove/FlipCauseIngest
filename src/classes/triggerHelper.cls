public with sharing class triggerHelper {

public static boolean b=false;

//A boolean that is set and then checked at the beginning of update triggers to be sure they only execute once
public static  void  recursiveHelper (Boolean tBool){
    b=tBool;
}

}