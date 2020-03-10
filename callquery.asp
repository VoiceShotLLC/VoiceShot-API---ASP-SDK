<%
 set xmldom      = Server.CreateObject("MSXML2.DOMDocument")
 set xmlhttp     = Server.CreateObject("Msxml2.ServerXMLHTTP")

 if Request.Form("UseDefault") = "1" then
   Menuid = "0"
 else
   MenuID = Request.Form("MenuID")
 end if

 XML = "<campaign action=""3"" menuid="""&MenuID&""">"
 XML = XML & "<phonenumbers>"
 XML = XML & "<phonenumber callid="""&Request.Form("CallID")&""" />"
 XML = XML & "</phonenumbers>"
 XML = XML & "</campaign>"
 
 if Request.Form("Submit") = "View" then
   Response.ContentType = "text/xml"
   response.write(XML)
 else
   xmldom.async = false
   xmldom.loadXML(XML)
   on error resume next
   err.clear
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
     'Post is successful     
   else
     'Post is not successful     
   end if
 end if

 set xmldom  = nothing
 set xmlhttp = nothing
%>