<%
 set xmldom      = Server.CreateObject("MSXML2.DOMDocument")
 set xmlhttp     = Server.CreateObject("Msxml2.ServerXMLHTTP")
 XML = "<campaign action=""6"" />"
 if Request.Form("Submit") = "View" then
    response.contentType = "text/xml"
    response.write(XML)
 else
    on error resume next
    xmldom.async = false
    xmldom.loadXML(XML)
    'Do not swap these two URLs. Always post to api.voiceshot.com first.
    xmlhttp.Open "POST", "http://api.voiceshot.com/ivrapi.asp", false 
    xmlhttp.Send(xmldom) 
    if err.number <> 0 then 
	  err.clear
      xmlhttp.Open "POST", "http://apiproxy.voiceshot.com/ivrapi.asp", false 
      xmlhttp.Send(xmldom) 	  
    end if	
    if err.number = 0 then
      'Post is successful     
    else
      'Post is not successful     
    end if	
    response.ContentType = "text/xml"
    response.write(xmlhttp.ResponseText)
 end if
 set xmlhttp = nothing 
 set xmldom  = nothing
%>