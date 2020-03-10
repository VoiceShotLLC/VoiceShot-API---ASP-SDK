<%
    ' Simply saving the RAW XML to a file
    on error resume next
    set fs = Server.CreateObject ("Scripting.FileSystemObject")
    OutPutPath = Server.Mappath(".\")&"\"

    'Read the XML from the Request object
    BinData = request.BinaryRead(request.TotalBytes) 

    'Load XML for processing
    Set objXMLDoc = Server.CreateObject("MSXML2.DOMDocument")
    objXMLDoc.async = False
    objXMLDoc.validateOnParse = False

    If objXMLDoc.load(BinData) Then
      strFileName = "xmlsummaryoutcall.txt"
      Set PostedInfo = fs.OpenTextFile(OutPutPath & strFileName, 8, true)
      PostedInfo.WriteLine("--- " &Now& " ------------------------------------------------------")
      PostedInfo.WriteLine(objXMLDoc.DocumentElement.xml )
      PostedInfo.WriteLine("")
      PostedInfo.Close
      set PostedInfo = nothing
      Set PostedInfo = fs.OpenTextFile(OutPutPath & "summaryoutcall.txt", 8, true)
      PostedInfo.WriteLine("--- " &Now& " ------------------------------------------------------")
      strMenuId      = objXMLDoc.selectSingleNode("/campaign/@menuid").nodeTypedValue
      strDuration    = objXMLDoc.selectSingleNode("/campaign/@duration").nodeTypedValue
      StrNumber      = objXMLDoc.selectSingleNode("/campaign/@phonenumber").nodeTypedValue
      StrStatus      = objXMLDoc.selectSingleNode("/campaign/@status").nodeTypedValue
      StrLastError   = objXMLDoc.selectSingleNode("/campaign/@comment").nodeTypedValue
      StrCallID      = objXMLDoc.selectSingleNode("/campaign/@callid").nodeTypedValue

      PostedInfo.WriteLine("MenuId: " & strMenuId)
      PostedInfo.WriteLine("Duration: " & strDuration)
      PostedInfo.WriteLine("Phone Number: " & strNumber)
      PostedInfo.WriteLine("Status: " & strStatus)
      PostedInfo.WriteLine("Comment: " & strLastError)
	  If(strCallID <> "") Then PostedInfo.WriteLine("Call ID: " & strCallID)
  
      set currNode = objXMLDoc.documentElement.firstChild
      if (currNode.hasChildNodes()) then 
         Set PromptList = currNode.childNodes
         For Each Item In PromptList
           PostedInfo.WriteLine("Node Name: " & Item.NodeName)
           ID = Item.getAttribute("promptid")
           KeyPress = Item.getAttribute("keypress")
           PostedInfo.WriteLine("Prompt: " & ID & " KeyPress: " & KeyPress)
           Set FileList = Item.childNodes
           For Each VMFile in FileList
             ID   = VMFile.getAttribute("fileid")
             Name = VMFile.getAttribute("filename") 
             VoiceFile = VMFile.nodeTypedValue
             Set objStream = Server.CreateObject("ADODB.Stream")
             objStream.Type = 1
             objStream.Open
             objStream.Write VoiceFile
             objStream.SaveToFile OutPutPath & Name
             objStream.Close()
             Set objStream = Nothing  
             PostedInfo.WriteLine("FILE ID : " & ID & " Name: " & Name)
           next
           set FileList = Nothing
         Next            
         Set PromptList = Nothing
      end if
      PostedInfo.WriteLine("")
      PostedInfo.Close
      set PostedInfo = nothing
    end if  
    set fs = nothing
    set objXMLDoc = Nothing   
%>