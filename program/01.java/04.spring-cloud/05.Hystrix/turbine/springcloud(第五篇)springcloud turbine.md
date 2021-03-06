

springcloud(第五篇)springcloud turbine - CSDN博客 http://blog.csdn.net/liaokailin/article/details/51344281

https://github.com/liaokailin/springcloud


spring cloud turbine

简介

turbine是聚合服务器发送事件流数据的一个工具，hystrix的监控中，只能监控单个节点，实际生产中都为集群，因此可以通过 
turbine来监控集群下hystrix的metrics情况，通过eureka来发现hystrix服务。

netflix turbine

使用官方给定的war 
放入tomcat中运行，修改turbine-web-1.0.0/WEB-INF/classes下config.properties文件

turbine.aggregator.clusterConfig=test
turbine.ConfigPropertyBasedDiscovery.test.instances=10.0.80.60,10.0.41.13
turbine.instanceUrlSuffix=:8080/configcenter-web/hystrix.stream
1
2
3
4
turbine.aggregator.clusterConfig 配置集群名称

turbine.ConfigPropertyBasedDiscovery.test.instances 配置集群节点ip(用以发现服务，规则不限在ip列表)

turbine.instanceUrlSuffix 聚合实例访问后缀

重启tomcat后访问http://localhost:${port}/turbine.stream?cluster=test 获取聚合信息

spring cloud turbine

通过EnableTurbine注解启用turbine,需要引入依赖：

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-netflix-turbine</artifactId>
</dependency>
```

Application.java

package com.lkl.springcloud.turbine;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.cloud.netflix.turbine.EnableTurbine;

/**
 * 创建turbine应用
 * Created by liaokailin on 16/5/1.
 */
@SpringBootApplication
@EnableTurbine
public class Application {

    public static void main(String[] args) {
        new SpringApplicationBuilder(Application.class).web(true).run(args);
    }
}

对应配置信息

server.port=9090
spring.application.name=turbine
turbine.appConfig=node01,node02
turbine.aggregator.clusterConfig= MAIN
turbine.clusterNameExpression= metadata['cluster']

turbine.appConfig 配置需要聚合的应用 
turbine.aggregator.clusterConfig turbine需要聚合的集群名称 通过 http://localhost:9090/turbine.stream?cluster=MAIN 访问 
turbine.clusterNameExpression 获取集群名表达式，这里表示获取元数据中的cluster数据，在node01、node02为配置对应信息

eureka服务

通过eureka做服务发现与注册

EurekaServer.java

package com.lkl.springcloud.turbine;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableAutoConfiguration
@EnableEurekaServer
public class EurekaServer {

    public static void main(String[] args) {
        new SpringApplicationBuilder(EurekaServer.class).properties(
                "spring.config.name:eureka", "logging.level.com.netflix.discovery:OFF")
                .run(args);
    }

}

对应配置信息 表明为一个独立的eureka服务

server.port=8761
spring.application.name=eureka
eureka.client.registerWithEureka=false
eureka.client.fetchRegistry=false

Node

需要创建两个节点组成集群，同时向eureka注册服务

Node01.java

package com.lkl.springcloud.turbine;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by liaokailin on 16/5/4.
 */
@Configuration
@EnableAutoConfiguration
@EnableDiscoveryClient
@EnableCircuitBreaker
@RestController
public class Node01 {

    public static void main(String[] args) {
        new SpringApplicationBuilder(Node01.class).properties(
                "spring.config.name:node01").run(args);
    }

    @Autowired
    private HelloService service;

    @RequestMapping("/")
    public String hello() {
        return this.service.hello();
    }


    @Component
    public static class HelloService {

        @HystrixCommand(fallbackMethod="fallback")
        public String hello() {
            return "Hello World";
        }
        public String fallback() {
            return "Fallback";
        }
    }
}

Node01调用hystrix command，对应配置


server.port= 8081 
spring.application.name=node01 
eureka.instance.hostname=localhost 
eureka.instance.metadata-map.cluster=MAIN 

配置比较简单，需要注意的有eureka.instance.hostname,把Node02 展示出来再说明eureka.instance.hostname

Node02.java

package com.lkl.springcloud.turbine;

import com.netflix.hystrix.contrib.javanica.annotation.HystrixCommand;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by liaokailin on 16/5/4.
 */
@Configuration
@EnableAutoConfiguration
@EnableDiscoveryClient
@EnableCircuitBreaker
@RestController
public class Node02 {

    public static void main(String[] args) {
        new SpringApplicationBuilder(Node02.class).properties(
                "spring.config.name:node02").run(args);
    }

    @Autowired
    private HelloService service;

    @RequestMapping("/")
    public String hello() {
        return this.service.hello();
    }


    @Component
 public static class HelloService {

        @HystrixCommand(fallbackMethod="fallback")
        public String hello() {
            return "Hello World";
        }
        public String fallback() {
            return "Fallback";
        }
    }
}

node02.properties

server.port= 8082
spring.application.name=node02
eureka.instance.hostname=mac
eureka.instance.metadata-map.cluster=MAIN
两个节点中eureka.instance.hostname不同 
查看 cat /etc/hosts

127.0.0.1       mac
127.0.0.1   localhost
255.255.255.255 broadcasthost
::1             localhost 

实质指向都为127.0.0.1

这是由于turbine自身的一个bug，eureka.instance.hostname一致时只能检测到一个节点，因此修改hosts，如果是在不同机器演示时不会出现这样的情况

note 节点默认向http://localhost:8761/eureka/apps注册，不需要单独配置

运行

将所有的应用都启动起来，访问http://localhost:8761/ 可以发现注册服务 
eureka server list

在http://localhost:8080/hystrix-dashboard-1.4.10/中输入http://localhost:9090/turbine.stream?cluster=MAIN 得到监控界面;

访问http://localhost:8081/ http://localhost:8082/ 观察dashboard的变化 
turbine dashboard

ok ~ it’s work ! more about is here

转载请注明 
http://blog.csdn.net/liaokailin/article/details/51344281

欢迎关注，您的肯定是对我最大的支持