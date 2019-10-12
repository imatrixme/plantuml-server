<%@ page info="index" contentType="text/html; charset=utf-8" pageEncoding="utf-8" session="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="cfg" value="${applicationScope['cfg']}" />
<c:set var="contextroot" value="${pageContext.request.contextPath}" />
<c:if test="${(pageContext.request.scheme == 'http' && pageContext.request.serverPort != 80) ||
        (pageContext.request.scheme == 'https' && pageContext.request.serverPort != 443) }">
    <c:set var="port" value=":${pageContext.request.serverPort}" />
</c:if>
<c:set var="scheme"
    value="${(not empty header['x-forwarded-proto']) ? header['x-forwarded-proto'] : pageContext.request.scheme}" />
<c:set var="hostpath" value="${scheme}://${pageContext.request.serverName}${port}${contextroot}" />
<c:if test="${!empty encoded}">
    <c:set var="imgurl" value="${hostpath}/png/${encoded}" />
    <c:set var="svgurl" value="${hostpath}/svg/${encoded}" />
    <c:set var="txturl" value="${hostpath}/txt/${encoded}" />
    <c:if test="${!empty mapneeded}">
        <c:set var="mapurl" value="${hostpath}/map/${encoded}" />
    </c:if>
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="expires" content="0" />
    <meta http-equiv="pragma" content="no-cache" />
    <meta http-equiv="cache-control" content="no-cache, must-revalidate" />
    <link rel="icon" href="${contextroot}/favicon.ico" type="image/x-icon" />
    <link rel="shortcut icon" href="${contextroot}/favicon.ico" type="image/x-icon" />
    <link rel="stylesheet" href="${contextroot}/plantuml.css" />
    <link rel="stylesheet" href="${contextroot}/webjars/codemirror/3.21/lib/codemirror.css" />
    <script src="${contextroot}/webjars/codemirror/3.21/lib/codemirror.js"></script>
    <!-- <script src="mode/plantuml.js"></script> -->
    <script>
        window.onload = function () {
            var myCodeMirror = CodeMirror.fromTextArea(
                document.getElementById("text"), {
                    lineNumbers: true
                }
            );
        };
    </script>
    <title>PlantUMLServer</title>
</head>

<body>
    <div id="header">
        <%-- PAGE TITLE --%>
        <h1>PlantUML 绘图服务</h1>
        <c:if test="${cfg['SHOW_SOCIAL_BUTTONS'] eq 'on' }">
            <%@ include file="resource/socialbuttons1.html" %>
        </c:if>
        <c:if test="${cfg['SHOW_GITHUB_RIBBON'] eq 'on' }">
            <%@ include file="resource/githubribbon.html" %>
        </c:if>
        <p>查看官方教程 <a href="http://plantuml.com">PlantUML</a> </p>
    </div>
    <div id="content">
        <%-- CONTENT --%>
        <div id="forms">
            <form method="post" accept-charset="UTF-8" action="${contextroot}/form">
                <p>
                    <textarea id="text" name="text" cols="120" rows="10"><c:out value="${decoded}"/></textarea>
                </p>
                <p>
                    <input type="submit" value="渲染" />
                </p>
            </form>
            <hr />
            <p>您也可以提交一条之前的生成的URL:</p>
            <form method="post" action="${contextroot}/form">
                <p>
                    <input name="url" type="text" size="150" value="${imgurl}" />
                    <br />
                </p>
                <p>
                    <input type="submit" value="渲染" />
                </p>
            </form>
            <hr />
            <a href="${svgurl}">查看 SVG 版本</a>&nbsp;
            <a href="${txturl}">查看 ASCII 字符艺术版本</a>&nbsp;
        </div>
        <div id="diagram-zone">
            <c:if test="${!empty imgurl}">
                <c:if test="${!empty mapurl}">
                    <a href="${mapurl}">查看 PNG 版本</a>
                </c:if>
                <c:if test="${cfg['SHOW_SOCIAL_BUTTONS'] == 'on' }">
                    <%@ include file="resource/socialbuttons2.jspf" %>
                </c:if>
                <p id="diagram">
                    <c:choose>
                        <c:when test="${!empty mapurl}">
                            <img src="${imgurl}" alt="PlantUML diagram" />
                        </c:when>
                        <c:otherwise>
                            <img src="${imgurl}" alt="PlantUML diagram" />
                        </c:otherwise>
                    </c:choose>
                </p>
            </c:if>
        </div>
    </div>
    <%-- FOOTER --%>
    <%@ include file="footer.jspf" %>
</body>

</html>