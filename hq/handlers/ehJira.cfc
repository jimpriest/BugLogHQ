<cfcomponent extends="eventHandler">
	
	<cffunction name="dspSendToJira" access="public" returntype="void">
		<cfscript>
			var oJIRA = getService("jira");
			var entryID = getValue("entryID");
			
			try {
				if(val(entryID) eq 0) throw("Please select an entry to view");		
				
				oEntry = getService("app").getEntry(entryID);
				qryProjects = oJIRA.getProjects();
				qryIssueTypes = oJIRA.getIssueTypes();
				
				// set values
				setValue("oEntry", oEntry);
				setValue("qryProjects", qryProjects);
				setValue("qryIssueTypes", qryIssueTypes);
				setView("vwSendToJira");

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
				setNextEvent("ehGeneral.dspEntry","entryID=#entryID#");
			}
		</cfscript>				
	</cffunction>

	<cffunction name="doSendToJira" access="public" returntype="void">
		<cfscript>
			var oJIRA = getService("jira");
			var entryID = getValue("entryID",0);
			var project = getValue("project");
			var issueType = getValue("issueType");
			var summary = getValue("summary");
			var description = getValue("description");
			
			try {
				if(val(entryID) eq 0) throw("Please select an entry to send");		
				if(summary eq "") throw("Please enter a summary for this issue");
				
				oJira.createIssue(project,issueType,summary,description);
				
				setMessage("info","Bug report sent to JIRA!");
			
			} catch(custom e) {
				setMessage("warning",e.message);

			} catch(any e) {
				setMessage("error",e.message);
				getService("bugTracker").notifyService(e.message, e);
			}

			setNextEvent("ehGeneral.dspEntry","entryID=#entryID#");
			
		</cfscript>
	</cffunction>
	
</cfcomponent>