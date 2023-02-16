# garden-migrations-postgres

This repository intends to reproduce an issue with Database migrations documenting two different options that we tried.

# Option #2 (Using 1 container module with task)

We basically have 1 module that creates a postgres database and also a Task that executes an script (./scripts/init-db.sh) that will create our schemas/tables in the DB.

## The problem

The workflow actually works quite nicely, however as the `container` module deploys, the task is not being ran automatically.

As you might see in the task definition, we are setting a dependency in `db` service, but the task is not being run automatically.

## Reproducing it

1. Clone this repository
2. `cd ./using-tasks`
2. garden deploy --watch
4. DB will come up successfully, however task is not going to be run automatically
5. If we run the task everything works successfully no matter how many times we run the task it is idempotent.

````
┌🤘-🐧shankyjs@ 💻 pop-os - 🧱 using-tasks on 🌵  master •3 ⌀2 ✗
└🤘-> garden run task db-migrations
Running task db-migrations

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌍  Running in namespace default.dev
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✔ providers                 → Getting status... → Cached
   ℹ Run with --force-refresh to force a refresh of provider statuses.
✔ graph                     → Resolving 1 modules... → Done
✔ db-migrations             → Checking result... → Done
✔ postgres                  → Getting build status for v-b8ece8345c... → Already built
✔ db                        → Deploying version v-ba61a45ddd... → Already deployed
✔ db-migrations             → Running... → Done (took 1.7 sec)

Task output:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Hello World, I am a script that connects to a Database and create a table
I am going to create a table called 'test' in the database 'votes'
Creating votes table
CREATE TABLE
Creating votes2 table
CREATE TABLE

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
````

## Workaround

1. We need to run the task manually, seems like the dependencies are not allowing Garden to run automatically no matter if we setup the dependent services.