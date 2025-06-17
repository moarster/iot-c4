workspace extends ../../iot-landscape.dsl {

    name "IoT-платформа"
    description "Системная архитектура"

    configuration {
        visibility public
        scope softwaresystem
    }

    model {

        !element iot {

            opcua = container "OPC UA service" "Сбор данных с узлов учета" {
                technology "Spring Boot, Kotlin"
                tags Spring Product

                Group "OPC UA клиент" {
                    connector = component "Connection Manager" "Управляет соединением с OPC UA серверами" {
                        technology "Eclipse Milo"
                        tags Java Tool
                    }

                    stream = component "Data Stream" "Управляет потоками сбора данных" {
                        technology "Kotlin Flow"
                        tags Kotlin Pillar
                    }
                }

                Group "Обработка данных" {
                    conductor = component "Оркестратор данных" "Управляет потоками обработки данных" {
                        technology "Kotlin Coroutines"
                        tags Kotlin Product
                    }
                    transform = component "Трансформатор данных" "Преобразует данные" {
                        technology "Kotlin Coroutines"
                        tags Kotlin Product
                    }
                }
                Group "Сохранение данных" {
                    kafkaProducer = component "Kafka Producer" "Отправляет данные в Kafka" {
                        technology "Spring Kafka"
                        tags Spring Tool
                    }
                    mongoRepo = component "Reactive Repository" "Сохраняет данные в MongoDB" {
                        technology "Spring Mongo"
                        tags Spring Tool
                    }
                    postgresRepo = component "R2DBC Repository" "Сохраняет данные в PostgreSQL" {
                        technology "Spring R2DBC"
                        tags Spring Tool
                    }
                }
                stream -> connector "получает данные через" "" "основное,задача, асинхронное"
                conductor -> stream "забирает данные" "" "основное, асинхронное, задача"
                conductor -> transform "распараллеливает" "" "критичное, асинхронное, задача"
                transform -> mongoRepo "" "" "асинхронное, запрос"
                transform -> kafkaProducer "" "" "основное,асинхронное, сообщение"
                transform -> postgresRepo "" "" "асинхронное, запрос"
            }
            opcuaDb = container "База показаний приборов" "Хранилище временных рядов" {
                technology TimescaleDB
                tags db Postgres Tool
            }
            mdm = container "Master Data Management" "" {
                technology "Spring Boot"
                tags Spring Product
            }
            mdmDb = container "БД мастер-данных" "" {
                technology PostgreSQL
                tags db Postgres Tool
            }
            mongo = container "Документальная БД" "Хранилище сырых данных" {
                technology MongoDB
                tags db Mongo Tool
            }
            opcua.mongoRepo -> mongo "" "" "асинхронное, запрос"
            opcua.postgresRepo -> opcuaDb "" "" "асинхронное, запрос"
            mdm -> mdmDb "" "" "синхронное, запрос"
            mdm -> mongo "" "" "синхронное, запрос"
        }

        iot.opcua.connector -> uspd "подписка" "OPC UA" "агрегирующее, основное, запрос, асинхронное"
        iot.opcua.kafkaProducer -> kafka "публикует" "" "сообщение, асинхронное, критичное"
    }

    views {
        branding {
            logo ../../themes/basic/icons/iteco-logo.png
        }
        container iot iot-container "Обзор компонент IoT-платформы" {
            include *
        }
        component iot.opcua iot-opcua "Структура OPC UA сервиса" {
            include *
            exclude "element.type==Person"
            exclude "element.tag==External"
        }
    }
    !script ../../scripts/Tagger.groovy {
    }
}
