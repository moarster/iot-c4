#Basic styles
structurizr push -url https://structurizr.moarse.ru/api -id 1 -key ab317c3d-981b-43ff-acfe-14a1b67aa39d -secret 84bf680b-e3cb-406c-8ad6-128cb39fd577 -workspace dsl/themes/basic/styles.dsl -archive false -merge true

#Landscape
structurizr push -url https://structurizr.moarse.ru/api -id 2 -key e115c850-ba4a-4cc6-82a5-7a59357cb1c3 -secret e6b6ab71-a547-47bd-b613-f9b3de49143b -workspace dsl/iot-landscape.dsl -archive true -merge true

#IoT
structurizr push -url https://structurizr.moarse.ru/api -id 3 -key d2d29333-01af-4cf3-b15d-d4a769c29aa2 -secret e0a76a7c-a2e1-477a-a05f-2b2b4cf50082 -workspace dsl/systems/iot/workspace.dsl -archive true -merge true

#АСУПР
structurizr push -url https://structurizr.moarse.ru/api -id 4 -key 8916ba8c-8779-41e2-997c-d91fde19a44c -secret b2f3f71c-76b0-4d0a-9dd9-840aca40b2d4 -workspace dsl/systems/asupr/workspace.dsl -archive true -merge true

#Kafka
structurizr push -url https://structurizr.moarse.ru/api -id 5 -key bb9ebb7f-e7a9-4137-992a-edea4ec08254 -secret 2cb12469-d55d-44a9-b1f6-d8efa7de614c -workspace dsl/systems/kafka/workspace.dsl -archive true -merge true