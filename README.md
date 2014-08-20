# originator

> **Note:** This project is in early development, and versioning is a little different. [Read this](http://markup.im/#q4_cRZ1Q) for more details.

originator is a framework independent CLI for managing databases.

## Why should you care?

There are no dependencies for this beyond MySQL (PostgreSQL is next on the list), so you can use this with any type of application.

I'll let the features speak for themselves, so you should just check out that section.

## Installation

Clone the repo, and you should be good to go.

## Features + Usage

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

```
**1407544303_create_foo_table**
**1407544485_create_bar_table**
1407544548_create_baz_table
```

### migrate:step

Step will allow you to either revert, or run any number of migrations.

This command in conjunction with `migrate:map` can prevent you from a lot of digging into the database.

**Example Usage**: 

To migrate: `./originator migrate:step +2`
To revert:  `./originator migrate:step -3`

## The Future

As mentioned, originator is in early development.  There are plans to soon support PostgreSQL.

There will also soon be a database backup component that will make creating / restoring backups relatively effortless.

## License & Contributing
originator is licensed under [MIT](license.md)

