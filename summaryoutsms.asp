<%
    ' Simply saving the RAW XML to a file
    'on error resume next
    set fs = Server.CreateObject ("Scripting.FileSystemObject")
    OutPutPath = Server.Mappath(".\")&"\"

    'Read the XML from the Request object
    BinData = request.BinaryRead(request.TotalBytes) 

    'Load XML for processing
    Set objXMLDoc = Server.CreateObject("MSXML2.DOMDocument")
    objXMLDoc.async = False
    objXMLDoc.validateOnParse = False

    If objXMLDoc.load(BinData) Then
      strFileName = "xmlsummaryoutsms.txt"
      Set PostedInfo = fs.OpenTextFile(OutPutPath & strFileName, 8, true)
      PostedInfo.WriteLine("--- " &Now& " ------------------------------------------------------")
      PostedInfo.WriteLine(objXMLDoc.DocumentElement.xml )
      PostedInfo.WriteLine("")
      PostedInfo.Close
      set PostedInfo = nothing
      Set PostedInfo = fs.OpenTextFile(OutPutPath & "summaryoutsms.txt", 8, true)
      PostedInfo.WriteLine("--- " &Now& " ------------------------------------------------------")
      strMenuId      = objXMLDoc.selectSingleNode("/campaign/@menuid").nodeTypedValue
      StrNumber      = objXMLDoc.selectSingleNode("/campaign/@phonenumber").nodeTypedValue
      StrStatus      = objXMLDoc.selectSingleNode("/campaign/@status").nodeTypedValue
      StrLastError   = objXMLDoc.selectSingleNode("/campaign/@comment").nodeTypedValue
      StrCallID      = objXMLDoc.selectSingleNode("/campaign/@callid").nodeTypedValue

      PostedInfo.WriteLine("MenuId: "       & strMenuId)
      PostedInfo.WriteLine("Phone Number: " & strNumber)
      PostedInfo.WriteLine("Status: "       & strStatus)
      PostedInfo.WriteLine("Comment: "      & strLastError)
	  If(strCallID <> "") Then PostedInfo.WriteLine("Call ID: " & strCallID)

      PostedInfo.WriteLine("")
      PostedInfo.Close
      set PostedInfo = nothing
    end if  
    set fs = nothing
    set objXMLDoc = Nothing   
%>