# ama-codeigniter-project Cookbook

This cookbook contains resource for configuring simple CodeIgniter 
project used in conjuction with rocketeer and composer, 
`codeigniter_project`. The cookbook takes highly opinionated approach, 
and will never be published on supermarket, though can be used and 
modified freely.

## Requirements

TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
### Platforms

- Ubuntu 14.04+

### Chef

- Chef 12.0 or later

### Cookbooks

- `apt` - ama-codeigniter-project needs toaster to brown your bagel.
- `yum` - ama-codeigniter-project needs toaster to brown your bagel.
- `php` - ama-codeigniter-project needs toaster to brown your bagel.

## Usage

### ama-codeigniter-project::default

TODO: Write usage instructions for each cookbook.

e.g.
Just include `ama-codeigniter-project` in your node's `run_list`:

```ruby
# name should be in `[a-z_]` format
codeigniter_project 'example' do
  domain staging.example.ci.company.com # required
  root_directory /var/www/super-project
  environment staging
  required_extensions [ :apc ]
  language 'english'
  log_threshold 1
  config {
    api_endpoint: api.service.io
  }
  manage_local_database true
  database_host 'localhost'
  database_user example_com
  database_password example_com
  database_schema example_com
  database_config {
    db_debug: true
  }
  environment_variable_prefix EXAMPLE_COM
  manage_environment_file true
  codeigniter_version 3
end
```

## Contributing

TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Authors

Authors: TODO: List authors

