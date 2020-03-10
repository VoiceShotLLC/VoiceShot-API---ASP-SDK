<%
 On Error Resume Next
 if Trim(Request.Form("callerid")) = "" then
   Response.write("Data Validation Error: callerid attribute cannot be blank")
 else 
   set xmldom      = Server.CreateObject("MSXML2.DOMDocument")
   set xmlhttp     = Server.CreateObject("Msxml2.ServerXMLHTTP")
 
   Dim ErorrText,PhoneNumber,Menuid,Ext,CallID,TTS,CallerID,TransferTo,AltTTS,XML,promptinfo

   ErorrText = ""
   PromptInfo = ""

   if Request.Form("UseDefault") = "1" then
     Menuid = "0"
   else
     MenuID = Request.Form("MenuID")
   end if
 
   PhoneNumber = "number="""&Request.Form("PhoneNumber")&""""
   Ext         = Request.Form("Ext")
   if Ext <> "" then
     Ext      = "ext="""&Ext&""""
   end if
   CallID      = Request.Form("callid")
   if CallID <> "" then
    CallID      = "callid="""&CallID&""""
   end if
   TTS         = Trim(Request.Form("TTS"))
   if TTS <> "" then
     TTS = "tts="""&TTS&""""
   end if 
   CallerID    = Request.Form("callerid")
   if CallerID <> "" then
     CallerID    = "callerid="""&CallerID&""""
   end if
   TransferTo  = Request.Form("transferto")
   if TransferTo <> "" then
     TransferTo = "transferto="""&TransferTo&""""
   end if
   AltTTS      = Trim(Request.Form("AltTTS"))
   if AltTTS <> "" then
     AltTTS = "alttts="""&AltTTS&""""
   end if  

   XML = "<campaign action=""0"" menuid="""&MenuID&""" "&CallerID&" >"
   if (AltTTS <> "") or (TransferTo <> "")  then
      PromptInfo = "<prompt promptid=""1"" "&AltTTS&" "&TransferTo&" />"
   end if
   if  (TTS <> "") then
     PromptInfo = PromptInfo &  "<prompt promptid=""2"" "&TTS&" />"
   end if
   if PromptInfo <> "" then
     XML = XML &  "<prompts>"&PromptInfo&"</prompts>"
   end if 
   XML = XML & "<phonenumbers>"
   XML = XML & "<phonenumber "&PhoneNumber&" "&Ext&" "&CallID&" />"
   XML = XML & "</phonenumbers>"
   XML = XML & "</campaign>"
 
   if Request.Form("Submit") = "View" then
      response.contentType = "text/xml"
      response.write(XML)
   else
      err.clear
      xmldom.async = false
      xmldom.loadXML(XML)
      'Do not swap these two URLs. Always post to api.voiceshot.com first.
      xmlhttp.Open "POST", "https://api.voiceshot.com/ivrapi.asp", false 
      xmlhttp.Send(xmldom) 
      if err.number <> 0 then 
	  err.clear
      xmlhttp.Open "POST", "https://apiproxy.voiceshot.com/ivrapi.asp", false 
      xmlhttp.Send(xmldom) 	  
    end if
	response.contentType = "text/xml"
	response.write(xmlhttp.ResponseText)
	if err.number = 0 then
	  'Post is not successful, see value of Comment
	  Comment = xmlhttp.ResponseText     
	else
	  'Post is not successful, see value of Comment
      Comment = xmlhttp.ResponseText      
	end if
   end if

   set xmlhttp = nothing
   set xmldom = nothing
 end if
%>