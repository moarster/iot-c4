workspace  extends ../../iot-landscape.dsl {

    name "Интеграционная шина"
    description "Архитектурная модель шины Kafka"

    configuration {
        visibility public
        scope softwaresystem
    }

    model {

        !element kafka {
            tags "KafkaBusSystem"

            cluster = container "Кластер Kafka" "Распределенный кластер брокеров Kafka" "Apache Kafka" {
                tags "KafkaBrokerCluster"

                broker = component "Брокер Kafka" "Отдельный экземпляр сервера Kafka, отвечающий за хранение сообщений и обслуживание клиентских запросов" "Java/Scala" {
                    tags "KafkaBroker"
                }
                topics = component "Топики Kafka" "Логические каналы для категоризации сообщений" "Logical Abstraction" {
                    tags "KafkaTopic"
                }
                producerApi = component "Producer API" "Интерфейс, позволяющий приложениям публиковать записи в топик " "Kafka API" {
                    tags "KafkaProducerAPI"
                }
                consumerApi = component "Consumer API" "Интерфейс, позволяющий приложениям читать записи из одного или нескольких топиков" "Kafka API" {
                    tags "KafkaConsumerAPI"
                }

                producerApi -> topics "Публикует сообщения в"
                topics -> broker "Управляется и хранится на"
                broker -> topics "Обслуживает данные для"
                consumerApi -> topics "Читает сообщения из"
                topics -> consumerApi "Доставляет сообщения для"
            }
            zookeeper = container "Apache ZooKeeper" "Управляет и координирует брокеры Kafka, конфигурации топиков и выборы лидера для кластера"  {
                tags "CoordinationService"
            }
            schemaRegistry = container "Schema Registry" "Централизованное хранилище схем, обеспечивает совместимость и эволюцию данных" "Confluent Schema Registry" {
                tags "SchemaManagement"
            }
            connect = container "Kafka Connect" "Потоковая передачи данных между Apache Kafka и другими системами" "Apache Kafka Connect" {
                tags "IntegrationTool"
            }

            // Межконтейнерные связи внутри Шины Kafka
            cluster -> zookeeper "Регистрируется и полагается для координации и управления метаданными"
            schemaRegistry -> cluster "Хранит схемы во внутренних топиках"
            connect -> cluster "Читает и записывает топики"
            connect -> schemaRegistry "Извлекает и регистрирует схемы для преобразования и валидации"
        }


        iot -> kafka.cluster.producerApi "Отправляет сообщения через"
        kafka.cluster.consumerApi -> asupr "Доставляет сообщения для"


    }

    views {
        // Представление системного контекста
        systemContext kafka kafka-system "Системный контекст - Шина Kafka" {
            description "Высокоуровневое представление шины Kafka и ее взаимодействий с внешними системами."
            include *
        }

        // Представление контейнеров
        container kafka kafka-containers "Контейнеры - Шина Kafka" {
            description "Детализированное представление развертываемых компонентов (контейнеров) шины Kafka и их взаимодействий."
            include *

        }

        // Представление компонентов кластера Kafka
        component kafka.cluster kafka-cluster "Компоненты - Кластер Kafka" {
            description "Внутреннее представление кластера Kafka, показывающее его основные логические компоненты и их взаимодействия."
            include *
        }

        branding {
            logo ../../themes/basic/icons/dit-logo.png
        }
         styles {
            element "Element" {
                color #ffffff
            }
            element "KafkaBusSystem" {
                background #007bff
                color #ffffff
                shape Box
            }
            element "KafkaClientApp" {
                background #6c757d
                color #ffffff
                shape Box
            }
            element "KafkaBrokerCluster" {
                background #28a745
                color #ffffff
                shape Box
            }
            element "CoordinationService" {
                background #ffc107
                color #000000
                shape Box
            }
            element "SchemaManagement" {
                background #17a2b8
                color #ffffff
                shape Box
            }
            element "IntegrationTool" {
                background #dc3545
                color #ffffff
                shape Box
            }
            element "KafkaBroker" {
                background #20c997
                color #ffffff
                shape Box
            }
            element "KafkaTopic" {
                background #6f42c1
                color #ffffff
                shape Pipe
            }
            element "KafkaProducerAPI" {
                background #fd7e14
                color #ffffff
                shape Component
            }
            element "KafkaConsumerAPI" {
                background #6610f2
                color #ffffff
                shape Component
            }
            relationship "Uses" {
                color #000000
                style Dashed
            }
        }
    }
    !script ../../scripts/Tagger.groovy {
    }
}