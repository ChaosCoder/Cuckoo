extension Templates {
    static let noImplStub = """
{% for attribute in container.attributes %}
{{ attribute.text }}
{% endfor %}
{{container.accessibility}} class {{ container.name }}Stub{{ container.genericParameters }}: {% if container.isNSObjectProtocol %}NSObject, {% endif %}{{ container.name }}{% if container.isImplementation %}{{ container.genericArguments }}{% endif %} {
    {% for property in container.properties %}
    {{ property.unavailablePlatformsCheck }}
    {% if debug %}
    // {{property}}
    {% endif %}
    {% for attribute in property.attributes %}
    {{ attribute.text }}
    {% endfor %}
    private typealias {{ property.name }}$$CUCKOO_TYPE = {{property.type|genericSafe|removeClosureArgumentNames}}
    {{ property.accessibility }}{% if container.@type == "ClassDeclaration" %} override{% endif %} var {{ property.name }}: {{ property.type }} {
        get {
            return DefaultValueRegistry.defaultValue(for: {{ property.name }}$$CUCKOO_TYPE.self)
        }
        {% ifnot property.isReadOnly %}
        set { }
        {% endif %}
    }
    {% if property.hasUnavailablePlatforms %}
    #endif
    {% endif %}
    {% endfor %}

    {% for initializer in container.initializers %}
    {{ initializer.unavailablePlatformsCheck }}
    {{ initializer.accessibility }}{% if container.@type == "ClassDeclaration" %} override{% endif %}{% if initializer.@type == "ProtocolMethod" %} required{%endif%} init({{initializer.parameterSignature}}) {
        {% if container.@type == "ClassDeclaration" %}
        super.init({{initializer.call}})
        {% endif %}
    }
    {% if initializer.hasUnavailablePlatforms %}
    #endif
    {% endif %}
    {% endfor %}

    {% for method in container.methods %}
    {{ method.unavailablePlatformsCheck }}
    {% if debug %}
    // {{method}}
    {% endif %}
    {% for attribute in method.attributes %}
    {{ attribute.text }}
    {% endfor %}
    {{ method.accessibility }}{% if container.@type == "ClassDeclaration" and method.isOverriding %} override{% endif %} func {{ method.name|escapeReservedKeywords }}{{ method.genericParameters }}({{ method.parameterSignature }}) {{ method.returnSignature }} {{ method.whereClause }} {
        return DefaultValueRegistry.defaultValue(for: ({{method.returnType|genericSafe}}).self)
    }
    {% if method.hasUnavailablePlatforms %}
    #endif
    {% endif %}
    {% endfor %}
}
"""
}
