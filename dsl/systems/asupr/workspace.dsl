workspace  extends ../../iot-landscape.dsl {
    name "Архитектура АСУПР"
    description "Автоматизированная Система Управления Производством (АСУПР) для учета потребления ресурсов."

    configuration {
        visibility public
        scope softwareSystem
    }
    model {
        //Пользователи
        headDispatcher = person "Руководитель диспетчерской службы" {
            description "Мониторинг аварийных и проблемных ситуаций, принятие решений"
        }
        dispatcher = person "Диспетчер" {
            description "Мониторинг состояния узлов учета, формирование заявок на ремонт"
        }
        analytic = person "Аналитик" {
            description "Разработка сводных аналитических форм, поиск аномалий"
            tags Analyst
        }
        operator = person "Оператор коммерческого учета" {
            description "Расчет, учет и мониторинг потребления ресурсов, ведение реестров"
        }
        operatorRegister = person "Оператор коммерческого учета – регистратор" {
            description "Ведение статусов ВП, загрузка файлов с ВП"
        }
        commercialAccountingSpecialist = person "Специалист группы коммерческого учета" {
            description "Расчет, учет, мониторинг потребления, подписание ВП."
        }
        communicationEngineer = person "Инженер связи" {
            description "Мониторинг каналов связи, ведение реестра объектов."
        }
        propertyComplexSpecialist = person "Специалист имущественного комплекса" {
            description "Ведение реестра объектов эксплуатации и оборудования"
        }
        thermalTechnician = person "Теплотехник" {
            description "Регистрация приборов и точек учета, переопрос параметров"
        }
        mtoSpecialist = person "Специалист МТО" {
            description "Формирование и мониторинг заявок на материально-техническое обеспечение"
        }
        metrologist = person "Метролог" {
            description "Ведение реестра оборудования, метрология и сертификация"
        }
        metrologistExpert = person "Метролог-эксперт" {
            description "Расширенные полномочия по метрологии и сертификации"
        }
        operationalDispatcher = person "Оперативный диспетчер ТОиР" {
            description "Контроль и мониторинг заявок на ремонт, планирование работ"
        }
        assprOperationSpecialist = person "Специалист по эксплуатации НУ АСУПР" {
            description "Диагностика, мониторинг, конфигурирование УСПД"
        }
        repairman = person "Ремонтник" {
            description "Контроль и мониторинг исполнения заявок на ремонт."
        }
        repairController = person "Контролер ремонтных работ" {
            description "Контроль и мониторинг исполнения заявок на ремонт."
        }
        nsiAdministrator = person "Администратор НСИ" {
            tags Administrator
            description "Ведение нормативно-справочной информации."
        }
        systemAdministrator = person "Администратор системы" {
            description "Настройка пользователей, системных параметров, мониторинг."
            tags Security
        }
        consumer = person "Потребитель" {
            description "Учет и контроль потребления ресурсов через Личный кабинет."
        }
        oivDispatcher = person "Диспетчер ОИВ" {
            description "Мониторинг состояния узлов учета, диспетчеризация проблем."
        }
        biAnalyst = person "BI Аналитик" {
            description "Формирование и публикация аналитических отчетов."
            tags Analyst
        }
        rsoController = person "Контролер РСО" {
            description "Мониторинг состава УУ/ТУ, принятие/отклонение ВП"
        }
        accountingCoordinator = person "Координатор коммерческого учета" {
            description "Создание методов расчета потребления"
        }
        
        
        //Внешние системы
        egip = softwareSystem "ИАИС ЕГИП"  {
            description "Интегрированная автоматизированная информационная система «Единое геоинформационное пространство города Москвы»"
            tags External
        }
        sudir = softwareSystem "АИС СУДИР"  {
            description "Автоматизированная информационная система «Система управления доступом к информационным системам и ресурсам города Москвы»."
            tags External
        }
        ur = softwareSystem "АС УР"  {
            description "Единая система ведения и управления реестрами, регистрами, справочниками и классификаторами"
            tags External
        }
        situationCenter = softwareSystem "НУ АС Ситуационного центра ГКУ Соцэнерго"  {
            tags External
        }
        odopm = softwareSystem "ЕГАС ОДОПМ"  {
            description "Единая городская автоматизированная система обеспечения поддержки деятельности Открытого правительства города Москвы"
            tags External
        }
        eirc = softwareSystem "АСУ ЕИРЦ"  {
            description "Автоматизированная система управления «Информационное обеспечение деятельности ЕИРЦ»"
            tags External
        }
        gisRd = softwareSystem "ГИС РД"  {
            description "Государственная информационная система «Реестр домовладений»"
            tags External
        }
        dispatchCenters = softwareSystem "Диспетчерские центры"  {
            description "Внешние информационные системы диспетчерских служб"
            tags External
        }
        rsoSystems = softwareSystem "Информационные системы РСО"  {
            description "Информационные системы ресурсоснабжающих организаций"
            tags External
        }
        edoSystems = softwareSystem "Системы ЭДО" {
            description "Системы электронного документооборота"
            tags External
        }
        gisZhkh = softwareSystem "ГИС ЖКХ"  {
            description "Государственная информационная система жилищно-коммунального хозяйства"
            tags External
        }
        zabbix = softwareSystem Zabbix  {
            description "Система мониторинга инфраструктуры и приложений"
            tags External
        }

        //АСУПР
        !element asupr {
            balancers = container Балансировщики "Распределение входящих HTTP/HTTPS сессий"  {
                technology "Apache, Haproxy"
                tags Haproxy Tool

                component "Load Balancer 1 (ASUPR-LB1-WEB-P)" "Балансировщик нагрузки" "Haproxy"
                component "Load Balancer 2 (ASUPR-LB2-WEB-P)" "Балансировщик нагрузки" "Haproxy"
            }

            web = container WEB-интерфейс {
                tags browser Pillar
            }

            app = container "Кластер серверов приложений" "Хостинг основной логики АСУПР" {
                technology "Oracle WebLogic Server 12c"
                tags Product Oracle

                sbvu = component СБВУ "Подсистема сбора данных верхнего уровня" {
                    technology Python
                    tags Python Product doubt
                }
                dmk = component ДМК "Подсистема дистанционного мониторинга и конфигурирования" {
                    tags Python Product
                }
                unu = component УНУ "Подсистема управления нижним уровнем" {
                    technology Python
                    tags Python Product
                }
                pku = component ПКУ "Подсистема коммерческого учета" {
                    technology Python
                    tags Python Product
                }
                toir = component ТОиР "Подсистема технического обслуживания и ремонта"  {
                    technology Python
                    tags Python Product
                }
                disp = component ДИСП "Подсистема диспетчеризации" {
                    technology Python
                    tags Python Product
                }
                nsi = component ПНСИ "Подсистема ведения НСИ"  {
                    technology Python
                    tags Python Product
                }
                iu = component ИУ "Подсистема имущественного учета" {
                    technology Python
                    tags Python Product
                }
                pmto = component ПМТО "Подсистема материально-технического обеспечения" {
                    technology Python
                    tags Python Product
                }
                bi = component ОАС "Отчетно-аналитическая подсистема" {
                    technology Python
                    tags Python Pillar
                }
                okd = component ОКД "Подсистема оценки качества данных" {
                    technology Python
                    tags Python Pillar
                }
                rd = component РД "Подсистема расчетов и досчетов" {
                    technology Python
                    tags Python Product
                }
                time = component ОЕВ "Подсистема обеспечения единого времени" {
                    technology Python
                    tags Python Addon
                }
                data = component ХД "Подсистема хранения и обработки данных" {
                    tags Pillar
                }
                integrator = component ИВ "Подсистема информационного взаимодействия" {
                    technology Python
                    tags Python Pillar
                }
                auth = component ИБ "Подсистема информационной безопасности" {
                    tags Python Pillar
                }
                adm = component АДМ "Подсистема администрирования" {
                    technology WebLogic
                    tags Oracle Pillar
                }
                monitor = component МН "Подсистема мониторинга" {
                    tags Addon
                }


                sbvu -> data "хранение" "" "основное"
                sbvu -> dmk "тех. данные" "" "основное"
                dmk -> unu "управление" "" "основное, задача"
                pku -> data "хранение" "" "основное"
                rd -> data "хранение" "" "основное"
                okd -> rd "алгоритмы" "" "основное"
            }
            operDb = container "Operational Database" "База данных для оперативных данных"  {
                technology "Oracle Database Enterprise Edition 12c"
                tags db Oracle
            }
            bufferDb = container "Buffer Database" "Буферная база данных СБВУ" {
                technology MySQL
                tags db Mysql
            }
            archiveDb = container "Archive Database" "Архивная база данных СБВУ" {
                technology MongoDB
                tags db Mongo
            }
            fileDb = container "File Storage" "Хранилище файлов (например, ВП, ЭП)" {
                technology PostreSQL
                tags db Postgres
            }

            proxy = container "Proxy Servers" "Серверы-посредники для взаимодействия с УСПД"  {
                technology "Python, lighttpd, nginx"
                tags Nginx Addon

                uspd = component "Модуль взаимодействия с УСПД (ASSDSSD-BAL-WS)" "Обрабатывает входящие соединения от УСПД" {
                    technology Python
                    tags Python Pillar doubt
                }
                component "WEB-сервис отправки данных на ВУ (ASSDSSD-WS-AP11)" "Отправляет данные на верхний уровень." "Web Service"
                component "Модуль взаимодействия между СБВУ и ВУ (ASSDSSD-WS-API2)" "Обеспечивает передачу данных между СБВУ и ВУ." "Web Service"
                component "Технологический прокси сервис (ASUPR-WS-TECH-P)" "Проксирование технологического доступа." "HAP"
            }

            bi = container "BI System" "Система бизнес-аналитики для формирования отчетов"  {
                technology "Oracle Business Intelligence"
                tags Oracle Tool
            }

            android = container "АРМ Ремонтник" "Мобильное приложение для ремонтников" {
                technology Android
                tags mobile Android Pillar
            }

            balancers -> app "балансирует трафик" "HTTP/HTTPS" "составное, синхронное, основное"
            app.data -> operDb "" "JDBC/ODBC" "критичное, синхронное"
            app.data -> bufferDb "" "JDBC/ODBC" "основное, синхронное"
            app.data -> archiveDb "" "JDBC/ODBC" "вспомогательное, синхронное"
            app.data -> fileDb "" "JDBC/ODBC" "синхронное"
            app.bi -> bi "запрашивает отчеты" "SOAP/REST" "синхронное, get"
            app -> proxy "" "HTTP/HTTPS" "задача, критичное"

            operDb -> bufferDb "синхронизация" "" "вспомогательное, асинхронное"
            bufferDb -> archiveDb "архивация" "" "вспомогательное, асинхронное"

            web -> balancers "" "HTTP/HTTPS" "запрос, синхронное, основное"
            android -> balancers "" "HTTP/HTTPS" "запрос, синхронное, основное"
        }

        headDispatcher -> asupr "управление производством" "" "косвенное"
        dispatcher -> asupr "мониторинг и формирование заявок" "" "косвенное"
        analytic -> asupr.app.bi "анализ данных и отчетность"
        operator -> asupr "учет потребления" "" "косвенное"
        operatorRegister -> asupr "работа с ВП" "" "косвенное"
        commercialAccountingSpecialist -> asupr "управление коммерческим учетом" "" "косвенное"
        communicationEngineer -> asupr "мониторинг связи" "" "косвенное"
        propertyComplexSpecialist -> asupr "ведение реестров" "" "косвенное"
        thermalTechnician -> asupr "регистрация приборов" "" "косвенное"
        mtoSpecialist -> asupr "управление МТО" "" "косвенное"
        metrologist -> asupr "метрология и сертификация" "" "косвенное"
        operationalDispatcher -> asupr.app.toir "управление ремонтами" "" "косвенное"
        assprOperationSpecialist -> asupr "диагностика и конфигурирование НУ" "" "косвенное"
        repairman -> asupr.android "выполнение работ"
        repairController -> asupr.app.toir "контроль ремонтов" "" "косвенное"
        nsiAdministrator -> asupr.app.nsi "управление НСИ" "" "косвенное"
        systemAdministrator -> asupr.app.adm "администрирование" "" "косвенное"
        consumer -> asupr.web "Личный кабинет"
        oivDispatcher -> asupr "мониторинг и диспетчеризация" "" "косвенное"
        biAnalyst -> asupr.bi "аналитика"
        rsoController -> asupr "контроль ВП" "" "косвенное"
        accountingCoordinator -> asupr "управление расчетами" "" "косвенное"

        asupr.app.integrator -> kafka "публикует и потребляет сообщения" "" "асинхронное, основное, сообщение"
        asupr.app.sbvu -> kafka "необработанные данные УСПД" "" "асинхронное, основное, сообщение"
        asupr.app.dmk -> kafka "диагностика УСПД"  "" "асинхронное, основное, сообщение"
        asupr.app.pku -> kafka "комм. учет"  "" "асинхронное, основное, сообщение"
        asupr.app.okd -> kafka "оценка качества"  "" "асинхронное, основное, сообщение"


        asupr.app.monitor -> zabbix "метрики и события" "Zabbix Agent" "асинхронное, вспомогательное, сообщение"

        asupr.proxy.uspd -> uspd "данные и команды" "OPC UA, TCP/IP" "синхронное, запрос"

        asupr.app.integrator -> egip "ГИС-данные" "HTTP/HTTPS (JSON/XML)" "синхронное, основное, запрос"
        asupr.app.integrator -> sudir "пользователи и роли" "SOAP (XML)" "синхронное, основное, логин"
        asupr.app.integrator -> ur "справочники" "SOAP (XML)" "синхронное, вспомогательное, запрос"
        asupr.app.integrator -> eirc "оборудование и потребление" "SOAP (XML)" "синхронное, основное, запрос"
        asupr.app.integrator -> odopm "организации, отключения, ФИАС" "SOAP (XML)" "синхронное, основное, запрос"
        asupr.app.integrator -> gisRd "управляющие организации" "SOAP (XML)" "синхронное, основное, запрос"
        asupr.app.integrator -> dispatchCenters "" "SOAP (JSON)" "агрегирующее, критичное, запрос"
        asupr.app.integrator -> rsoSystems "потребление и узлы учета" "SOAP (XML)" "агрегирующее, синхронное, основное, запрос"
        asupr.app.integrator -> edoSystems "документы" "SOAP/HTTP/IBM MQ (XML/PDF/DOCX/JPEG)" "агрегирующее, основное, составное"
        asupr.app.integrator -> gisZhkh "ПУ и справочные данные" "SOAP (XML)" "синхронное, основное, запрос"
        asupr.app.sbvu -> situationCenter  "измерения и события" "OPC UA (Бинарный)" "асинхронное, основное, сообщение"
    }

    views {
        branding {
            logo ../../themes/basic/icons/asupr-logo.png
        }

        systemContext asupr asupr-context "Системный контекст АСУПР" {
            include *
            exclude "element.type==Person"
        }
        container asupr asupr-container "Обзор компонент АСУПР" {
            include *
            exclude "element.type==Person"
            exclude "element.tag==External"
        }
        container asupr asupr-users "Обзор пользователей АСУПР" {
            include *
            exclude "element.tag==External"
            exclude "element.type==SoftwareSystem"
            exclude "element.tag==db"
        }
        component asupr.app asupr-app "Обзор подсистем АСУПР" {
            include *
            exclude "element.type==Person"
            exclude "element.tag==External"
        }
        component asupr.app asupr-integration "Интеграции АСУПР" {
            include *
            exclude "element.type==Person"
            exclude "element.tag==db"
        }
    }
    !script ../../scripts/Tagger.groovy {
    }
}
