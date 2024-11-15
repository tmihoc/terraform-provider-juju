(manage-charm-resources)=
# How to manage charm resources

> See also: [Resource (charm)](/t/11312)

When you deploy / update an application from a charm, that automatically deploys / updates any charm resources, using the defaults specified by the charm author. However, you can also specify resources manually (e.g., to try a resource released only to `edge` or to specify a non-Charmhub resource). This document shows you how.


## Find out the resources available for a charm

[tabs]
[tab version="juju"]

To find out what resources are available for a charm on Charmhub, run the `charm-resources` command followed by the name of the charm:

```text
juju charm-resources <charm>
```
---
[details=Expand to view a sample output for the 'postgresql-k8s' charm]
```text
$ juju charm-resources postgresql-k8s
Resource          Revision
postgresql-image  68
```
[/details]
---

The command has flags that allow you to specify a charm channel, an output format, an output file, etc. 

> See more: [`juju charm-resources`](/t/10099)

Alternatively, you can also consider a resource available somewhere else online (e.g., a link to an OCI image) or in your local filesystem.

[/tab]

[tab version="terraform juju"]

The `terraform juju` client does not support this. Please use the `juju` client.

[/tab]

[tab version="python libjuju"]
To find out what resources are available for a charm on Charmhub, on a connected Model object, select the `charmhub` object associated with the model, and use the `list_resources()` method, passing the name of the charm as an argument. For example:

```python
await model.charmhub.list_resources('postgresql-k8s')
```

> See more: [`charmhub (property)`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.charmhub), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)

[/tab]
[/tabs]

## Specify the resources to be deployed with a charm

[tabs]
[tab version="juju"]


How you specify a resource to deploy with a charm depends on whether you want to do this during deployment or, as an update, post-deployment.


- To specify a resource during deployment, run the `deploy` command with the `--resources` flag followed by a key-value pair consisting of the resource name and the resource:

```text
juju deploy <charm name> --resources <resource name>=<resource>
```

> See more: [`juju deploy`](/t/10074)

- To specify a  resource after deployment, run the `attach-resource` command followed by the name of the deployed charm (= [application](/t/5471)) and a key-value pair consisting of the resource name and the resource revision number of the local path to the resource file:

```text
juju attach-resource <charm name> <resource name>=<resource>
```

Regardless of the case, the resource name is always as defined by the charm author (see the Resources tab of the charm homepage on Charmhub or the `resources` map in the `metadata.yaml` file of the charm) and the resource is the resource revision number, a path to a local file, or a link to a public OCI image (only for OCI-image type resources).

----
[details=Expand to view an example where the resource is specified post-deployment by revision number]
```text
juju attach-resource  juju-qa-test foo-file=3
```
[/details]
----

- To update a resource's revision, run the `refresh` command with the `--resource` flag followed by a key=value pair denoting the name of the resource and its revision number or the local path to the resource file. 

> See more: [`juju deploy ... --resources`](/t/10074), [`juju attach-resource`](/t/10124), [`juju refresh ... --resources`](/t/10189)

[/tab]

[tab version="terraform juju"]

To specify the resource(s) to be deployed with your charm, in your Terraform plan, in the definition of the resource for the application specify a `resources` block with key-value pairs listing resource names and their revision number. For example:

```text
resource "juju_application" "application_one" {
  name = "my-application"
  model = juju_model.testmodel.name
  
  charm {
    name = "juju-qa-test"
    channel = "2.0/edge"
  }
  resources = {
    "foo-file" = 4
  }
}
```


[note type=information]
About `charm > revision` and `resources` and their counterparts in the `juju client`: 
- If you specify only `charm > revision`: This is equivalent to `juju deploy <charm> --revision` or `juju refresh <charm> --revision` -- that is, the resource revision is automatically the latest.
- If you specify only `resources`: This is equivalent to `juju attach-resource` -- that is, the resource revision is whatever you've specified.

**Note:** While `juju refresh <charm> --resource` allows you to update a resource even if no update is available for the charm, this is not possible with `terraform juju`.
[/note]

> See more: [`juju_application > resources`](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#resources)

[/tab]

[tab version="python libjuju"]
To specify a resource during deployment, on a connected Model object, use the `deploy` method, passing the resources as a parameter. For example:

```python
resources = {"file-res": "test.file"}
app = await model.deploy(charm_path, resources=resources)
```

To update a resource after deployment by uploading file from local disk, on an Application object, use the `attach_resource()` method, passing resource name, file name and the file object as parameters.

```python
with open(str(charm_path / 'test.file')) as f:
    app.attach_resource('file-res', 'test.file', f)
```


> See more: [`deploy()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.model.html#juju.model.Model.deploy), [`attach_resource()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.attach_resource), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)

[/tab]
[/tabs]


## View the resources deployed with a charm

[tabs]
[tab version="juju"]


To view the resources that have been deployed with a charm, run the `resources` command followed by the name of the corresponding application / ID of one of the application's units.

```text
juju resources <application name> / <unit ID>
```

> See more: [`juju resources`](/t/10218)

[/tab]

[tab version="terraform juju"]
The `terraform juju` client does not support this. Please use the `juju` client. 
[/tab]

[tab version="python libjuju"]
To view the resources that have been deployed with a charm, on an Application object, use the `get_resources()` method. For example:

```python
await my_app.get_resources()
```


> See more: [`get_resources()`](https://pythonlibjuju.readthedocs.io/en/latest/api/juju.application.html#juju.application.Application.get_resources), [Model (module)](https://pythonlibjuju.readthedocs.io/en/latest/narrative/model.html)
[/tab]
[/tabs]

<br>

> <small>**Contributors:** @cderici, @hmlanigan, @tmihoc </small>
