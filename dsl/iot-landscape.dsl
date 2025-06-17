workspace "Системный контекст IoT-платформы" {

    !identifiers hierarchical
    !impliedRelationships true

    configuration {
        visibility public
        scope landscape
    }


    model {

        properties {
            structurizr.groupSeparator "/"
        }

        uspd = softwareSystem УСПД "Устройство сбора и передачи данных" {
            tags Pillar
        }
        asupr = softwareSystem АСУПР "Автоматизированная система учета потребления ресурсов" {
            tags Pillar Asupr

        }

        iot = softwareSystem "IoT-платформа" {
            tags Product Iteco
        }

        keycloak = softwareSystem Keycloak "Управление аутентификацией и авторизацией"  {

            tags Keycloak Tool
            perspectives {
                Security "OAuth 2.0 authentication"
                Performance "Масштабируемость для больших баз пользователей"
                Scalability "Горизонтальное масштабирование для высокой пропускной способности"
                Availability "Высокая доступность кластеризацией"
            }
        }


        kafka = softwareSystem "Apache Kafka" "Брокер сообщений" {
            tags Kafka queue bus Pillar
            perspectives {
                Security "SSL шифрование"
                Performance "Высокая пропускная способность"
                Scalability "Линейная масштабируемость"
                Availability "Отказоустойчивость  репликацией"
            }
        }
        iot -> uspd "подписка" "" "агрегирующее, основное, запрос, асинхронное"
        iot -> kafka "producer" "" "сообщение, асинхронное, критичное"
        asupr -> kafka "consumer" "" "get, асинхронное, сообщение, критичное"
        iot -> keycloak "токен" "HTTPS JWT" "логин, синхронное"


    }


    views {
        theme https://structurizr.moarse.ru/workspace/1/theme
        branding {
            logo themes/basic/icons/iteco-logo.png
        }
        properties {
            "structurizr.timezone" "Europe/Moscow"
            "structurizr.locale" "ru-RU"
        }

    }

    !script scripts/landscape.groovy
    !script scripts/Tagger.groovy

}
