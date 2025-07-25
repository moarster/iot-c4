//External
//----------------------
//Границы, шрифт на светлом фоне
!const BLUE_ #0D47A1
//Темный фон (контейнер)
!const BLUE #1565C0
//MESSAGE
!const BLUE- #BBDEFB
//Светлый фон (система)
!const BLUE0 #E3F2FD

//
//----------------------
//Границы, шрифт на светлом фоне
!const GREEN_ #1B5E20
//Темный фон (контейнер)
!const GREEN #2E7D32
//REQUEST
!const GREEN- #C8E6C9
//Светлый фон (система)
!const GREEN0 #E8F5E9

//Aux Tool
//----------------------
//Границы, шрифт на светлом фоне
!const GREY_ #424242
//Темный фон (контейнер)
!const GREY #616161
//VAGUE
!const GREY- #D3D3D3
//Светлый фон (система)
!const GREY0 #F5F5F5

//Kernel Product
//----------------------
//Границы, шрифт на светлом фоне
!const PURPLE_ #4A148C
//Темный фон (контейнер)
!const PURPLE #512DA8
//Средний фон (компонент)
!const PURPLE- #D1C4E9
//Светлый фон (система)
!const PURPLE0 #E1BEE7

//Aux Product
//----------------------
//Границы, шрифт на светлом фоне 
!const TEAL_ #008080
//Темный фон (контейнер)
!const TEAL #5F9EA0
//Средний фон (компонент)
!const TEAL- #B0E0E6
//CHECK
!const TEAL0 #F0FFFF

//Accent
//----------------------
//Границы и шрифт групп
!const RED_ #B71C1C
//
!const RED #C62828
//
!const RED- #FFB6C1
//COMMAND
!const RED0 #FF6347

//SAFE
!const GOLD #DAA520



workspace "Базовые стили" {

    views {
        branding {
            font "Fira Code" https://fonts.googleapis.com/css2?family=Fira+Code
            logo icons/iteco-logo.png
        }
        styles {

            relationship Relationship {
                thickness 3
                style Dotted
                routing Direct
                fontSize 35
                width 300
                color ${GREY_}
            }

        //По характеру
            relationship синхронное {
                style Solid
            }
            relationship асинхронное {
                style Dashed
            }

        //По участникам
            //Пропущены посредники
            relationship косвенное {
                routing Curved
            }
            relationship агрегирующее {
                routing Orthogonal
            }

        //По вкладу
            //Основной бизнес-процесс
            relationship основное {
                thickness 4
            }
            relationship критичное {
                thickness 8
            }
            relationship вспомогательное {
                //Обеспечивающее / инфраструктурное
                thickness 2
            }

        //По сути
            relationship запрос {
                //HTTP,gRPC
                color ${GREEN}
            }
            relationship логин {
                //Аутентификация или авторизация
                color ${TEAL_}
            }
            relationship задача {
                //job,BPMN
                color ${RED0}
            }
            relationship get {
                //Безопасный запрос
                color ${GOLD}
            }
            relationship сообщение {
                color ${BLUE}
            }
            relationship составное {
                color ${GREY}
            }

            element Element {
                color ${RED}
                strokeWidth 8
                stroke ${RED}
                background ${RED0}
            }

            element future {
                border dashed
            }

            element doubt {
                border Dotted
                opacity 70
            }
            element abstract {
                border Dashed
            }
            element Group {
                fontSize 45
                strokeWidth 5
                stroke ${RED_}
                color ${RED_}
            }

            element Boundary {
                fontSize 60
                strokeWidth 6
                metadata false
            }

            //Элементы первого уровня
            element Person {
                shape Person
                metadata false
                width 300
                strokeWidth 8
                stroke ${GOLD}
                fontSize 20
                background white
            }

            element Analyst {
                icon icons/anal.png
            }

            element Administrator {
                icon icons/devops.png
            }

            element Security {
                icon icons/seq.png
            }

            element "Software System" {
                shape RoundedBox
                width 500
                strokeWidth 15
                fontSize 30
                metadata false
            }

            //Палитра категорий
            //--------------------
            //
            //Внешние элементы
            element External {
                stroke ${BLUE_}
            }

            element "External [system]" {
                stroke ${BLUE_}
                color ${BLUE_}
                background ${BLUE0}
            }
            element "External [container]" {
                stroke ${BLUE_}
                color white
                background ${BLUE}
            }

            //Ключевые инструменты
            element Pillar {
                stroke ${GREEN_}
            }
            element "Pillar [system]" {
                stroke ${GREEN_}
                color ${GREEN_}
                background ${GREEN0}
            }
            element "Pillar [container]" {
                stroke ${GREEN_}
                color white
                background ${GREEN}
            }
            element "Pillar [component]" {
                strokeWidth 0
                color ${GREEN_}
                background ${GREEN-}
            }

            //Вспомогательные инструменты
            element Tool {
                stroke ${GREY_}
            }
            element "Tool [system]" {
                stroke ${GREY_}
                color ${GREY_}
                background ${GREY0}
            }
            element "Tool [container]" {
                stroke ${GREY_}
                color white
                background ${GREY}
            }
            element "Tool [component]" {
                strokeWidth 0
                color ${GREY_}
                background ${GREY-}
            }

            //Продукт
            element Product {
                stroke ${PURPLE_}
            }
            element "Product [system]" {
                stroke ${PURPLE_}
                color ${PURPLE_}
                background ${PURPLE0}
            }
            element "Product [container]" {
                stroke ${PURPLE_}
                color white
                background ${PURPLE}
            }
            element "Product [component]" {
                strokeWidth 0
                color ${PURPLE_}
                background ${PURPLE-}
            }

        //Дополнения
            element Addon {
                stroke ${TEAL_}
            }
            element "Addon [system]" {
                stroke ${TEAL_}
                color ${TEAL_}
                background ${TEAL0}
            }
            element "Addon [container]" {
                stroke ${TEAL_}
                color white
                background ${TEAL}
            }
            element "Addon [component]" {
                strokeWidth 0
                color ${TEAL_}
                background ${TEAL-}
            }

            element bus {
                width 1200
                height 200
            }

            element queue {
                shape Pipe
            }

            element Cloud {
                shape Ellipse
                width 800
            }


            element mobile {
                shape MobileDevicePortrait
            }
            element table {
                background ${GOLD}
                strokeWidth 2
            }

            element browser {
                shape WebBrowser
            }
            element window {
                shape Window
            }


            //Элементы второго уровня
            element Container {
                shape RoundedBox
                width 400
                height 250
                strokeWidth 10
                fontSize 25
            }
            element Microservice {
                shape Hexagon
                width 350
            }

            element folder {
                shape Folder
            }
            element db {
                shape Cylinder
                width 250
                height 300
                strokeWidth 5
                fontSize 20
                color white
                background ${RED-}
            }

            //Элементы третьего уровня
            element Component {
                shape Box
                metadata false
                width 400
                height 150
                strokeWidth 0
                fontSize 20
            }
            element tiny {
                width 320
                height 100
                strokeWidth 1
            }
            element API {
                shape Circle
                width 200
                metadata false
            }

        //Иконки
            element Spring {
                icon icons/spring.svg
            }
            element Redis {
                icon icons/redis.svg
            }
            element Java {
                icon icons/java.svg
            }
            element Logback {
                icon icons/logback.svg
            }
            element Grafana {
                icon icons/grafana.svg
            }
            element Prometheus {
                icon icons/prometheus.svg
            }
            element Zipkin {
                icon icons/zipkin.png
            }
            element Postgres {
                icon icons/postgresql.png
            }
            element Mongo {
                icon icons/mongo.svg
            }
            element Rabbit {
                icon icons/rabbit.svg
            }
            element "Spring Cloud" {
                icon icons/spring-cloud.svg
            }
            element "Spring Boot" {
                icon icons/spring-boot.svg
            }
            element Iteco {
                icon icons/iteco-icon.png
            }
            element Keycloak {
                icon icons/keycloak.png
            }
            element ELK {
                icon icons/elk.png
            }
            element Consul {
                icon icons/consul.png
            }
            element Minio {
                icon icons/minio.png
            }
            element Kotlin {
                icon icons/kotlin.svg
            }
            element Kafka {
                icon icons/kafka.png
            }
            element Asupr {
                icon icons/asupr-icon.png
            }
            element Dit {
                icon icons/dit-icon.png
            }
            element Oracle {
                icon icons/oracle.png
            }
            element Haproxy {
                icon icons/haproxy.png
            }
            element Nginx {
                icon icons/nginx.png
            }
            element Python {
                icon icons/python.svg
            }
            element Android {
                icon icons/android.svg
            }
            element Mysql {
                icon icons/mysql.svg
            }

            element "Deployment Node" {
                stroke ${BLUE}
                color ${BLUE}
                strokeWidth 5
            }

            element pv {
                icon icons/pv.svg
            }
            element pod {
                icon icons/pod.svg
            }
            element svc {
                icon icons/svc.svg
            }
            element deploy {
                icon icons/deploy.svg
            }
            element node {
                icon icons/node.svg
            }
            element dock {
                icon icons/dock.svg
            }
            element ep {
                icon icons/ep.svg
            }

            element unreal {
                background ${TEAL}
                stroke ${TEAL_}
                color white
                width 350
                height 180
                fontSize 38
            }

        }
    }
}