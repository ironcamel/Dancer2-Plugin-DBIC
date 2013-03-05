# DESCRIPTION

This plugin makes it very easy to create Dancer2 applications that interface
with databases.
It automatically exports the keyword `schema` which returns a
DBIx::Class::Schema object.
You just need to configure your database connection information.
For performance, schema objects are cached in memory
and are lazy loaded the first time they are accessed.

# INSTALLATION

    cpan Dancer2::Plugin::DBIC

# DOCUMENTATION

See [Dancer2::Plugin::DBIC](https://metacpan.org/module/Dancer2::Plugin::DBIC).
Also, after installation, you can view the documentation via `man` or `perldoc`:

    man Dancer2::Plugin::DBIC
