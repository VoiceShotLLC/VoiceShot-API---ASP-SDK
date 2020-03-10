<%
    set fs = Server.CreateObject ("Scripting.FileSystemObject")
    OutPutPath = Server.Mappath(".\")&"\"

    'Read XML from the Request object
    BinData = request.BinaryRead(request.TotalBytes) 

    'Create XML DOM Object
    Set objXMLDoc   = Server.CreateObject("MSXML2.DOMDocument")
    objXMLDoc.async = False
    objXMLDoc.validateOnParse = False

    if objXMLDoc.load(BinData) then

      'Write raw XML to a file
      strFileName = "xmlsummaryinsms.txt"
      Set PostedInfo = fs.OpenTextFile(OutPutPath & strFileName, 8, true)
      PostedInfo.WriteLine("--- " &Now& " ------------------------------------------------------")
      PostedInfo.WriteLine(objXMLDoc.DocumentElement.xml )
      PostedInfo.WriteLine("")
      PostedInfo.Close
      set PostedInfo = nothing

      'Example of parseing XML 
      Set PostedInfo = fs.OpenTextFile(OutPutPath & "summaryinsms.txt", 8, true)
      PostedInfo.WriteLine("--- " &Now& " ------------------------------------------------------")

      on error resume next
      strMenuId      = objXMLDoc.selectSingleNode("/campaign/@menuid").nodeTypedValue
      strCallid      = objXMLDoc.selectSingleNode("/campaign/@callid").nodeTypedValue
      strNumber      = objXMLDoc.selectSingleNode("/campaign/@callerid").nodeTypedValue
      strText        = objXMLDoc.selectSingleNode("/campaign/prompts/prompt/@txt").nodeTypedValue

      PostedInfo.WriteLine("MenuId: " & strMenuId)
	  If(strCallID <> "") Then PostedInfo.WriteLine("Call ID: " & strCallID)
      PostedInfo.WriteLine("Phone Number: " & strNumber)
      PostedInfo.WriteLine("Text: " & strText )

      on error goto 0

      PostedInfo.WriteLine("")
      PostedInfo.Close
      set PostedInfo = nothing

    end if

    set objXMLDoc = nothing
    set fs        = nothing

%>