workspace extends ../../solvo-landscape.dsl {

    name "Системная Архитектура Портала Перевозчика"
    description "[Camunda Edition]"
    properties {
        wiki.document.id GKzQMcy43s
    }
    !impliedRelationships true
    !identifiers hierarchical

    configuration {
        visibility public
        scope softwaresystem
    }

    model {

        router = person "Логист" {
        }
        dispatcher = person "Экспедитор" {
        }
        transport = person Водитель {
            tags future doubt
        }

        !element yPortal {
            description "Система управления запросами КП, проведение тендеров, создание заявок на транспортировку"
            properties {
                wiki.document.id Sl14kRICxJ
            }

            Group FrontEnd {
                web = container "Web-портал" "Доступ к функциям системы через браузер" {
                    tags browser Solvo Product
                    perspectives {
                        Security "TLS/SSL шифрование"
                        Performance "Быстрая загрузка"
                        Scalability "Горизонтальное масштабирование балансировщиком нагрузки"
                        Availability "Высокая доступность с отказоустойчивостью"
                        Regulatory/Compliance "Соответствует требованиям GDPR"
                    }
                }

                app = container "Carrier App" "Мобильное приложение перевозчиков" {
                    tags mobile Solvo Addon future
                    perspectives {
                        Security "Биометрическая аутентификация"
                        Scalability "Поддержка большого количества одновременных пользователей"
                        Availability "Синхронизация с сервером при наличии подключения"
                    }
                }
            }

            apiGateway = container "API Gateway" {
                technology "Spring Cloud Gateway"
                description "Шлюз API для маршрутизации запросов"
                tags bus "Spring Cloud" Product
                perspectives {
                    Security "Защита от DDoS атак"
                    Performance "Кэширование для часто используемых эндпоинтов"
                    Scalability "Горизонтальное масштабирование балансировщиком нагрузки"
                    Availability "Активно-активная конфигурация для отказоустойчивости"
                }
                api = component "Public API" "Публичный API Портала" {
                    tags Pillar API
                    technology "OpenAPI 3.1"
                    perspectives {
                        Security "OAuth 2.0"
                        Performance "Низкая задержка"
                        Scalability "Версионирование API"
                        Availability "99.99% времени доступности"
                    }
                }

                Group Filters {
                    caching = component RequestCashing "Кэширование GET-запросов" {
                        tags Addon Java
                        technology "ReactiveStringRedisTemplate, ServerHttpResponseDecorator"
                    }

                    jsonToGRPS = component JsonToGRPS "Преобразование JSON в GRPS" {
                        tags Tool future "Spring Cloud"
                        technology "Spring Cloud"
                    }

                    camundaStart = component CamundaStart "Запуск процессов" {
                        tags Pillar
                        technology "Camunda Client"
                        -> bpm "CreateProcessInstance" "gRPC" "super,async,command"
                    }
                    camundaMessage = component CamundaMessage "Обмен сообщениями" {
                        tags Pillar
                        technology "Camunda Client"
                        -> bpm "PublishMessage" "gRPC" "major,async,message"
                    }
                    camundaTask = component CamundaTask "Выполнение задач" {
                        tags Pillar
                        technology "Tasklist Client"
                        -> bpm "PATCH tasks/{taskId}/complete" "REST" "super,sync,request"
                    }
                Group PreFilters {

                    locator = component ServiceLocator "Определение вызываемого сервиса" {
                        tags Product Java
                        technology RewritePath
                    }
                    tokenRelay = component TokenRelay "Проверка JWT-токена" {
                        tags Tool "Spring Cloud"
                        technology "OAuth 2.0"
                    }
                    fileUpload = component FileUpload "Загрузка файлов" {
                        tags Product
                        technology "Minio Client, boundedElastic"
                        -> s3 "putObject" "blocking call" "aux,async,vague"
                    }
                }
                Group PostFilters {
                   enricher = component ResponseBodyEnricher "Добавление данных в ответ" {
                       tags Product Java
                       technology "REST Client"
                   }
                }
                }
                camundaListener = component CamundaListener "Получение событий" {
                    tags Product Worker
                    technology "Camunda Client"
                    //-> bpm "Long polling" "gRPC" "major,async,message"
                }
                Group SecurityConfig {
                    securityWebFilterChain = component SecurityWebFilterChain  {
                        tags Product Java
                        technology WebFluxSecurity
                        -> yPortal.apiGateway.tokenRelay "provides" "Bean" "check, sync,major"
                    }
                    requestResolver = component ServerOAuth2AuthorizationRequestResolver {
                        tags Tool
                        technology ServerOAuth2AuthorizationRequestResolver
                        -> yPortal.apiGateway.securityWebFilterChain "" "" "collect"
                    }

                    authorizedClientRepository = component AuthorizedClientRepository {
                        tags Tool
                        technology WebSessionServerOAuth2AuthorizedClientRepository
                        -> yPortal.apiGateway.securityWebFilterChain "" "" "collect"
                    }
                    logoutSuccessHandler = component LogoutSuccessHandler {
                        tags Tool
                        technology OidcClientInitiatedServerLogoutSuccessHandler
                        -> yPortal.apiGateway.securityWebFilterChain "" "" "collect"
                    }
                    logoutHandler = component LogoutHandler {
                        tags Tool
                        technology DelegatingServerLogoutHandler
                        -> yPortal.apiGateway.securityWebFilterChain "" "" "collect"
                    }
                }
                
            }
            redis = container Redis {
                technology "KV-storage"
                description "Хранение HTTP-сессий, кэшей"
                tags Redis db
            }
            yPortal.apiGateway.authorizedClientRepository -> redis "http-сессии" "" "major, check, sync"
            yPortal.apiGateway.caching -> redis "кэш" "" "aux, message, sync"

            Group Cloud {
                !include ../../fragments/cloud.pdsl
            }            
            apiGateway -> yPortal.consul "Регистрация, конфигурация" "DNS/HTTP" "aux, collect, safe"
            yPortal.apiGateway.locator -> yPortal.consul "поиск сервисов" "DNS/HTTP" "aux, collect, safe"

            Group Артефакты {
                library = container "Common Data Model" {
                    description "Библиотека общей модели данных системы"
                    tags Spring Addon abstract 
                    technology "Spring, REST, Zeebe Client"
                    jpa = component JPA {
                        description "Абстрактные бизнес-сущности и общие методы работы с ними" 
                        technology "Spring JPA"
                        tags Java
                    }
                    api = component API {
                        description "Единая модель REST-методов" 
                        technology "Spring WEB"
                        tags Java
                    }
                    worker = component Worker "Стандартные операции BPMN-процессов, обрабатываемые воркерами" "Zeebe, gRPC"  "Java"
                }

                starter = container Starter {
                    description "Шаблонизатор воркеров"
                    tags "Spring Boot" Addon abstract
                    technology "Spring Boot Starter"
                    config = component Configuration {
                        description  "Определяет базовую конфигурацию"
                        technology "ConfigurationProperties, AutoConfiguration" 
                        tags Java
                    }
                    enhancer = component  Enhancer {
                        description "Автоматически генерирует классы воркера"
                        technology "BeanFactoryPostProcessor, ByteBuddy"
                        tags Java
                        -> yPortal.library "Регистрирует классы в код воркера"
                    }
                }
            }

            Group Workers { 
                shipmentRfpWorker = container ShipmentRfp {
                    properties { 
                        wiki.document.id 6V4RDZuJnJ
                    } 
                    description "Заявка на перевозку"
                    !include ../../fragments/worker-dummy.pdsl
                }
                shipmentRfpDb = container ShipmentRfpDB {
                    technology "PostreSQL 16"
                    tags db Postgres
                    offer = component offer "" Table "table"
                    shipmentRfp = component shipment_rfp "" Table "table"
                    offer -> shipmentRfp "shipmentRfpId" "FK" "vague"
                }
                shipmentRfpWorker.srv -> shipmentRfpDb "" "JDBC" "safe, sync, major"

                quoteRequestWorker = container QuoteRequest {
                    description "Запрос КП"
                    !include ../../fragments/worker-dummy.pdsl

                }
                quoteRequestDb = container QuoteRequestDB {
                    technology "PostreSQL 16"
                    tags db Postgres
                    quoteRequest = component quote_request "" Table "table"
                    quote = component quote "" Table "table"
                    quoteRequest -> quote "qrId" "FK" "vague"
                }
                quoteRequestWorker.srv -> quoteRequestDb "" "JDBC" "safe, sync, major"



                metadataWorker = container MetaData {
                    description "Сервис мета-данных"
                    !include ../../fragments/worker-dummy.pdsl
                }
                metadataDb = container MetaDataDB {
                    technology "PostreSQL 16"
                    tags db Postgres
                }
                metadataWorker.srv -> metadataDb "" "JDBC" "safe, sync, major"

   
                

                catalogWorker = container Catalogs {
                    description "Справочники"
                    !include ../../fragments/worker-dummy.pdsl
                }
                catalogWorkerDb = container CatalogsDB {
                    technology "PostreSQL 16"
                    tags db Postgres
                }
                catalogWorker.srv -> catalogWorkerDb "" "JDBC" "safe, sync, major"
                

                listWorker = container Lists {
                    description "Списки"
                    !include ../../fragments/worker-dummy.pdsl
                }
                listWorkerDb = container ListsDB {
                    technology "PostreSQL 16"
                    tags db Postgres
                }
                listWorker.srv -> listWorkerDb "" "JDBC" "safe, sync, major"
                

            }
            !elements "element.tag==Worker" {
                -> yPortal.starter "зависимость" "Maven" "major,leap"
            }

            !elements "element.tag==Worker && element.type==Component" {
                -> bpm "Long polling" "gRPC" "super,async,command"
            }
            notifier = container Notifier {
                    description "Сервис уведомлений"
                    !include ../../fragments/service-dummy.pdsl
                    address = component addresser
                    templater = component templater
                    sender = component sender
                    task = component tasker
                    -> queue "Оповещения" "SSE" "async, message"
            }
            dereferencer = container Dereferencer {
                    description "Разрешение ссылок"
                    technology "Spring OpenFeign"
                    !include ../../fragments/service-dummy.pdsl
                    -> s3 "Файлы, медиа" "HTTP" "safe, sync"
                    openFeign = component OpenFeign "Декларативный REST-клиент"
            }
            !elements "element.tag==Worker && element.type==Container" {
                yPortal.dereferencer.openFeign -> this "GET" "HTTP REST" "major, request"
            }
            yPortal.apiGateway.enricher -> yPortal.dereferencer.rest "data" "JSON" "aux,sync,request"

            bpmn = container "Camunda Elements" {
                description "Системные BPMN-элементы (шаблоны) бизнес-процессов"
                tags  folder camunda abstract
                Group "Задания сервисов"{
                    inceptor = component Inceptor {                    
                        description "Сохранение созданного объекта"    
                        -> shipmentRfpWorker "" "" "async, super, command"                
                        -> quoteRequestWorker "" "" "async, super, command" 
                    }
                    transfer = component Transfer {
                        description "Обновление и изменение статуса"
                        -> shipmentRfpWorker "" "" "async, major, command"                
                        -> quoteRequestWorker "" "" "async, major, command" 
                    }
                    shift = component Shift {
                        description "Изменение статуса"
                        -> shipmentRfpWorker "" "" "async, command"                
                        -> quoteRequestWorker "" "" "async, command"

                    }
                    change = component Change {
                        description "Изменение данных объекта"
                        -> shipmentRfpWorker "" "" "async, major, command"                
                        -> quoteRequestWorker "" "" "async, major, command" 
                    }                
                }
                taskmaster = component TaskMaster {
                    description "Пользовательские задачи"
                    -> web "" "" "leap, super, vague"
                }
                Group "Коннекторы"{
                    requestor = component Requestor {
                        description "Выполнение запроса"   
                        -> ext "" """sync, request"    
                        -> queue "" "" "async, request"
                    }
                    catcher = component Catcher {
                        description "Прием сообщений"
                    }
                    queue -> catcher "" """async, request"

                    pitcher = component Pitcher {
                        description "Отправка сообщений"
                        -> ext "" """sync, message"    
                        -> queue "" "" "async, message"
                    }
                }
                Group "Обмен сигналами между процессами" {
                    transmitter = component Transmitter {
                        description "Отправка сигнала"
                    }
                    reciever = component Reciever {
                        description "Получение сигнала"
                    }
                    transmitter -> reciever "" "" "leap, major, message"
                }
                !elements "element.parent==bpmn" {
                    tags Tool camunda
                }
            }

            
            
            
        }

            development = deploymentEnvironment "Back-End Development" {
                deploymentNode "ПК разработчика" "" {
                    deploymentNode "Docker Engine" {
                        deploymentNode Воркеры "" "Docker Compose" {
                            containerInstance yPortal.shipmentRfpWorker
                            containerInstance yPortal.quoteRequestWorker
                            containerInstance yPortal.notifier
                            containerInstance yPortal.catalogWorker
                            containerInstance yPortal.shipmentRfpWorker
                        }
                        deploymentNode Cloud "Docker-контейнер" "Ubuntu 22.10" {
                            containerInstance yPortal.consul
                            containerInstance yPortal.apiGateway
                        }
                    }
                }
                deploymentNode "Dev-стенд" "" {
                    deploymentNode "Docker Engine" {
                        deploymentNode "Camunda" "" "Docker Compose" {
                            softwareSystemInstance bpm


                        }
                        deploymentNode "Front" "" "Docker Compose" {
                            containerInstance yPortal.web
                        }
                        infrastructureNode "NGinx"
                    }
                }
            }
        
            //yPortal.apiGateway -> bpm "Запуск процессов, выполнение задач" "gRPC" "sync, major, command, super"
            router -> yPortal.web "Управляет заявками" "HTTPS" "sync, major, request"
            dispatcher -> yPortal.web "Вносит предложения" "HTTPS" "sync, major, request"

            yPortal.web -> yPortal.apiGateway.api Запрос "HTTPS REST" " sync, request, super"
            yPortal.app -> yPortal.apiGateway.api Запрос "HTTPS REST" " sync, request"
            yPortal.web -> iam "Получение токена" "JWT" "check, sync, major"
            yPortal.app -> iam "Получение токена" "JWT" "check, sync, major"
            bpm -> yms "Camunda connector" "" "leap, vague, major"
    }

    views {
        systemContext yPortal yp-context "Системный контекст Портала Перевозчика" {
            include *
            include queue->
            exclude "element.tag==db"
            exclude "element.tag==future"
            exclude "element.tag==unreal"
        }

        container yPortal yp-structure "Структура Портала Перевозчика" {
            default
            include *
            include yms
            exclude relationship.tag==leap
            exclude relationship.tag==aux
            exclude element.tag==external
            exclude element.tag==infra
            exclude element.tag==db
            exclude element.tag==abstract
            exclude element.tag==doubt
            exclude element.tag==unreal
            exclude element.tag==future
        }


        container yPortal infra-structure "Портала Перевозчика целиком" {
            include element.parent==yPortal
            include element==bpm
            include element==iam
            include element==s3
            exclude *->*
            exclude element.tag==abstract
            exclude element.tag==doubt
        }


        deployment yPortal "Back-End Development" {
            include *
            exclude *->*
        }

        component yPortal.shipmentRfpWorker request-structure "Компоненты микросервиса 'Заявка на перевозку'" {
            title "Заявка на перевозку"
              include *
              include element.parent==yPortal.library 
              include element.parent==yPortal.starter
            exclude bpm->*
        }

        component yPortal.shipmentRfpWorker request-infra-structure "Компоненты инфраструктуры на примере микросервиса 'Заявка на перевозку'" {
            title "Spring Cloud"
            include *
            include "element.tag==infra && element.parent==yPortal"
            //exclude element==bpm
            exclude element.tag==abstract

        }

        component yPortal.catalogWorker api-to-db "Схема ветвления запросов на примере сервиса Catalogs" {
            title "Потоки данных"
            include element==yPortal.web
            include *            
            exclude element.tag==infra
            exclude element.tag==abstract
        }

        component yPortal.bpmn bpmnPallete "Взаимодействие разных типов элементов BPMN c компонентами Системы" {
            title "Системные блоки бизнес-процессов"
            include *
        }
        component yPortal.apiGateway apiGateway "Архитектура API Gateway" {
            title "API Gateway"
            include *
            exclude element.tag==abstract
            exclude element.tag==future
            exclude yPortal.dereferencer->yPortal.consul
        }
        dynamic yPortal derefOnGet "Разрешение ссылок" {
            title "Разрешение ссылок"
            yPortal.web -> yPortal.apiGateway "Получить сложный объект"
            yPortal.apiGateway -> yPortal.quoteRequestWorker "Запрос основного объекта"
            yPortal.quoteRequestWorker -> yPortal.apiGateway "rawData"
            yPortal.apiGateway -> yPortal.dereferencer "Разрешить ссылки"
            {
                {
                    yPortal.dereferencer -> yPortal.catalogWorker "Данные справочников"
                }
                {
                    yPortal.dereferencer -> s3
                }
            }
            yPortal.dereferencer -> yPortal.apiGateway "embeddedData"
            yPortal.apiGateway -> yPortal.web "Отправить сложный объект"
        }
    }
    !script ../../scripts/Tagger.groovy {
    }
}
