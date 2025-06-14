import com.structurizr.Workspace
import com.structurizr.api.AdminApiClient
import com.structurizr.api.WorkspaceApiClient
import com.structurizr.model.Element
import com.structurizr.view.SystemLandscapeView
import groovy.transform.Field

@Field static final String STRUCTURIZR_ONPREMISES_URL = 'https://structurizr.moarse.ru'
@Field static final String ADMIN_API_KEY_PLAINTEXT = 'CozyPlace'

def workspace = workspace as Workspace

def workspaces = []// getWorkspaces([3, 4, 5])
workspaces.each { subWorkspace ->
    def softwareSystem = subWorkspace.model.softwareSystems.find { !it.containers.isEmpty() }
    if (softwareSystem) {
        findElementByKey(workspace, getElementKey(softwareSystem))
                .setUrl("{workspace:${subWorkspace.id}}/diagrams")
    }
}

SystemLandscapeView view = ((Workspace) workspace).views.createSystemLandscapeView("iot-et-all", "Ландшафт")
view.addAllElements()
view.removeElementsWithTag("unreal")

static List getWorkspaces(List workspaceIds) {
    def adminApiClient = new AdminApiClient("${STRUCTURIZR_ONPREMISES_URL}/api", '', ADMIN_API_KEY_PLAINTEXT )
    def workspaces = adminApiClient.workspaces.findAll { it.id in workspaceIds }
    return workspaces.collect {
        def workspaceApiClient = new WorkspaceApiClient("${STRUCTURIZR_ONPREMISES_URL}/api", it.apiKey, it.apiSecret)
        workspaceApiClient.workspaceArchiveLocation = null
        workspaceApiClient.getWorkspace(it.id)
    }
}

static findElementByKey(Workspace workspace, String key) {
    workspace.model.elements.find { getElementKey(it) == key }
}

static String getElementKey(Element element) {
    element.properties['structurizr.dsl.identifier']
}


