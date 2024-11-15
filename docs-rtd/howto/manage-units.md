(manage-units)=
# How to manage units

> See also: {ref}`Unit <unit>`

```{important}

Units are also relevant when adding storage or scaling an application. See {ref}`How to manage storage <how-to-manage-storage>` and {ref}`How to manage applications <how-to-manage-applications>`.

```


## Control the number of units

To control the number of units of an application, in its resource definition specify a `units` attribute. For example, below we set it to 3.


```terraform
resource "juju_application" "this" {
  model = juju_model.development.name

  charm {
    name = "hello-kubecon"
  }

  units = 3    
}
```

> See more: [`juju_application` (resource)](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application#schema)



<br>

> <small>**Contributors:** @cderici, @hmlanigan, @skourta, @tmihoc </small>
