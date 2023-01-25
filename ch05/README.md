# Part I. Basics - Chapter 5. Time Travel Debugging

Time travel debuggers (TTDs) don’t debug. They track everything we do when using an application. Once we’re done with the application or experienced the failure, we can use the TTD to analyze the broken state and figure out what went wrong. This takes away some of the convenience we have in a regular debugger. We can’t change something and see the impact within the debugger. We can’t change the flow. In that sense, they’re weaker than a regular debugger.
 

 Table 5-1Typical Debugger vs. TTD
| Typical Debugger                      | Time Travel Debugger                                       |
|---------------------------------------|------------------------------------------------------------|
| Interactive, disrupts user experience | Runs in the background, can be used by nontechnical people |
| Sees flow of execution                | Sees flow of entire execution                              |
| Can impact flow of execution          | Flow and values are fixed                                  |
| Impacts flow inadvertently            | Lesser chance of flow impact                               |
| Familiar experience                   | Different process                                          |
| Can be low overhead                   | Impact is always noticeable                                |
| Used by developer                     | Can be used in CI process and by QA                        |

 ## Low-Level Debugging with rr
 * rr project: https://github.com/rr-debugger/rr/
 * spring-petclinic: 
   * https://github.com/spring-petclinic
     * https://github.com/spring-petclinic/spring-petclinic-rest
   * Spring PetClinic 1.5.x: https://github.com/spring-projects/spring-petclinic
   * Azure version: https://github.com/azure-samples/spring-petclinic-microservices

 Once installed, we can record any binary application by prepending its execution with the rr record command. Notice that this will significantly impact the performance of your application. I recorded an execution of the spring boot pet clinic demo application using the following command:

```shell
rr record java -jar spring-petclinic-2.5.0-SNAPSHOT.jar
```
You maybe see the below:
```
rr needs /proc/sys/kernel/perf_event_paranoid <= 1, but it is 4.
Change it to 1, or use 'rr record -n' (slow).
Consider putting 'kernel.perf_event_paranoid = 1' in /etc/sysctl.d/10-rr.conf.
See 'man 8 sysctl', 'man 5 sysctl.d' (systemd systems)
and 'man 5 sysctl.conf' (non-systemd systems) for more details.

```
https://hackmd.io/@Ji0m0/rJvp3iSTX?type=view
  