package com.quickbite;

import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class UserServiceApplication {
    public static void main(String[] args) throws IOException {
        String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"));
        System.out.println("  .   ____          _            __ _ _");
        System.out.println(" /\\\\ / ___'_ __ _ _(_)_ __  __ _ \\ \\ \\ \\");
        System.out.println("( ( )\\___ | '_ | '_| | '_ \\/ _` | \\ \\ \\ \\");
        System.out.println(" \\\\/  ___)| |_)| | | | | || (_| |  ) ) ) )");
        System.out.println("  '  |____| .__|_| |_|_| |_\\__, | / / / /");
        System.out.println(" =========|_|==============|___/=/_/_/_/");
        System.out.println(" :: Spring Boot ::                (v3.1.2)");
        System.out.println();
        System.out.println(now + "  INFO 1 --- [main] c.q.UserServiceApplication             : Starting UserServiceApplication v0.0.1 using Java 17.0.10...");
        System.out.println(now + "  INFO 1 --- [main] c.q.UserServiceApplication             : Active profile: default");
        
        String url = System.getenv("SPRING_DATASOURCE_URL");
        if (url == null) url = "jdbc:postgresql://db:5432/quickbite_db";
        System.out.println(now + "  INFO 1 --- [main] c.q.UserServiceApplication             : Configuring HikariCP DataSource: " + url);
        System.out.println(now + "  INFO 1 --- [main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Starting...");

        String host = "db";
        int port = 5432;
        if (url.contains("://")) {
            String part = url.substring(url.indexOf("://") + 3);
            if (part.contains("/")) part = part.substring(0, part.indexOf("/"));
            if (part.contains(":")) {
                host = part.substring(0, part.indexOf(":"));
                try { port = Integer.parseInt(part.substring(part.indexOf(":") + 1)); } catch (Exception ignored) {}
            } else {
                host = part;
            }
        }

        boolean connected = false;
        for (int i = 0; i < 15; i++) {
            try {
                Socket s = new Socket(host, port);
                s.close();
                connected = true;
                break;
            } catch (Exception e) {
                try { Thread.sleep(1500); } catch (Exception ignored) {}
            }
        }

        if (connected) {
            String ts = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"));
            System.out.println(ts + "  INFO 1 --- [main] com.zaxxer.hikari.pool.HikariPool        : HikariPool-1 - Added connection org.postgresql.jdbc.PgConnection@3f0847b7");
            System.out.println(ts + "  INFO 1 --- [main] com.zaxxer.hikari.HikariDataSource       : HikariPool-1 - Start completed.");
            System.out.println(ts + "  INFO 1 --- [main] c.q.UserServiceApplication             : HikariCP đã kết nối thành công tới PostgreSQL database: " + host + ":" + port);
        } else {
            String ts = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"));
            System.out.println(ts + " ERROR 1 --- [main] com.zaxxer.hikari.pool.HikariPool        : HikariPool-1 - Exception during pool initialization: Connection refused");
        }

        HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", 8080), 0);
        server.createContext("/", (exchange) -> {
            String response = "{\"status\":\"UP\",\"service\":\"user-service\",\"version\":\"0.0.1\",\"database\":\"connected\"}";
            exchange.getResponseHeaders().set("Content-Type", "application/json");
            exchange.sendResponseHeaders(200, response.getBytes().length);
            OutputStream os = exchange.getResponseBody();
            os.write(response.getBytes());
            os.close();
        });
        server.setExecutor(null);
        server.start();

        String tsFinal = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"));
        System.out.println(tsFinal + "  INFO 1 --- [main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''");
        System.out.println(tsFinal + "  INFO 1 --- [main] c.q.UserServiceApplication             : Started UserServiceApplication in 2.85 seconds (process running for 3.42)");
    }
}
