# Part I. Basics - Chapter 3. The Auxiliary Tools

* System monitoring tools – As is the case with strace and DTrace
* Network monitors – Also fit in the preceding bracket but warrant a category of their own
* VM/runtime monitoring – For example, tools that let us inspect the JVM, etc.
* Profilers and memory monitors

## Dtrace
Here are some common things developers use it for:
* Want to know which files a process has opened?
* Want to know who invokes a kernel API and get a stack trace to the caller?
* Want to know why a process dies?
* Want to know how much CPU time is spent on an operation?

> **👉⚠ NOTE:**  Save your data! **Dtrace** can easily crash your machine, and enabling it requires disabling important security facilities on OS.

### Installation 
* in Ubuntu
```
sudo apt-get install systemtap-sdt-dev
```

### Basic Usage
For example, the following command will log some information from the given callbacks:
```shell
sudo dtrace -qn 'syscall::write:entry, syscall::sendto:entry /pid == $target/ { printf("(%d) %s %s", pid, probefunc, copyinstr(arg1)); }' -p 9999
```
The code snippet passed to the dtrace command listens to the sendto callback on the target process ID (``9999`` in this case). Then it prints out the information to the console, for example, ``9999 text``.
## strace
## Track Regressions with Git Bisect
* target git url: https://github.com/codenameone/CodenameOne
## JMXTerm
* download: https://github.com/jiaqi/jmxterm/releases/download/v1.0.2/jmxterm-1.0.2-uber.jar
* Once downloaded, we can use it to connect to a server using this code:
```shell
java -jar ~/Downloads/jmxterm-1.0.2-uber.jar --url localhost:30002
```
Notice that JMX needs to be explicitly enabled on that JVM. When dealing with a production or containerized server, there will probably be some “ready-made” configuration. However, a vanilla JVM doesn’t have JMX enabled [by default](https://docs.oracle.com/javadb/10.10.1.2/adminguide/radminjmxenabledisable.html).

Once JMX is enabled, you should update the hostname/port based on your connection. Once connected, we can list the JMX domains using the prompt:
```shell
$>domains
#following domains are available
JMImplementation
com.sun.management
java.lang
java.nio
java.util.logging
javax.cache
jdk.management.jfr
```
We can then pick a specific domain to explore; a domain can be any string, but it usually corresponds to package names. Domains help us identify the group of beans in much of the same way as packages group classes together. This is where the visual tool is usually beneficial as it can provide you with faster navigation through the hierarchy and quick assessment of the information. In this case, I just want to set the logging level:
```shell
$>domain java.util.logging
#domain is set to java.util.logging
We can follow this by listing the beans within the domain. Then pick the bean that we wish to use since there’s only one bean in this specific domain:
$>beans
#domain = java.util.logging:
java.util.logging:type=Logging
$>bean java.util.logging:type=Logging
#bean is set to java.util.logging:type=Logging
```
What can I do with this bean? For that, we have the info command that lists the operations and attributes of the bean:
```shell
$>info
#mbean = java.util.logging:type=Logging
#class name = sun.management.ManagementFactoryHelper$PlatformLoggingImpl
# attributes
  %0   - LoggerNames ([Ljava.lang.String;, r)
  %1   - ObjectName (javax.management.ObjectName, r)
# operations
  %0   - java.lang.String getLoggerLevel(java.lang.String p0)
  %1   - java.lang.String getParentLoggerName(java.lang.String p0)
  %2   - void setLoggerLevel(java.lang.String p0,java.lang.String p1)
#there's no notifications
```

Once I have these, I can check the current logger level; it isn’t set since we didn’t set it explicitly and the global default is used. The following code is equivalent to invoking the getLoggerLevel method:
```shell
$>run getLoggerLevel "org.apache.tomcat.websocket.WsWebSocketContainer"
$>run getLoggerLevel "org.apache.tomcat.websocket.WsWebSocketContainer"
#calling operation getLoggerLevel of mbean java.util.logging:type=Logging with params [org.apache.tomcat.websocket.WsWebSocketContainer]
#operation returns:
```
I can explicitly set it to INFO and then get it again to verify that the operation worked as expected using this code. Here, we invoke the setLoggerLevel operation (method), with two parameters. The first parameter is the name of the class where the log level should be changed. The second parameter is the INFO logging level:
```shell
$>run setLoggerLevel org.apache.tomcat.websocket.WsWebSocketContainer INFO
#calling operation setLoggerLevel of mbean java.util.logging:type=Logging with params [org.apache.tomcat.websocket.WsWebSocketContainer, INFO]
#operation returns:
null
$>run getLoggerLevel "org.apache.tomcat.websocket.WsWebSocketContainer"
#calling operation getLoggerLevel of mbean java.util.logging:type=Logging with params [org.apache.tomcat.websocket.WsWebSocketContainer]
#operation returns:
INFO
```

This is just the tip of the iceberg. We can get many things such as spring settings, internal VM information, etc. In this example, I can query VM information directly from the console:
```sjell
$>domain com.sun.management
#domain is set to com.sun.management
$>beans
#domain = com.sun.management:
com.sun.management:type=DiagnosticCommand
com.sun.management:type=HotSpotDiagnostic
$>bean com.sun.management:type=HotSpotDiagnostic
#bean is set to com.sun.management:type=HotSpotDiagnostic
$>info
#mbean = com.sun.management:type=HotSpotDiagnostic
#class name = com.sun.management.internal.HotSpotDiagnostic
# attributes
  %0   - DiagnosticOptions ([Ljavax.management.openmbean.CompositeData;, r)
  %1   - ObjectName (javax.management.ObjectName, r)
# operations
  %0   - void dumpHeap(java.lang.String p0,boolean p1)
  %1   - javax.management.openmbean.CompositeData getVMOption(java.lang.String p0)
  %2   - void setVMOption(java.lang.String p0,java.lang.String p1)
#there's no notifications
```
JMX is a remarkable tool that we mostly use to wire management consoles. It’s remarkable for that, and you should very much export JMX settings for your projects. Having said that, you can take it to the next level by leveraging JMX as part of your debugging process.

Server applications run without a UI or with deep UI separation. JMX can often work as a form of user interface or even as a command-line interface as is the case in JMXTerm. In these cases, we can trigger situations for debugging or observe the results of a debugging session right within the management UI.
 

## jhsdb
Java 9 was all about modules. It was the big change and also the most problematic change. It sucked the air out of every other feature that shipped as part of that release. Unfortunately, one victim of this vacuum was jhsdb which is a complex tool to begin with. This left this amazingly powerful tool in relative obscurity. That’s a shame.

So what is jhsdb? [Oracle documentation defines it as follows](https://docs.oracle.com/en/java/javase/11/tools/jhsdb.html) :

``jhsdb is a Serviceability Agent (SA) tool. Serviceability Agent (SA) is a JDK component used to provide snapshot debugging, performance analysis and to get an in-depth understanding of the Hotspot JVM and the Java application executed by the Hotspot JVM.``

This doesn’t really say much about what it is and what it can do. Here’s my simplified take: it’s a tool to debug the JVM itself and understand core dumps. It unifies multiple simpler tools to get deep insight into the native JVM internals. You can debug JVM failures and native library failures with it.

### Basics of jhsdb
To get started, we can run
```
jhsdb --help
```

This produces the following output:
```shell
clhsdb           command line debugger
hsdb             ui debugger
debugd –help     to get more information
jstack –help     to get more information
jmap   --help    to get more information
jinfo  --help    to get more information
jsnap  --help    to get more information
```

The gist of this is that ``jhsdb`` is really six different tools:
* *debugd* – Acts as a remote debug server we can connect to.
* *jstack* – Stack and lock information.
* *jmap* – Heap memory information.
* *jinfo* – Basic JVM information.
* *jsnap* – Performance information.
* Command-line debugger – I won’t discuss that since I prefer the GUI.
* GUI debugging tool.

#### *debugd*
```
jhsdb debugd --pid 72640
```
#### *jstack*
```
jhsdb jstack --pid 72640
```
Notice a few things of interest:
* We get information about the JVM running.
* It detects deadlocks automatically for us!
* All threads are printed with fullstack and compilation status.
#### *jmap*
```
jhsdb jmap --pid 72640 --heap
```
If you could reproduce a memory leak but you don’t have a debugger attached, you can use
```
jhsdb jmap --pid 72640 --histo
```

#### *jinfo*
```
jhsdb jinfo --pid 72640
```
#### *jsnap*
```
jhsdb jsnap --pid 72640
```
#### *GUI Debugger*
```
jhsdb hsdb --pid 72640
```
## Wireshark
* http://www.wireshark.org/download.html
* http://www.wireshark.org/docs/dfref/
## tcpdump
```
$ sudo tcpdump -i <interface> -w <file>
```

example:
```shell
sudo tcpdump -i en0 -w output
Password:
tcpdump: listening on en0, link-type EN10MB (Ethernet), capture size 262144 bytes
^C3845 packets captured
4189 packets received by filter
0 packets dropped by kernel
```