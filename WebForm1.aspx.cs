using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Web.UI;

namespace WebApplication4
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 初始加載時不做任何操作
            }
        }

        public void Test()
        {
            Response.Write("123");
        }

        [WebMethod]
        public static List<string> GetImageUrls()
        {
            var aa = new List<string>();
            aa.Add("https://prodcar1blob.blob.core.windows.net/asset/product/202406170546230917064.jpg");
            return aa;
        }

        protected void HiddenButton_Click(object sender, EventArgs e)
        {
            Test();
        }
    }
}