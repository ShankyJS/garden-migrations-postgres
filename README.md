# garden-migrations-postgres

This repository intends to reproduce an issue with Database migrations.

We basically have 2 modules.

1. Container module that deploys a `postgres` database.
2. Container module that intends to run configuration tasks for the `postgres` database module called `db-migrations`

# The problem

The workflow actually works quite nicely, however as the `container` module deploys the pod from a Deployment spec Kubernetes won't allow the task to finish and exit gracefully. Instead we see Kubernetes crashlooping the pod to try to stabilize it.

# Reproducing it

1. Clone this repository
2. garden deploy --watch
3. You will see that the db-migrations container actually executes and runs everything successfully, however Kubernetes now will try to keep it running so you should be able to see CrashloopBackOff logs in your terminal.

## Why tasks are not compatible with this workflow.

- We are looking for a way to run these scripts automatically after the DB is configured/up & running.
- Tasks in this case would require to be executed by using `garden run task` everytime we need them instead of running automatically after the DB is setup.

## Workaround

1. If container module would allow us to use Jobs we could run these scripts everytime we do `garden deploy`, to show case how this should behave I have a tiny job.yaml file that you can use to see how a Kubernetes Job works. (The job finishes successfully after running the action)
2. We could suggest a path that users could follow when running custom scripts against the containers like creating a custom helm-chart that support init-containers or jobs?
