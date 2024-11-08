<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication4.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript">
        var ImageLoader = (function () {
            var totalImages = 0;
            var loadedImages = 0;
            var failedImages = 0;

            function imageError(imageUrl) {
                failedImages++;
                document.getElementById('<%= Label1.ClientID %>').innerText += imageUrl + ' 圖片不存在\n';
                checkAllImagesLoaded();
            }

            function imageLoad(imageUrl) {
                loadedImages++;
                document.getElementById('<%= Label1.ClientID %>').innerText += imageUrl + ' 圖片存在\n';
                checkAllImagesLoaded();
            }

            function ResetVal() {
                totalImages = 0;
                loadedImages = 0;
                failedImages = 0;
                document.getElementById('<%= Label1.ClientID %>').innerText = '';
                document.getElementById('<%= Label2.ClientID %>').innerText = '';
            }

            function checkAllImagesLoaded() {
                if (loadedImages + failedImages === totalImages) {
                    OpenBtn();
                    if (failedImages > 0) {
                        alert("有圖片未加載成功");
                        ResetVal();
                    } else {
                        document.getElementById('<%= Label2.ClientID %>').innerText = '所有圖片已加載完成';
                        document.getElementById('<%= HiddenButton.ClientID %>').click();
                    }
                }
            }

            function startImageLoading(imageUrls) {
                totalImages = imageUrls.length;
                for (var i = 0; i < imageUrls.length; i++) {
                    var imgUrl = imageUrls[i];
                    if (imgUrl.startsWith("data:image")) {
                        imageError(imgUrl);
                    } else {
                        var img = document.createElement('img');
                        img.src = imgUrl;
                        img.style.display = 'none';
                        img.onerror = (function (url) { return function () { imageError(url); }; })(imgUrl);
                        img.onload = (function (url) { return function () { imageLoad(url); }; })(imgUrl);
                        document.body.appendChild(img);
                    }
                }
            }

            function OpenBtn() {
                document.getElementById('<%= Button1.ClientID %>').disabled = true;
            }

            function CloseBtn() {
                document.getElementById('<%= Button1.ClientID %>').disabled = false;
            }

            function loadImages() {
                CloseBtn();
                $.ajax({
                    type: "POST",
                    url: "WebForm1.aspx/GetImageUrls",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d.length <= 0) {
                            alert("沒有圖片網址");
                            OpenBtn();
                            return;
                        } else {
                            startImageLoading(response.d);
                        }
                    },
                    error: function (response) {
                        OpenBtn();
                        console.log("獲取圖片網址失敗");
                    }
                });
            }

            return {
                loadImages: loadImages,
                ResetVal: ResetVal
            };
        })();
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="Label1" Text="text" runat="server" Visible="false"/>
            <asp:Label ID="Label2" Text="text" runat="server" />
            <asp:Button ID="Button1" runat="server" Text="開始加載圖片" OnClientClick="ImageLoader.loadImages(); return false;" />
            <asp:Button ID="HiddenButton" runat="server" Text="隱藏按鈕" OnClick="HiddenButton_Click" style="display:none;" />
        </div>
    </form>
</body>
</html>
