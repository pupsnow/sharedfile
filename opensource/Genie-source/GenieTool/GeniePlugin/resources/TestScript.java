package scripts;

import com.adobe.genie.genieCom.SWFApp;
import com.adobe.genie.executor.GenieScript;
import com.adobe.genie.executor.components.*;
import com.adobe.genie.executor.uiEvents.*;
import static com.adobe.genie.executor.GenieAssertion.*;
import com.adobe.genie.executor.enums.GenieLogEnums;


/**
 * This is a sample Genie script.
 */
//Change name of the class 
public class Unnamed extends GenieScript {

	public Unnamed() throws Exception {
		super();
		
	}

	@Override
	public void start() throws Exception {
		//Turn this on if you want script to exit 
		//when a step fails
		EXIT_ON_FAILURE = false;

		//Turn this on if you want a screenshot 
		//to be captured on a step failure
		CAPTURE_SCREENSHOT_ON_FAILURE = false;
	}
}
