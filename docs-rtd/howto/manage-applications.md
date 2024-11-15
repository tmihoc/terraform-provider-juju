(manage-applications)=
# How to manage applications

> See also: {ref}`Application <application>`

## Deploy an application

To deploy an application, find and deploy a charm that delivers it.

> See more: {ref}`How to deploy a charm / charm bundle <5476md>`


## Set the machine base for an application
> Only for machine clouds.

TBA


## Trust an application with a credential


Some applications may require access to the backing cloud in order to fulfil their purpose (e.g., storage-related tasks). In such cases, the remote credential associated with the current model would need to be shared with the application. When the Juju administrator allows this to occur the application is said to be *trusted*. 

To trust an application with a credential, in the `juju_application` resource definition, add a `trust` attribute and set it to `true`:

```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name     = "hello-kubecon"
  }

    trust = true
}
```

> See more: [`juju_application` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#schema)



## Configure an application
> See also: {ref}`Application configuration <5476md>`

To configure an application, in its resource definition add a config map with the key=value pairs you want (from the list of configs available for the charm). 

```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name = "hello-kubecon"
  }

  config = {
    redirect-map = "https://demo"      
   }    
}
```
> See more: [`juju_application` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#schema)



## Scale an application

> See also: [Scaling <scaling>`

### Scale an application vertically

To scale an application vertically, set constraints for the resources that the application's units will be deployed on.
 
> See more: {ref}`How to manage constraints for an application <5476md>`

### Scale an application horizontally

To scale an application horizontally, control the number of units.

> See more: {ref}`How to control the number of units <5476md>`


## Make an application highly available
> See also: {ref}`High availability <high-availability-ha>`

1. Find out if the charm delivering the application supports high availability natively or not. If the latter, find out what you need to do. This could mean integrating with a load balancing reverse proxy, configuring storage etc. 

> See more: [Charmhub > `<your charm of interest>`](https://charmhub.io/)

2. Scale up horizontally as usual.

> See more: {ref}`How to scale an application horizontally <5476md>`


## Integrate an application with another application

> See more: {ref}`How to manage relations <how-to-manage-relations>`


## Manage an application’s public availability over the network

**Expose.** To expose an application over a network, in its resource definition use an expose attribute:

```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name = "hello-kubecon"
  }

  expose = {}
}
```

This will expose all of the application's endpoints. To restrict exposure to just specific endpoints, spaces, or CIDRs, specify nested attributes.

<!--
```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name = "hello-kubecon"
  }

  expose = {
    endpoints = "..., ..."
    spaces = 
    cidrs = 
  }
}
```
-->


> See more: [`juju_application` > `expose` > nested schema](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#nested-schema-for-expose)



**Unexpose.** To unexpose an application, remove the `expose` attribute from its resource definition.



## Manage constraints for an application

> See also: [Constraint <constraint>`


To set constraints for an application, in its resource definition specify a `constraints` attribute followed by a quotes-enclosed, space-separated list of key=value pairs. For example:

```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name = "hello-kubecon"
  }

  constraints = "mem=6G cores=2"

}
```

> See more: [`juju_application` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#schema)



## Change space bindings for an application

> See also: [Binding <binding>`


To set space bindings for an application, in its resource definition specify an `endpoint_bindings` with a `space` key, to set a default for the entire application, and/or a `space` and an `endpoint` key, to set the space binding for a particular application endpoint. For example, below all the application's endpoints are bound to the `public` space except for the `juju-info` endpoint, which will be bound to the `private` space:

```text
resource "juju_application" "application_three" {
  model = resource.juju_model.testmodel.name
  charm {
    name = "juju-qa-test"
  }
  units = 0
  endpoint_bindings = [
    {
      "space" = "public"
    }
    {
      "space" = "private"
      "endpoint" = "juju-info"
    }
  ]
}
```

> See more: [`juju_application` > `endpoint_bindings`](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#endpoint_bindings)



## Upgrade an application

To upgrade an application, update its charm. 

> See more: [How to update a charm <5476md>`


## Remove an application
> See also: {ref}`Removing things <removing-things>`


To remove an application, remove its resource definition from your Terraform plan.

> See more: [`juju_application` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#schema)


> <small>Contributors: @achilleasa , @cderici, @james-garner, @hmlanigan , @nvinuesa , @pedroleaoc , @pmatulis , @stephanpampel , @timClicks , @tmihoc </small>
