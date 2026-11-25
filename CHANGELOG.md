## [Unreleased]

- Add an unguessable random suffix to backup file names, so a PutObject-only S3 key cannot target (overwrite) existing backups
- Pass decoded PostgreSQL URL passwords to pg_dump through PGPASSWORD instead of command-line arguments, and prevent password leaks in invalid URL errors
- Allow Execute to forward environment variables and system options

## [0.2.1] - 2026-09-03

- Allow custom database backup filename prefixes

## [0.2.0] - 2026-04-10

- Add PostgresqlBackup

## [0.1.0] - 2026-04-08

- Initial release
