# OpenMathematicaAppFromCLIWithJava1.6

## Note

### Motivation

Starting Mathematica.app from CLI using 

    open -a /Applications/Mathematica.app

will ensure that the environment variables such as `JAVA_HOME` set in
`$HOME/.bashrc` is loaded before Mathematica.app is started. 

### Verify version of Java and related environment variables

One can verify the version of Java and environment variables at Unix command-line and in Mathematica are consistent.

#### In Mathematica

    In[1]:= Import["!echo $JAVA_HOME", "Text"]
    
    Out[1]= "/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home"
    
    In[2]:= Environment["JAVA_HOME"]
    
    Out[2]= "/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home"


    In[8]:= Needs["JLink`"]
    ReinstallJava[]
    LoadJavaClass["java.lang.System"]
    java`lang`System`getProperty["java.version"]
    
    Out[9]= LinkObject["'/Applications/Mathematica.app/SystemFiles/Links/JLink/JLink.app/Contents/MacOS/JavaApplicationStub' -init \"/tmp/m00000636111\"", 190, 4]
    
    Out[10]= JLink`JavaClass["java.lang.System", 0, {JLink`JVM["vm1"]}, 1, "java`lang`System`", False, True]
    
    Out[11]= "1.6.0_65"
    
    
    
    In[12]:= Needs["JLink`"]
    ReinstallJava[CommandLine->"java"]
    LoadJavaClass["java.lang.System"]
    java`lang`System`getProperty["java.version"]
    
    Out[13]= LinkObject[java -classpath "/Applications/Mathematica.app/SystemFiles/Links/JLink/JLink.jar" -Xdock:name=J/Link -Xmx256m  -Djava.system.class.loader=com.wolfram.jlink.JLinkSystemClassLoader com.wolfram.jlink.Install -init "/tmp/m00000736111",197,4]
    
    Out[14]= JavaClass[java.lang.System,<>]
    
    Out[15]= 1.6.0_65

#### At UNIX command-line

    16:20 meng@meng2maclap:~$ which java
    /usr/bin/java
    16:37 meng@meng2maclap:~$ java -version
    java version "1.6.0_65"
    Java(TM) SE Runtime Environment (build 1.6.0_65-b14-462-11M4609)
    Java HotSpot(TM) 64-Bit Server VM (build 20.65-b04-462, mixed mode)
    16:37 meng@meng2maclap:~$ /usr/libexec/java_home -V
    Matching Java Virtual Machines (4):
        1.8.0, x86_64:	"Java SE 8"	/Library/Java/JavaVirtualMachines/jdk1.8.0.jdk/Contents/Home
        1.7.0_51, x86_64:	"Java SE 7"	/Library/Java/JavaVirtualMachines/jdk1.7.0_51/Contents/Home
        1.6.0_65-b14-462, x86_64:	"Java SE 6"	/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
        1.6.0_65-b14-462, i386:	"Java SE 6"	/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
    
    /Library/Java/JavaVirtualMachines/jdk1.8.0.jdk/Contents/Home
    16:37 meng@meng2maclap:~$ /usr/libexec/java_home -Vv 1.6*
    Matching Java Virtual Machines (2):
        1.6.0_65-b14-462, x86_64:	"Java SE 6"	/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
        1.6.0_65-b14-462, i386:	"Java SE 6"	/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
    
    /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home
    16:37 meng@meng2maclap:~$ 
