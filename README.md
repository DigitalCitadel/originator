# originator

> **Note:** This project is in early development, and versioning is a little different. [Read this](http://markup.im/#q4_cRZ1Q) for more details.

originator is a framework independent CLI for managing databases.

# Why should you care?

There are no dependencies for this beyond MySQL (PostgreSQL is next on the list), so you can use this with any type of application.

This CLI is based heavily off of Laravel's Artisan, but adds a few much needed commands.

Let's let the features speak for themselves, so you should just check out that section.

# Installation

After cloning the repo, poke around in modules/migrate/config/.

You'll need to update the `database_config.bash` file, and you'll probably also want to check out the `migrate_config.bash` to tweak a few other small settings.

# Features + Usage

## Migrate Module

The migrate module makes it easy to manage your database migrations.

Here's a list of the available commands.

### migrate:make

You'll be able to create migrations with the `migrate:make` command.  This command takes one parameter, and that's the migration name.

This function will create two files; one named something like `migrations/migrate/1406769615_migrate_my_first_migration.sql` and another named something like `migrations/revert/1406769615_revert_my_first_migration.sql`.

In the migrate file, you should create your migration.  In the revert file it should do the opposite of the migrate file.  For example, if you create a table in the migrate file, you should drop the table in the revert file.

**Example Usage**: `./originator migrate:make my_first_migration`

### migrate

Migrate by itself will run all outstanding migrations.

**Example Usage**: `./originator migrate`

### migrate:update

Update will run through all of the migration files and ensure that they're being tracked.  This is useful when working in teams or right after running a `git pull` of a repo that has a copy of originator in it.

By default, this operation is ran before any command is executed.  You can disable this in the `migrate_config.bash` file, although it's likely you'll want to keep it enabled if you're working in a team.

**Example Usage**: `./originator migrate:update`

### migrate:rollback

Rollback will revert the last batch of migrations that were ran.  This is useful in combination with the `migrate` command when tweaking migrations.

**Example Usage**: `./originator migrate:rollback`

### migrate:reset

Reset will revert all migrations.

**Example Usage**: `./originator migrate:reset`

### migrate:refresh

Refresh will revert all migrations, and then run them again.

**Example Usage**: `./originator migrate:refresh`

### migrate:map

Map will display the current status of all of your migrations.  Migrations that are active will be bold, migrations that are not active will not.  This is useful so you don't have to dig into your database to see what migrations have been ran.

**Example Usage**: `./originator migrate:map`

**Example Output**:

**1407544303_create_foo_table**
**1407544485_create_bar_table**
1407544548_create_baz_table

### migrate:step

Step will allow you to either revert, or run any number of migrations.

This command in conjunction with `migrate:map` can prevent you from a lot of digging into the database.

**Example Usage**:

To migrate: `./originator migrate:step +2`
To revert:  `./originator migrate:step -3`

## Backup Module

The migrate module makes it easy to manage your database backups.

Here's a list of the available commands.

### backup

Running backup by itself will generate a backup of all of the tables in the database (except originators migrations table).

**Example Usage**: `./originator backup`

### backup:restore

Restore will restore a specific backup given a timestamp.

**Example Usage**: `./originator backup:restore 1411162872`

### backup:map

Map will display a list of available backups with their associated last migration.

**Example Usage**: `./originator backup:map`

**Example Output**:

```
1411161710 : 1411162330_create_bar_table
1411162872 : 1411162330_create_bar_table
```

# Multiple Environments

If you're using originator for multiple environments, you may run into a situation that you would like different config values for each of those environments.

Handling this is really simple with originator.

In the base directory, create a new directory with this command `mkdir config/$(hostname)`.  All of the files in this directory are autoloaded after all of the global config files are loaded.  This allows us to override config values to tweak them appropriately for this environment.  These folders are also in the `.gitignore` file, so you don't have to worry about cluttering your repo with environment specifics.

# The Future

As mentioned, originator is in early development.  There are plans to soon support PostgreSQL.

There will also soon be a database backup component that will make creating / restoring backups relatively effortless.

# License & Contributing
originator is licensed under [MIT](license.md)

