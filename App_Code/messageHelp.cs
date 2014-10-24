using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Json;
using System.Text;
using System.Web;
using System.Xml;

/// <summary>
/// messageHelp 的摘要说明
/// </summary>
public class messageHelp
{
    //返回消息
    public string ReturnMessage(string postStr)
    {
        string responseContent = "";
        XmlDocument xmldoc = new XmlDocument();
        xmldoc.Load(new System.IO.MemoryStream(System.Text.Encoding.GetEncoding("GB2312").GetBytes(postStr)));
        XmlNode MsgType = xmldoc.SelectSingleNode("/xml/MsgType");
        if (MsgType != null)
        {
            switch (MsgType.InnerText)
            {
                case "event":
                    responseContent = EventHandle(xmldoc);//事件处理
                    break;
                case "text":
                    responseContent = TextHandle(xmldoc);//接受文本消息处理
                    break;
                default:
                    break;
            }
        }
        return responseContent;
    }
    //事件
    public string EventHandle(XmlDocument xmldoc)
    {
        string responseContent = "";
        XmlNode Event = xmldoc.SelectSingleNode("/xml/Event");
        XmlNode EventKey = xmldoc.SelectSingleNode("/xml/EventKey");
        XmlNode ToUserName = xmldoc.SelectSingleNode("/xml/ToUserName");
        XmlNode FromUserName = xmldoc.SelectSingleNode("/xml/FromUserName");
        if (Event != null)
        {
            //菜单单击事件
            if (Event.InnerText.Equals("CLICK"))
            {
                if (EventKey.InnerText.Equals("click_one"))//click_one
                {
                    responseContent = string.Format(ReplyType.Message_Text,
                        FromUserName.InnerText,
                        ToUserName.InnerText,
                        DateTime.Now.Ticks,
                        "你点击的是click_one");
                }
                else if (EventKey.InnerText.Equals("click_two"))//click_two
                {
                    responseContent = string.Format(ReplyType.Message_News_Main,
                        FromUserName.InnerText,
                        ToUserName.InnerText,
                        DateTime.Now.Ticks,
                        "2",
                         string.Format(ReplyType.Message_News_Item, "我要寄件", "",
                         "http://www.soso.com/orderPlace.jpg",
                         "http://www.soso.com/") +
                         string.Format(ReplyType.Message_News_Item, "订单管理", "",
                         "http://www.soso.com/orderManage.jpg",
                         "http://www.soso.com/"));
                }
                else if (EventKey.InnerText.Equals("click_three"))//click_three
                {
                    responseContent = string.Format(ReplyType.Message_News_Main,
                        FromUserName.InnerText,
                        ToUserName.InnerText,
                        DateTime.Now.Ticks,
                        "1",
                         string.Format(ReplyType.Message_News_Item, "标题", "摘要",
                         "http://www.soso.com/jieshao.jpg",
                         "http://www.soso.com/"));
                }
            }
        }
        return responseContent;
    }
    //接受文本消息
    public string TextHandle(XmlDocument xmldoc)
    {
        string responseContent = "";
        XmlNode ToUserName = xmldoc.SelectSingleNode("/xml/ToUserName");
        XmlNode FromUserName = xmldoc.SelectSingleNode("/xml/FromUserName");
        XmlNode Content = xmldoc.SelectSingleNode("/xml/Content");
        if (Content != null)
        {
            responseContent = string.Format(ReplyType.Message_Text,
                FromUserName.InnerText,
                ToUserName.InnerText,
                DateTime.Now.Ticks,
                "欢迎使用微信公共账号，您输入的内容为：" + Content.InnerText + "\r\n<a href=\"http://www.baidu.com\">点击进入</a>");
        }
        return responseContent;
    }

    //写入日志
    public void WriteLog(string text)
    {
        StreamWriter sw = new StreamWriter(HttpContext.Current.Server.MapPath(".") + "\\log.txt", true);
        sw.WriteLine(text);
        sw.Close();//写入
    }

    public string GetAccess_token()
    {
        HttpHelper http = new HttpHelper();
        HttpItem item = new HttpItem()
        {
            URL = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wx169696fcd0376afc&secret=3b5cb870c47bb224614dcbe8fe4168ae",//URL这里都是测试     必需项
            Method = "get",//URL     可选项 默认为Get
        };
        //得到HTML代码
        HttpResult result = http.GetHtml(item);
        //item = new HttpItem()
        //{
        //    URL = "http://tool.sufeinet.com",//URL这里都是测试URl   必需项
        //    Encoding = null,//编码格式（utf-8,gb2312,gbk）     可选项 默认类会自动识别
        //    //Encoding = Encoding.Default,
        //    Method = "post",//URL     可选项 默认为Get
        //    Postdata = "user=123123&pwd=1231313"
        //};
        //得到新的HTML代码
        //result = http.GetHtml(item);
        return GetObjFromJson<TokenHelper>(result.Html).access_token;
    }

    /// <summary>  
    /// 将Json字符串转化为对象  
    /// </summary>  
    /// <typeparam name="T">目标类型</typeparam>  
    /// <param name="strJson">Json字符串</param>  
    /// <returns>目标类型的一个实例</returns>  
    public static T GetObjFromJson<T>(string strJson)
    {
        T obj = Activator.CreateInstance<T>();
        using (MemoryStream ms = new MemoryStream(Encoding.UTF8.GetBytes(strJson)))
        {
            DataContractJsonSerializer jsonSerializer = new DataContractJsonSerializer(obj.GetType());
            return (T)jsonSerializer.ReadObject(ms);
        }
    }  
}

//回复类型
public class ReplyType
{
    /// <summary>
    /// 普通文本消息
    /// </summary>
    public static string Message_Text
    {
        get
        {
            return @"<xml>
                            <ToUserName><![CDATA[{0}]]></ToUserName>
                            <FromUserName><![CDATA[{1}]]></FromUserName>
                            <CreateTime>{2}</CreateTime>
                            <MsgType><![CDATA[text]]></MsgType>
                            <Content><![CDATA[{3}]]></Content>
                            </xml>";
        }
    }
    /// <summary>
    /// 图文消息主体
    /// </summary>
    public static string Message_News_Main
    {
        get
        {
            return @"<xml>
                            <ToUserName><![CDATA[{0}]]></ToUserName>
                            <FromUserName><![CDATA[{1}]]></FromUserName>
                            <CreateTime>{2}</CreateTime>
                            <MsgType><![CDATA[news]]></MsgType>
                            <ArticleCount>{3}</ArticleCount>
                            <Articles>
                            {4}
                            </Articles>
                            </xml> ";
        }
    }
    /// <summary>
    /// 图文消息项
    /// </summary>
    public static string Message_News_Item
    {
        get
        {
            return @"<item>
                            <Title><![CDATA[{0}]]></Title> 
                            <Description><![CDATA[{1}]]></Description>
                            <PicUrl><![CDATA[{2}]]></PicUrl>
                            <Url><![CDATA[{3}]]></Url>
                            </item>";
        }
    }
}