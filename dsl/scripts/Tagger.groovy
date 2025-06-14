import com.structurizr.Workspace
import com.structurizr.model.SoftwareSystem
import com.structurizr.model.ModelItem

def workspace = workspace as Workspace
System.out.println(workspace.model.softwareSystems.size())
workspace.model.softwareSystems.each { SoftwareSystem  system ->
    addTags(system,"system")
    system.containers.each {
        addTags(it, "container")
        it.components.each { addTags(it, "component") }
    }
}


def addTags(ModelItem parent , String suffix) {
    def cats = ['External', 'Tool', 'Pillar', 'Product', 'Addon']
    def stype = parent.tagsAsSet.intersect(cats)
    stype.each{ type ->
        parent.addTags("${type} [${suffix}]")
    }
}