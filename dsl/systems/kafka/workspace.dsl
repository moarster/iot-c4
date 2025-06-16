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

            cluster = container "Кластер Kafka" "Распределенный кластер брокеров Kafka, отвечающий за хранение и обслуживание потоков сообщений." "Apache Kafka" {
                tags "KafkaBrokerCluster"

                broker = component "Брокер Kafka" "Отдельный экземпляр сервера Kafka, отвечающий за хранение сообщений и обслуживание клиентских запросов. Данные реплицируются между несколькими брокерами для отказоустойчивости." "Java/Scala" {
                    tags "KafkaBroker"
                }
                topics = component "Топики Kafka" "Логические каналы для категоризации сообщений. Каждый топик разделен на разделы (партиции), которые являются единицей параллелизма и распределены между брокерами." "Logical Abstraction" {
                    tags "KafkaTopic"
                }
                producerApi = component "Producer API" "Интерфейс, позволяющий приложениям публиковать записи в топики Kafka, обрабатывая логику сериализации и разделения на партиции." "Kafka API" {
                    tags "KafkaProducerAPI"
                }
                consumerApi = component "Consumer API" "Интерфейс, позволяющий приложениям читать записи из одного или нескольких топиков Kafka, управляя смещениями потребителей и логикой групп." "Kafka API" {
                    tags "KafkaConsumerAPI"
                }

                producerApi -> topics "Публикует сообщения в"
                topics -> broker "Управляется и хранится на"
                broker -> topics "Обслуживает данные для"
                consumerApi -> topics "Читает сообщения из"
                topics -> consumerApi "Доставляет сообщения для"
            }
            zookeeper = container "Apache ZooKeeper" "Управляет и координирует брокеры Kafka, конфигурации топиков и выборы лидера для кластера." "Apache ZooKeeper" {
                tags "CoordinationService"
            }
            schemaRegistry = container "Kafka Schema Registry" "Предоставляет централизованное хранилище для схем Avro, Protobuf и JSON, обеспечивая совместимость и эволюцию данных." "Confluent Schema Registry" {
                tags "SchemaManagement"
            }
            connect = container "Kafka Connect" "Фреймворк для надежной потоковой передачи данных между Apache Kafka и другими системами, запускающий коннекторы источника и приемника." "Apache Kafka Connect" {
                tags "IntegrationTool"
            }

            // Межконтейнерные связи внутри Шины Kafka
            cluster -> zookeeper "Регистрируется и полагается для координации и управления метаданными"
            schemaRegistry -> cluster "Хранит схемы во внутренних топиках Kafka и извлекает их для валидации"
            connect -> cluster "Читает из и записывает в топики Kafka для интеграции данных"
            connect -> schemaRegistry "Извлекает и регистрирует схемы для преобразования и валидации данных"
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
                line dashed
            }
        }
    }
    !script ../../scripts/Tagger.groovy {
    }
}