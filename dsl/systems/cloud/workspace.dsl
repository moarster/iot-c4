workspace extends ../../solvo-landscape.dsl {

    name "Компоненты облачной инфраструктуры"
    description ""

    !impliedRelationships true
    !identifiers hierarchical

    configuration {
        visibility public
        scope softwaresystem
    }

    model {

        !extend cloud {
            !include ../../fragments/cloud.pdsl  
            
        }
    }

    views {
        container cloud cloud-infra "Компоненты микросервисной инфраструктуры" {
            include *
        }
    }
}