<%
 set xmldom      = Server.CreateObject("MSXML2.DOMDocument")
 set xmlhttp     = Server.CreateObject("Msxml2.ServerXMLHTTP")

 Dim ErorrText,PhoneNumber,Menuid,CallID,TXT,CallerID,XML,promptinfo

 ErorrText = ""
 PromptInfo = ""

 if Request.Form("UseDefault") = "1" then
   Menuid = "1"
 else
   MenuID = Request.Form("MenuID")
 end if
 
 PhoneNumber = "number="""&Request.Form("PhoneNumber")&""""

 CallID      = Request.Form("callid")
 if CallID <> "" then
  CallID      = "callid="""&CallID&""""
 end if
 TXT         = Trim(Request.Form("TXT"))
 if TXT <> "" then
   TXT = "txt="""&TXT&""""
 end if 
 CallerID    = Request.Form("callerid")
 if CallerID <> "" then
   CallerID    = "callerid="""&CallerID&""""
 end if

 XML = "<campaign action=""0"" menuid="""&MenuID&""" "&CallerID&" >"
 if  (TXT <> "") then
   PromptInfo = PromptInfo &  "<prompt "&TXT&" />"
 end if
 XML = XML & "<prompts>"&PromptInfo&"</prompts>"
 XML = XML & "<phonenumbers>"
 XML = XML & "<phonenumber "&PhoneNumber&" "&CallID&"  />"
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
%>