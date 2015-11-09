global class bfc_checktriggerfiring{ private static boolean blnAlreadyDone = false; public static boolean hasAlreadyDone()
/*pnc, June 2009
Because the Case Status is changed by Workflow, we need the triggers for updating the Tracking Objects to only fire after the workflow has been executed, which is the second time they are fired. So the first time we 
ignore the update but set this boolean, and only execute the code the second time, because this boolean is now set to true 
*/ 
{ return blnAlreadyDone; }

public static void setAlreadyDone() {
blnAlreadyDone = true;
}

}