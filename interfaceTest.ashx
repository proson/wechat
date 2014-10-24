<%@ WebHandler Language="C#" Class="interfaceTest" %>

using System;
using System.Web;

public class interfaceTest : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        string postString = string.Empty;
        if (HttpContext.Current.Request.HttpMethod.ToUpper() == "POST")
        {
            using (System.IO.Stream stream = HttpContext.Current.Request.InputStream)
            {
                Byte[] postBytes = new Byte[stream.Length];
                stream.Read(postBytes, 0, (Int32)stream.Length);
                postString = System.Text.Encoding.UTF8.GetString(postBytes);
                Handle(postString);
            }
        }
    }

    /// <summary>
    /// 处理信息并应答
    /// </summary>
    private void Handle(string postStr)
    {
        messageHelp help = new messageHelp();
        string responseContent = help.ReturnMessage(postStr);

        HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.UTF8;
        HttpContext.Current.Response.Write(responseContent);
    }

    //成为开发者url测试，返回echoStr
    public void InterfaceTest()
    {
        string token = "liuwen";
        if (string.IsNullOrEmpty(token))
        {
            return;
        }

        string echoString = HttpContext.Current.Request.QueryString["echoStr"];
        string signature = HttpContext.Current.Request.QueryString["signature"];
        string timestamp = HttpContext.Current.Request.QueryString["timestamp"];
        string nonce = HttpContext.Current.Request.QueryString["nonce"];

        if (!string.IsNullOrEmpty(echoString))
        {
            HttpContext.Current.Response.Write(echoString);
            HttpContext.Current.Response.End();
        }
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}