<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
       <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
       <c:set var="path" value="http://localhost:8080${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>Insert title here</title>
	<link type="text/css" rel="stylesheet" href="/Blog/html/css/indexTitle.css">
	<script type="text/javascript" src="/Blog/html/js/param.js"></script>
	<style type="text/css">
		
		body{
		background: #fff;
		}
	
		
	
	</style>
	 <script>
        /**
         * 全局的文章评论列表
         [{"articleComment":{"userid":34567,"content":"浅显易懂，很不错",
         "articleCommentid":-1,"commentTime":"201811141809"},
         "name":"芳芳不慌","userid":34567,"picture":"http://localhost:8080/Blog/userHeadPortrait/usepricture.jpeg"
         }]
         *是一个集合，里面存放的是用户评论的对象
         */
        var globalNewCommentListJson;

        /**
         * 当前文章的发布时间，这个是该文章的主键
         * 通过请求传递过来
         */
        var currentArticlePublishTime = "${requestScope.article.articlePublishTime}";
        //var address="${requestScope.article.articleAddress}";
		//alert(currentArticlePublishTime)
        /**
         * 文章翻页的实现，是一个list，里面存放的是
         * 文章对象
         */
        var articlePageList;


        /**
         * 文章推荐的列表数据，存放的依旧是文章的相关信息
         */
        var tuijinaArticleList;

        window.onload = function (ev) {

            var formatDateAndTime;
            /**
             * 格式化字符
             */
            formatDateAndTime = function (timeAndDate) {
                var year = timeAndDate.substring(0, 4);
                var month = timeAndDate.substring(4, 6)
                var day = timeAndDate.substring(6, 8)
                var hours = timeAndDate.substring(8, 10)
                var seconds = timeAndDate.substring(10, 12);
                var time = year + "-" + month + "-" + day + " " + hours + ":" + seconds;
                return time;
            }


            /**
             * 设置内部iframe的高度
             * @param iframe
             */
            function setIframeHeight(iframe) {
                if (iframe) {
                    var iframeWin = iframe.contentWindow || iframe.contentDocument.parentWindow;
                    if (iframeWin.document.body) {
                        iframe.height = iframeWin.document.documentElement.scrollHeight || iframeWin.document.body.scrollHeight;
                    }
                }
            }

            var iframeObj = document.getElementById("iframe");
            setIframeHeight(iframeObj)


            //定义搜索界面的点击事件的处理
            var imgButton = document.getElementById("searchButton");
            imgButton.onclick = function (ev) {
                var inputObj = document.getElementsByClassName("inputSearch")[0];
                if (inputObj.value == "全站搜索" || "" == inputObj.value) {
                    alert("请填写正确的查询条件")
                } else {
                    //在这里进行查询
                }
            }


            /**
             * 下面是对文章请求的处理
             */
            function Request() {


                /**
                 * 创建一个ajax对象
                 */
                this.createAJAX = function () {
                    var xhr;
                    if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                        xhr = new XMLHttpRequest();
                    }
                    else {// code for IE6, IE5
                        xhr = new ActiveXObject("Microsoft.XMLHTTP");
                    }

                    return xhr;
                }

                /**
                 * @param url 请求的资源的地址
                 * @param parseJsonData ajax响应数据产生的回调函数
                 */
                this.requestGet = function (url, parseJsonData) {
                    var xhr = this.createAJAX();
                    //alert(xhr)
                    xhr.open("GET", url, true);
                    xhr.send();
                    xhr.onreadystatechange = function (ev) {
                        // alert(xhr.status)
                        if (xhr.readyState == 4) {
                            if (xhr.status == 200) {
                                var response = xhr.responseText;
                                parseJsonData(response);
                            }
                        }
                    }
                }

                /**
                 * @param url 请求的url
                 * @param parseJsonData 响应的回调函数
                 * @param requestparam 请求的参数
                 */
                this.requestPost = function (url, parseJsonData, requestparam) {
                    var xhr = this.createAJAX();
                    xhr.open("POST", url, true);
                    xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                    xhr.send(requestparam);
                    //alert(requestparam)
                    xhr.onreadystatechange = function (ev) {
                        // alert(xhr.status)
                        if (xhr.readyState == 4) {
                            if (xhr.status == 200) {
                                var response = xhr.responseText;
                                parseJsonData(response);
                            }
                        }
                    }
                }

            }

            function ParseResponse() {
                /**
                 * 解析最新的评论
                 * @param jsonResponse
                 */
                this.newCommentList = function (jsonResponse) {
                    //alert(jsonResponse)
                    globalNewCommentListJson = jsonResponse;
                    var commentArea = document.getElementById("commentArea");
                    var commentCountNumber = document.getElementById("commentCountNumber");
                    var newCommentListObj = JSON.parse(jsonResponse);
                    commentCountNumber.innerText = newCommentListObj.length;
                    //alert(jsonResponse)
                    commentArea.innerHTML = "";
                    (function () {
                        for (var i = 0; i < newCommentListObj.length; i++) {
                            var articleComment = newCommentListObj[i].articleComment;
                            var content = articleComment.content;
                            var commentTime = formatDateAndTime(articleComment.commentTime);
                            var name = newCommentListObj[i].name;
                            var picture = newCommentListObj[i].picture;
                            var innerHtml = "                            <div class=\"commentSingle\">\n" +
                                "                                <img src=\"" + picture + "\" align=\"top\" class=\"commentListUserHead\">\n" +
                                "                                <div class=\"allComment\">\n" +
                                "                                    <div class=\"dimension\"></div>\n" +
                                "                                    <h5><span class=\"currentSelect \">" + name + "</span></h5>\n" +
                                "                                    <p class=\"commentContent\">" + content + "</p>\n" +
                                "                                    <span class=\"commentDate\">" + commentTime + "</span>\n" +
                                "                                </div>\n" +
                                "                            </div>";
                            commentArea.innerHTML += innerHtml;

                        }
                    })();

                }

                this.flushCommentList = function () {
                    var request = new Request();
                    var parse = new ParseResponse();
                    var newCommentListAddress = "http://localhost:8080/Blog/ArticleCommentServlet?articlePublishTime="+currentArticlePublishTime+"&size=6";
                    request.requestGet(newCommentListAddress, parse.newCommentList)
                }

                this.parseUserComment = function (jsonResponse) {
                    //alert(jsonResponse)
                    var responseData = JSON.parse(jsonResponse);
                    var loginurl = "http://localhost:8080/Blog/html/html/login.html";
                    switch (responseData.errorCode) {
                        case 1:
                            break;
                        case 2:
                            alert(responseData.errorCause)
                            break;
                        case 3:
                            location.href = loginurl;
                            break;
                    }

                    if (responseData.errorCode == 3) {
                        return;
                    }

                    //刷新评论
                   var request = new Request();
                    var parse = new ParseResponse();
                    var newCommentListAddress = "http://localhost:8080/Blog/ArticleCommentServlet?articlePublishTime="+currentArticlePublishTime+"&size=6";
                    request.requestGet(newCommentListAddress, parse.newCommentList)

                }
                
                this.postUserComment=function(jsonResponse){
                		//alert(jsonResponse)
                		var responseObj=JSON.parse(jsonResponse);
                		var userComment = document.getElementsByName("userComment")[0];
                		//"响应成功","请求参数错误","用户未登录","服务器内部出错，请稍后再试"
                		switch(responseObj.errorCode){
                			case 1:
                				userComment.value="";
                				//"响应成功,刷新评论
                				  var request = new Request();
                    			  var parse = new ParseResponse();
                    			  var newCommentListAddress = "http://localhost:8080/Blog/ArticleCommentServlet?articlePublishTime="+currentArticlePublishTime+"&size=6";
                    			  request.requestGet(newCommentListAddress, parse.newCommentList)
                			break;
                			case 2:
                				alert(responseObj.errorCause)
                				userComment.value="";
                			break;
                			case 3:
                				location.href="http://localhost:8080/Blog/html/html/login.html";
                			break;
                			case 4:
                				userComment.value="";
                			break;
                		}
                }
                
                /**
                 * 获得文章的翻页后的文章信息列表
                 */
                this.getPageArticleInfo = function (jsonResponse) {
                    //alert(jsonResponse);
                    var pageArticleList = JSON.parse(jsonResponse);
                    // pageArticleList = pageArticleList[0];
                    articlePageList = jsonResponse;
                    var pageConvert = document.getElementById("pageConvert");
                    pageConvert.innerHTML = "";
                    (function () {
                        for (var i = 0; i < pageArticleList.length; i++) {
                            var articleObj = pageArticleList[i][0];
                       
                            if(articleObj==null){
                            	  var inner = "<p>上一篇：<a href=\"#\" class='articlePageLink'><span>没有文章了</span></a></p>";
                            }else{
                            	 var articleName = articleObj.articleName;
                            	  var inner = "<p>下一篇：<a href=\"#\" class='articlePageLink'><span>" + articleName + "</span></a></p>";	   	
                            }
                            pageConvert.innerHTML += inner;
                        }
                    })();

                    //下面处理里面的点击事件
                    (function () {
                        var linkObj = pageConvert.getElementsByClassName("articlePageLink");
                        var iframe = document.getElementById("iframe");
                        for (var i = 0; i < pageArticleList.length; i++) {
                        	if(linkObj[i].innerText=="<span>没有文章了</span>"){
                        		//代表的是没有数据，直接continue
                        		continue;
                        	}
                            linkObj[i].index = i;
                            linkObj[i].onclick = function () {
                                var articleAddress = pageArticleList[this.index][0].articleAddress;
                                iframe.src = articleAddress;
                                setIframeHeight(iframeObj)	
                                //更新当前的页面的信息
                                currentArticlePublishTime = pageArticleList[this.index][0].articlePublishTime;
                                alert(currentArticlePublishTime)
                                //更新当前的网页的链接内容
                                var request = new Request();
                                var parse = new ParseResponse();
                                var url = "http://localhost:8080/Blog/ArticleServlet?articlePublishTime=" + currentArticlePublishTime
                                    + "&size=1";
                                request.requestGet(url, parse.getPageArticleInfo);
                            }
                        }
                    })();
                }
                
                
                /**
                获得文章的浏览量的回调，在这里去更新当前文章的浏览量，以及
                */
                this.articleReadCount=function(jsonResponse){
                	//alert(jsonResponse)
                	var jsonDataObj=JSON.parse(jsonResponse);
                	var count=jsonDataObj.count;
                    //文章的阅读量
                    var readCount=document.getElementById("readCount");
                    readCount.innerHTML="浏览量: "+count;
                }
                

                /**
                 * 获得最新的文章的相关信息
                 */
                this.nowArticleInfo = function (jsonResponse) {
                    //alert(jsonResponse)
                    var articleJson = JSON.parse(jsonResponse);
                    var tuijianBox = document.getElementById("tuijianArticleListBox");
                    tuijianBox.innerHTML = "";
                    (function () {
                        for (var i = 0; i < articleJson.length; i++) {
                            var article = articleJson[i];
                            var articleName = article.articleName;
                            var inner = " <a href=\"#\" class='singleTuijian'>\n" +
                                "                        <li class=\"tuijianArticleList\">\n" +
                                "                            <span class=\"tuijianArticleRank\">" + (i + 1) + "</span>\n" +
                                "                            <span class=\"tuijianArticleName\">" + articleName + "</span>\n" +
                                "                        </li>\n" +
                                "                    </a>";
                            tuijianBox.innerHTML += inner;
                        }
                        var tuijianSingle = document.getElementsByClassName("singleTuijian");
                        //文章的标题
                        var articleHead=document.getElementsByClassName("articleHead")[0];
                        //文化的发布时间
                        var editTime=document.getElementById("editTime");
                        //文章的作者名称
                        var authorName=document.getElementById("authorName");
                        
                        var iframe = document.getElementById("iframe");
                        for (i = 0; i < articleJson.length; i++) {
                        	tuijianSingle[i].index=i;
                            tuijianSingle[i].onclick = function (ev) {
                            	
                                var articleAddress = articleJson[this.index].articleAddress;
                                iframe.src = serverRoot+articleAddress;
                                currentArticlePublishTime = articleJson[this.index].articlePublishTime;
                                //修改文章标题  编辑时间  浏览量 作者 ，更新浏览量
                                articleHead.innerHTML=articleJson[this.index].articleName;
                                editTime.innerHTML="编辑时间:"+formatDateAndTime(articleJson[this.index].articlePublishTime);
                                authorName.innerHTML=articleJson[this.index].user.name;
                                //下面是去更新浏览量
                                var request = new Request();
                                var parse = new ParseResponse();
                				var addReadRecord = "http://localhost:8080/Blog/ArticleServlet?articlePublishTime="+currentArticlePublishTime+"&opration=addReadRecords";
                				request.requestGet(addReadRecord, parse.articleReadCount);
                            }
                        }
                    })();
                }
                
                
                /*
                下面的代码是用来检测用户是否已经登录
                */
                
                /**
                 * 用户状态的查询
                 * @param ev
                 */
                this.userLoginInfo = function (jsonResponse) {
                   //alert(jsonResponse)
                    var userStatus = JSON.parse(jsonResponse);
                    var responseResult=userStatus.responseResult;
                    if (responseResult.errorCode == 1) {
                        var userInfo = userStatus.user;
                        var urlAddress="http://localhost:8080/Blog/UserServlet?cancellation=true";
                        //代表已经登录了
                        var innerhtml = "            <a href=\"userCenter.html\"><img data-v-07578fd8=\"\" height=\"30\" src=\"" +serverRoot+ userInfo.picture + "\" class=\"img-item-user\"/></a>\n" +
                            "            <a href=\"#\" class=\"cancellationButton\"><span data-v-07578fd8=\"\" class=\"item-text\">注销</span></a>"
                        var loginBox = document.getElementById("login-box");
                        loginBox.innerHTML = innerhtml;
  
                        var cancellationButton=document.getElementsByClassName("cancellationButton")[0];
                        cancellationButton.onclick=function(ev){
                        	var request = new Request();
                            var parseData = new ParseResponse();		
                            //请求下线地址返回数据
                            request.requestGet(urlAddress, parseData.parseCanellationData);
                        }
                    }
                }
                   
                    this.parseCanellationData=function(jsonResponse){
                    	window.location.reload();
                    }
                
                
            }


            /**
             * 请求数据,获得文章的评论信息
             */
            (function () {
                var request = new Request();
                var parse = new ParseResponse();
                var newCommentListAddress = "http://localhost:8080/Blog/ArticleCommentServlet?articlePublishTime="+currentArticlePublishTime+"&size=6";
                request.requestGet(newCommentListAddress, parse.newCommentList)
            })();

            /**
             * 最新评论的点击事件的处理
               刷新最新的评论
             */
            (function () {
                var nowCommentButton = document.getElementById("commentMenu");
                nowCommentButton.onclick = function (ev) {
                    var request = new Request();
                    var parse = new ParseResponse();
                    var newCommentListAddress = "http://localhost:8080/Blog/ArticleCommentServlet?articlePublishTime="+currentArticlePublishTime+"&size=6";
                    request.requestGet(newCommentListAddress, parse.newCommentList)
                }
            })();

            /**
             * 下面底点击评论的点击实现
             */
            (function () {
                var commentSubmit = document.getElementById("commentSubmit");
                var userComment = document.getElementsByName("userComment")[0];
                commentSubmit.onclick = function (ev) {
                	if(userComment.value==null||userComment.value.length==0){
                		alert("请输入评论内容");
                		return;
                	}
                    var request = new Request();
                    var parseRequest = new ParseResponse();
                    var requestUrl = "http://localhost:8080/Blog/ArticleCommentServlet";
                    var requestParam = "articlePublishTime=" + currentArticlePublishTime
                        + "&content=" + userComment.value;
                    //alert(requestParam)
                    request.requestPost(requestUrl, parseRequest.postUserComment, requestParam);
                }
            })();


            /**
             * 文章的地址
             */
            (function () {
                var alink = document.getElementById("pageAddress");
                // location.href;
                alink.href = location.href;
                alink.innerText = location.href;
                alink.style.color = "#c15127";
            })();

            /**
             * 文章翻页功能的实现，
             * 获得发布时间比当前文章前和后的文章的信息
             * articlePageList
             */
            (function () {
                var request = new Request();
                var parse = new ParseResponse();
                var url = "http://localhost:8080/Blog/ArticleServlet?articlePublishTime=" + currentArticlePublishTime
                    + "&size=1";
                request.requestGet(url, parse.getPageArticleInfo);

            })();

            /**
             * 获得最新的文章的信息
             * 热门推荐文章列表
             */
            (function () {
                var request = new Request();
                var parse = new ParseResponse();
                var url = "http://localhost:8080/Blog/ArticleServlet?current=10"
                request.requestGet(url, parse.nowArticleInfo);
            })();
            
            
            /**
            检验用户是否已经登录
            */
            (function(){
            	var requestUserStatus="http://localhost:8080/Blog/UserServlet?status=1";
                var req = new Request();
                var parseRequest = new ParseResponse();
                req.requestGet(requestUserStatus, parseRequest.userLoginInfo);
            })();
            
        }
    </script>
    
      <style>
        div.wrapper {
            background-color: #f7f7f7;
            overflow: hidden;
        }

        div.wrapper div.container {
            width: 1300px;
            overflow: hidden;
            margin: 20px auto 0px;
        }

        div.wrapper div.container div.leftArticle {
            width: 900px;
            display: inline-block;
            background-color: #FFFFFF;
            overflow: hidden;
        }

        div.wrapper div.container div.leftArticle h3.articleHead {
            text-align: center;
            margin: 20px 0;
        }

        div.wrapper div.container div.leftArticle div.articleDesBox {
            border-top: 1px dashed #ac5a24;
            margin: 10px 10px 10px 10px;
            border-bottom: 1px dashed #ac5a24;

        }

        div.wrapper div.container div.leftArticle ul.articleDes {
            width: 550px;
            height: 30px;
            margin: 0 auto;

        }

        div.wrapper div.container div.leftArticle ul.articleDes li {
            display: inline-block;
            margin-left: 20px;
            text-align: center;
            line-height: 30px;
        }

        div.wrapper div.container div.leftArticle div.articleBottom {
            margin-left: 10px;
            overflow: hidden;
        }

        div.wrapper div.container div.leftArticle div.articleBottom p.zhichi {
            text-align: center;
            margin-top: 10px;
            margin-bottom: 10px;
        }

        div.wrapper div.container div.leftArticle div.articleBottom div.leftWeChat {
            width: 410px;
            display: inline-block;
            text-align: center;
        }

        div.wrapper div.container div.leftArticle div.articleBottom div.erweima {
            display: inline-block;
            margin-top: 5px;
        }

        div.wrapper div.container div.leftArticle div.articleBottom div.aliPay {
            width: 410px;
            text-align: center;
            display: inline-block;
        }

        div.wrapper div.container div.leftArticle div.articleBottom div.pageConvert {
            margin-top: 20px;
        }

        div.wrapper div.container div.leftArticle div.articleBottom div.articleCommentBox {
            width: 770px;
        }

        div.wrapper div.container div.rightPlayBox {
            overflow: hidden;
            width: 30%;
            float: right;
        }

        /**
        文章的评论
         */
        div.articleCommentBox div.commentArea {
            margin-left: 10px;
            margin-top: 40px;
        }

        div.commentSingle {
            margin-bottom: 20px;
        }

        div.commentArea textarea.videoComment {

            border: 1px solid #b1afb4;
            border-radius: 3px;
            padding: 5px;
            margin-left: 10px;
            width: 650px;
            height: 128px;
            resize: none;

        }

        div.commentArea input.commentSubmit {
            display: block;
            float: right;
            margin: 5px 50px 10px 0px;
            color: #ff1e21;
            text-decoration: underline;
            background: none;
        }

        div.commentArea img.userHeader, img.commentListUserHead {
            border-radius: 25px;
            width: 50px;
            height: 50px;
        }

        div.allComment {
            display: inline-block;
        }
        
        div.articleCommentBox div.commentList{
        overflow: hidden;
        margin-top: 40px;
        }

        div.articleCommentBox div.commentList span.commentCount {
            background-color: #e5e3e8;
            border: 1px solid #bfbfbf;
            border-radius: 4px;
            margin-left: 10px;
            color: #8b8b8b;
            padding: 2px;
            /*font-size: 12px;*/
        }

        div.commentList li.commentMenu {
            display: inline-block;
            float: right;
            margin-right: 50px;
        }

        div.articleCommentBox div.commentList li.commentMenu span {
            background-color: #e5e3e8;
            border: 1px solid #bfbfbf;
            border-radius: 4px;
            color: #ff1e21;
            width: 66px;
            padding: 2px;
        }

        div.commentList span.commentCount span.commentCountNumber {
            color: #ff1e21;
        }

        .dimension {
            height: 5px;
        }

        p.commentContent {
            font-size: 13px;
        }

        div.allComment span.commentDate {
            font-size: 14px;
        }

        /**
        搜索的处理
         */
        div.rightPlayBox div.searchArea {
            height: 60px;
            overflow: hidden;
            background-color: #ffffff;
            padding-left: 20px;
        }

        div.rightPlayBox div.searchArea div.searchBox {
            height: 35px;
            border: 1px solid #a1a1a1;
            position: relative;
            width: 300px;
            top: 12px;
            padding-left: 10px;
            border-radius: 5px;

        }

        div.rightPlayBox div.searchArea div.searchBox img.searchIcon {
            position: relative;
            top: 9px;
        }

        .bgcolor_1 {
            border: 1px solid #0C77CF;
            background-color: #0C77CF;
        }

        .bgcolor_2 {
            border: 1px solid #ff5ecf;
            background-color: #ff5ecf;
        }

        .bgcolor_3 {
            border: 1px solid #00cf0c;
            background-color: #00cf0c;
        }

        .bgcolor_4 {
            border: 1px solid #cfb700;
            background-color: #cfb700;
        }

        .fontColor {
            color: #ffffff;
        }

        div.rightPlayBox div.side-nav {
            overflow: hidden;
            margin-top: 20px;
            padding: 10px;
            background-color: #ffffff;
        }

        div.rightPlayBox div.side-nav li.nav-1 {
            width: 40%;
            height: 40px;
            text-align: center;
            float: left;
            line-height: 40px;
            margin-right: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
        }

        div.rightPlayBox div.side-nav li.nav-2 {
            width: 40%;
            height: 40px;
            float: right;
            text-align: center;
            line-height: 40px;
            margin-right: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
        }

        div.hottuijian {
            overflow: hidden;
            padding: 0px 10px 10px 0px;
            background-color: #ffffff;
            margin-top: 20px;
            margin-bottom: 10px;
        }

        div.learnBlog {
            border-left: 2px solid #89344f;
            padding-left: 10px;
            font-size: 1pc;
            font-family: "Microsoft YaHei";
            margin-bottom: 10px;
        }

        /**
        处理推荐列表的数据
         */
        div.tuijianArticleListBox {
            margin: 5px;
        }

        li.tuijianArticleList {
            overflow: hidden;
            height: 40px;
            padding: 5px 5px 5px 10px;
            margin: 0 10px 0px 10px;
            border-bottom: 1px solid #dddddf;
        }

        li.tuijianArticleList span.tuijianArticleRank {
            display: inline-block;
            height: 20px;
            width: 20px;
            margin-right: 10px;
            background-color: #f9ff00;
            position: relative;
            top: 5px;

            line-height: 20px;
            text-align: center;
            color: #FFFFFF;
            border-radius: 5px;
            border: 1px solid #f9ff00;
        }

        span.tuijianArticleName {
            display: inline-block;
            position: relative;
            top: 10px;
            overflow: hidden;
            font-size: 13px;
        }
        
        
       img.img-item-user {
            position: relative;
            top: 10px;
            margin-right: 10px;
            border-radius: 15px;
        }
        
        /*当前页面的版权信息*/
        div.copyRightBottomBox{
        	background-color: #fff;
        	height: 50px;
        	font-size:12px;
        	color:#504d50;
        	line-height:50px;
        	text-align: center;
        }
        
    </style>

</head>
<body>
	<div data-v-07578fd8="" class="header-wrap clearfix">
   <span style="display: inline-block;height: 60px;font-size: 22px;line-height: 60px;color: #111;">小芳芳的博客</span>
    <div data-v-07578fd8="" class="nav-wrap">
        <ul data-v-07578fd8="" class="nav-list">
            <li data-v-07578fd8="" class="nav-item "><a href="../../Blog/html/html/index.html">首页</a></li>
            <li data-v-07578fd8="" class="nav-item"><a href="../../Blog/html/html/videoPage.html" class="linkPage">免费视频教程</a></li>
            <li data-v-07578fd8="" class="nav-item"><a href="../../Blog/html/html/webMode.html" class="linkPage">网站模板</a></li>
            <li data-v-07578fd8="" class="nav-item"><a href="../../Blog/html/html/studyPage.html" class="linkPage">学无止境</a></li>
            <li data-v-07578fd8="" class="nav-item"><a href="../../Blog/html/html/personalNotePage.html" class="linkPage">个人日记</a></li>
            <li data-v-07578fd8="" class="nav-item"><a href="../../Blog/html/html/learnMe.html" class="linkPage">关于方志月</a></li>
            <li data-v-07578fd8="" class="nav-item"><a href="../../Blog/html/html/leaveMessage.html" class="linkPage">留言板</a></li>
        </ul>
        <div data-v-07578fd8="" class="login-box" id="login-box">
            <a href="../../Blog/html/html/login.html"><span data-v-07578fd8="" class="item-text">登录</span></a>/
            <a href="../../Blog/html/html/login.html"><span data-v-07578fd8="" class="item-text">注册</span></a>

        </div>

    </div>
</div>


<!--文章的阅读界面-->
<div class="wrapper">
    <!--内容的界面-->
    <div class="container">
        <div class="leftArticle">
            <h3 class="articleHead">${requestScope.article.articleName}</h3>
            <div class="articleDesBox">
                <ul class="articleDes">
                    <li id="editTime">编辑时间： ${requestScope.time}</li>
                    <li id="readCount">浏览量：${requestScope.count}</li>
                    <li id="authorName">作者：${requestScope.authorName}</li>
                </ul>
            </div>

            <!--下面文章的显示-->
                <!--文章的信息显示-->
                <iframe src="${path}${requestScope.article.articleAddress}" id="iframe" width="900px" scrolling="no"></iframe>
            <div class="articleBottom">
                <!--文章出处-->
                <p>本文出处:<a href="" id="pageAddress"></a></p>
                <!--支持-->
                <p class="zhichi">
                    写文章不易，如果您觉得文章对你有帮助。<br>
                    打赏激励下作者吧，谢谢支持！ ~(@^_^@)~！
                </p>

                <!--打赏-->
                <div>
                    <div class="leftWeChat">
                        <p>微信扫一扫</p>
                        <div class="erweima">
                            <img src="/Blog/html/img/alipay-ds.jpg" height="160px"/>
                        </div>
                    </div>
                    <div class="aliPay">
                        <p>支付宝扫一扫</p>
                        <div class="erweima">
                            <img src="/Blog/html/img/weChat-ds.jpg" height="160px"/>
                        </div>
                    </div>
                </div>

                <!--翻页功能-->
                <div class="pageConvert" id="pageConvert">
                    <p>上一篇：<a href="#"><span>高端响应式博客自媒体wordpress博客模板</span></a></p>
                    <p>下一篇：<a href="#"><span>没有文章了</span></a></p>
                </div>

                <!--下面是文章的评论-->
                <div class="articleCommentBox">
                    <!--用户留言-->
                    <div class="commentArea">
                        <img src="http://localhost:8080/Blog/jsp/images/head.jpeg" class="userHeader" align="left" hspace="10px">
                        <form action="#" method="post">
                            <textarea name="userComment" value="有什么想对方志月这小子说的" class="videoComment"></textarea>
                            <input type="button" value="点击评论" class="commentSubmit" id="commentSubmit">
                        </form>
                    </div>
                    <!--留言列表-->
                    <div class="commentList">
                                <span class="commentCount"><span class="commentCountNumber"
                                                                 id="commentCountNumber">1</span>条评论</span>
                        <li class="commentMenu" id="commentMenu"><a href="#"><span>最新评论</span></a></li>
                        <!--分割线-->
                        <div style="background-color: #cccccc;height: 1px;margin:10px"></div>
                        <div class="commentArea" id="commentArea">
                            <!--<div class="commentSingle">-->
                            <!--<img src="../images/head.jpeg" align="top" class="commentListUserHead">-->
                            <!--<div class="allComment">-->
                            <!--<div class="dimension"></div>-->
                            <!--<h5><span class="currentSelect ">帅帅的小伙子</span></h5>-->
                            <!--<p class="commentContent">这么帅气的视频，我一定要好好看完这些东西</p>-->
                            <!--<span class="commentDate">2018年11月14日</span>-->
                            <!--</div>-->
                            <!--</div>-->
                        </div>
                    </div>
                </div>

            </div>
        </div>
        <!--右边的导航-->
        <div class="rightPlayBox">
            <div class="searchArea">
                <div class="searchBox">
                    <input type="text" maxlength="40" size="24" value="全站搜索" class="inputSearch">
                    <img src="/Blog/jsp/images/search.svg" class="searchIcon" id="searchButton"/>
                </div>
            </div>
            <div>
                <!--常见模块-->
                <div data-v-d0a26284="" class="side-nav">
                    <ul data-v-d0a26284="" class="clearfix">
                        <li data-v-d0a26284="" class="nav-1 bgcolor_1"><a data-v-d0a26284="" href="../../Blog/html/html/learnMe.html"
                                                                          class="fontColor">关于我</a></li>
                        <li data-v-d0a26284="" class="nav-2 bgcolor_2"><a data-v-d0a26284="" href="../../Blog/html/html/videoPage.html"
                                                                          class="fontColor">视频教程</a></li>
                        <li data-v-d0a26284="" class="nav-1 bgcolor_3"><a data-v-d0a26284="" href="#"
                                                                          class="fontColor">SEO优化</a></li>
                        <li data-v-d0a26284="" class="nav-2 bgcolor_4"><a data-v-d0a26284=""
                                                                          href="../../Blog/html/html/leaveMessage.html"
                                                                          class="fontColor">留言版</a></li>
                    </ul>
                </div>
            </div>

            <!--下面是热门文章的显示-->
            <div class="hottuijian">
                <!--热门推荐-->
                <div class="learnBlog">
                    <span>热门推荐</span>
                </div>

                <div class="tuijianArticleListBox" id="tuijianArticleListBox">
                    <a href="#">
                        <li class="tuijianArticleList">
                            <span class="tuijianArticleRank">1</span>
                            <span class="tuijianArticleName">今天给大家分享的主题是前端的自我成长</span>
                        </li>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 网页的底部数据 -->
	<div class="copyRightBottomBox">
  		<p>Design by：段亮 备案号：湘ICP备14011335号-2</p>
	</div>
</body>
</html>