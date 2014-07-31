# Originator

A lightweight solution to managing MySQL migrations.

## Why should you care?

There are no dependencies for this beyond MySQL, so you can use this with any type of application.

Originator's CLI follows the same interface as Laravel's Artisan migration implementation, so there's a chance you already know how to use this.  For those of you who haven't used Laravel's Artisan CLI, you'll find it to be quite simple.

## Installation

Clone the repo, and you should be good to go.

## Usage

### Creating Migrations

You'll be able to create migrations with the `migrate:make` command.  This command takes one parameter, and that's the migration name.

This function will create two files; one named something like `migrations/migrate/1406769615_migrate_my_first_migration.sql` and another named something like `migrations/revert/1406769615_revert_my_first_migration.sql`.

In the migrate file, you should create your migration.  In the revert file it should do the opposite of the migrate file.  For example, if you create a table in the migrate file, you should drop the table in the revert file.

**Example Usage**: While inside the root directory of this repo run `./originator migrate:make my_first_migration` 

## License & Contributing
Originator is licensed under [MIT](license.md)
