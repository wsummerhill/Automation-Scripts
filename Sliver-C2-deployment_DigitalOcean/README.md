## Sliver C2 deployment in DigitalOcean

Fill out the required variable inputs in `variables.tf` then run terraform with the following commands to deploy Sliver C2 to DigitalOcean:

```
terraform init
terraform plan
terraform apply
```

*Don't forget to open your UFW firewall rules later to allow access over whatever port/protocol you're using with a redirector.*
