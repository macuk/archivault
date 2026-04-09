# Archivault

ArchiVault is a Ruby gem for Rails applications that backs up files, logs, and databases
using paths and credentials provided by the app. It compresses and encrypts the data,
then uploads it securely to AWS S3.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add archivault
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install archivault
```

## Usage

### SQLite database backup

```ruby
database_path = "/home/user/app/storage/production.sqlite3"
gpg_passphrase = "password"
s3_setup = { 
  region: "region", 
  access_key_id: "access_key_id",  
  secret_access_key: "secret_access_key", 
  bucket: "bucket"
}

Archivault::SqliteBackup.new(database_path:, gpg_passphrase:, s3_setup:).call
```

### Logs backup

```ruby
log_path_or_paths = %w[
  /home/user/app/log/production.log.1
  /home/user/app/log/nginx_access.log.1
]
gpg_passphrase = "password"
s3_setup = { 
  region: "region", 
  access_key_id: "access_key_id",  
  secret_access_key: "secret_access_key", 
  bucket: "bucket"
}

Archivault::LogsBackup.new(log_path_or_paths:, gpg_passphrase:, s3_setup:).call
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/macuk/archivault. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/archivault/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Archivault project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/archivault/blob/main/CODE_OF_CONDUCT.md).
