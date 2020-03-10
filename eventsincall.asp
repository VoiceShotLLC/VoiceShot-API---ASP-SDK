<%
    set fs = Server.CreateObject ("Scripting.FileSystemObject")
    OutPutPath = Server.Mappath(".\")&"\"

    'Read the XML from the Request object
    BinData = request.BinaryRead(request.TotalBytes) 

    'Create XML DOM Object
    Set objXMLDoc = Server.CreateObject("MSXML2.DOMDocument")
    objXMLDoc.async = False
    objXMLDoc.validateOnParse = False

    if objXMLDoc.load(BinData) then

      'Write raw XML to a file
      strFileName = "xmleventsincall.txt"
      Set PostedInfo = fs.OpenTextFile(OutPutPath & strFileName, 8, true)
      PostedInfo.WriteLine("--- " &Now& " ------------------------------------------------------")
      PostedInfo.WriteLine(objXMLDoc.DocumentElement.xml )
      PostedInfo.WriteLine("")
      PostedInfo.Close
      set PostedInfo = nothing
      Set PostedInfo = fs.OpenTextFile(OutPutPath & "eventsincall.txt", 8, true)

      'Example of parseing XML 
      on error resume next 
      strAction  = objXMLDoc.selectSingleNode("/campaign/@action").nodeTypedValue
      PostedInfo.WriteLine("--- " &Now& " ------------------------------------------------------")
      if (strAction = "4") or (strAction = "5") then
        strMenuId  = objXMLDoc.selectSingleNode("/campaign/@menuid").nodeTypedValue
        strAction  = objXMLDoc.selectSingleNode("/campaign/@action").nodeTypedValue
        select case strAction
          case "4" strAction = "Answer"
          case "5" strAction = "Hang up"
        end select
        strCallerId = objXMLDoc.selectSingleNode("/campaign/@callerid").nodeTypedValue
        strCallId    = objXMLDoc.selectSingleNode("/campaign/@callid").nodeTypedValue
        strDuration = objXMLDoc.selectSingleNode("/campaign/@duration").nodeTypedValue
        On Error Goto 0
        PostedInfo.WriteLine("Call Start/Stop Event")
		If(strCallID <> "") Then PostedInfo.WriteLine("Call ID: " & strCallID)
        PostedInfo.WriteLine("MenuId: " & strMenuId)
        PostedInfo.WriteLine("Action: " & strAction)
        PostedInfo.WriteLine("CallerId: " & strCallerId)
        PostedInfo.WriteLine("Duration: " & strDuration)
      else
        strCallId    = objXMLDoc.selectSingleNode("/prompt/@callid").nodeTypedValue
        strMenuId    = objXMLDoc.selectSingleNode("/prompt/@menuid").nodeTypedValue
        strPromptid  = objXMLDoc.selectSingleNode("/prompt/@promptid").nodeTypedValue
        strKeyPress  = objXMLDoc.selectSingleNode("/prompt/@keypress").nodeTypedValue
        On Error Goto 0
        PostedInfo.WriteLine("Prompt Event")
        If(strCallID <> "") Then PostedInfo.WriteLine("Call ID: " & strCallID)
        PostedInfo.WriteLine("MenuId: " & strMenuId)
        If(strPromptid <> "") Then PostedInfo.WriteLine("PromptId: " & strPromptid)
        If(strKeyPress <> "") Then PostedInfo.WriteLine("KeyPress: " & strKeyPress)
      end if
      PostedInfo.WriteLine("")
      PostedInfo.Close
      set PostedInfo = nothing
    end if

   'Example of Call Commands
    xmlResponse = ""
    select case strKeyPress
       case "1234"       xmlResponse = "<prompt goto=""2"" />"
    end select
    Response.ContentType = "text/xml"
    Response.write(xmlResponse)

    set objXMLDoc = nothing
    set fs        = nothing
%>