# garden-migrations-postgres

This repository intends to reproduce an issue with Database migrations documenting two different options that we tried.

# Option #1 (using two container modules for DB and migrations)

We basically have 2 modules.

1. Container module that deploys a `postgres` database.
2. Container module that intends to run configuration tasks for the `postgres` database module called `db-migrations`

## The problem

The workflow actually works quite nicely, however as the `container` module deploys the pod from a Deployment spec Kubernetes won't allow the task to finish and exit gracefully. Instead we see Kubernetes crashlooping the pod to try to stabilize it.

## Reproducing it

1. Clone this repository
2. `cd ./using-modules`
2. garden deploy --watch
4. You will see that the db-migrations container actually executes and runs everything successfully, however Kubernetes now will try to keep it running so you should be able to see CrashloopBackOff logs in your terminal.

````
Error deploying db-migrations: BackOff - Back-off restarting failed container

━━━ Events ━━━
Deployment db-migrations: ScalingReplicaSet - Scaled up replica set db-migrations-5cc7544bd4 to 1
Deployment db-migrations: ScalingReplicaSet - Scaled up replica set db-migrations-5b74c68557 to 1
Deployment db-migrations: ScalingReplicaSet - Scaled down replica set db-migrations-5cc7544bd4 to 0 from 1
Pod db-migrations-5b74c68557-n6lsg: Scheduled - Successfully assigned dbconfig-modules-default/db-migrations-5b74c68557-n6lsg to
lima-rancher-desktop
Pod db-migrations-5b74c68557-n6lsg: Pulled - Container image "postgres:11.7" already present on machine
Pod db-migrations-5b74c68557-n6lsg: Created - Created container db-migrations
Pod db-migrations-5b74c68557-n6lsg: Started - Started container db-migrations
Pod db-migrations-5b74c68557-n6lsg: BackOff - Back-off restarting failed container

━━━ Pod logs ━━━
<Showing last 30 lines per pod in this Deployment. Run the following command for complete logs>
$ kubectl -n dbconfig-modules-default --context=rancher-desktop logs deployment/db-migrations

****** db-migrations-5b74c68557-n6lsg ******
------ db-migrations ------Hello World, I am a script that connects to a Database and create a table
I am going to create a table called 'test' in the database 'votes'
Creating votes table
NOTICE:  relation "votes" already exists, skipping
CREATE TABLE
Creating votes2 table
NOTICE:  relation "votes2" already exists, skipping
CREATE TABLE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1 deploy action(s) failed!

````

## Workaround

1. If container module would allow us to use Jobs we could run these scripts everytime we do `garden deploy`, to show case how this should behave I have a tiny job.yaml file that you can use to see how a Kubernetes Job works. (The job finishes successfully after running the action)
(Feel free to `kubectl apply -f ./scripts/job.yaml)
2. We could suggest a path that users could follow when running custom scripts against the containers like creating a custom helm-chart that support init-containers or jobs?
