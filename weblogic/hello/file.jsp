<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*" %>
<%
String path  = request.getParameter("path");
File f = new File(path);
FileInputStream i = new FileInputStream(f);
response.setHeader("Content-Disposition","attachment;");
BufferedInputStream input = new BufferedInputStream(i);
BufferedOutputStream output = new BufferedOutputStream(response.getOutputStream());
byte[] data = new byte[1024];
int len = input.read(data);
while (len != -1) {
    output.write(data,0,len);
    len = input.read(data);
}
input.close();
output.close();
%>