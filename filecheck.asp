<%
  'Check for write permissions necessary for this demonstration
  on error resume next 
  set fs = Server.CreateObject ("Scripting.FileSystemObject")
  OutPutPath = Server.Mappath(".\")&"\"
  Set Filewriter = fs.OpenTextFile(OutPutPath & "xmleventsoutcall.txt", 8, true)
  if err.number <> 0 then
    hasError = True
    set Filewriter = nothing    
  else
    Filewriter.Close
    set Filewriter = nothing    
    Set Filewriter = fs.OpenTextFile(OutPutPath & "eventsoutcall.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
    Set Filewriter = fs.OpenTextFile(OutPutPath & "xmleventsincall.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
    Set Filewriter = fs.OpenTextFile(OutPutPath & "eventsincall.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
    Set Filewriter = fs.OpenTextFile(OutPutPath & "xmlsummaryincall.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
    Set Filewriter = fs.OpenTextFile(OutPutPath & "summaryincall.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
    Set Filewriter = fs.OpenTextFile(OutPutPath & "summaryoutcall.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
    Set Filewriter = fs.OpenTextFile(OutPutPath & "xmlsummaryoutcall.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
    Set Filewriter = fs.OpenTextFile(OutPutPath & "xmlsummaryinsms.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
    Set Filewriter = fs.OpenTextFile(OutPutPath & "summaryinsms.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
    Set Filewriter = fs.OpenTextFile(OutPutPath & "xmlsummaryoutsms.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
    Set Filewriter = fs.OpenTextFile(OutPutPath & "summaryoutsms.txt", 8, true)
    Filewriter.Close
    set Filewriter = nothing 
  end if
  set fs         = nothing
  if hasError then
    ErrorText = "Error: &nbsp;This example requires write permissions. &nbsp;Your Web server cannot write to this directory."
  end if
%>
