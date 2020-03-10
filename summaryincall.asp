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
      strFileName = "xmlsummaryincall.txt"
      Set PostedInfo = fs.OpenTextFile(OutPutPath & strFileName, 8, true)
      PostedInfo.WriteLine("--- " &Now& " ------------------------------------------------------")
      PostedInfo.WriteLine(objXMLDoc.DocumentElement.xml )
      PostedInfo.WriteLine("")
      PostedInfo.Close
      set PostedInfo = nothing

      'Example of parseing XML 
      Set PostedInfo = fs.OpenTextFile(OutPutPath & "summaryincall.txt", 8, true)
      PostedInfo.WriteLine("--- " &Now& " ------------------------------------------------------")

      on error resume next
      strMenuId      = objXMLDoc.selectSingleNode("/campaign/@menuid").nodeTypedValue
      strDuration    = objXMLDoc.selectSingleNode("/campaign/@duration").nodeTypedValue
      StrNumber      = objXMLDoc.selectSingleNode("/campaign/@callerid").nodeTypedValue

      PostedInfo.WriteLine("MenuId: " & strMenuId)
      PostedInfo.WriteLine("Duration: " & strDuration)
      PostedInfo.WriteLine("Phone Number: " & strNumber)

      set currNode = objXMLDoc.documentElement.firstChild
      if (currNode.hasChildNodes()) then 
         Set PromptList = currNode.childNodes
         For Each Item In PromptList
           PostedInfo.WriteLine("Node Name: " & Item.NodeName)
           ID = Item.getAttribute("promptid")
           KeyPress = Item.getAttribute("keypress")
           PostedInfo.WriteLine("Prompt: " & ID)
		   If(KeyPress <> "") Then PostedInfo.WriteLine("KeyPress: " & KeyPress)
           Set FileList = Item.childNodes
           'Save any voice mail files
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
             PostedInfo.WriteLine("FILE ID: " & ID & " Name: " & Name)
           next
           set FileList = Nothing
         next            
         set PromptList = Nothing
      end if
      on error goto 0

      PostedInfo.WriteLine("")
      PostedInfo.Close
      set PostedInfo = nothing

    end if

    set objXMLDoc = nothing
    set fs        = nothing

%>