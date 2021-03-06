resource_name :codeigniter_project

property :id, String, name_property: true, required: true
property :domain, String, required: true
property :root_directory, String
property :environment, Symbol, default: :production
property :required_extensions, Array, default: []
property :language, String, default: 'english'
property :log_threshold, Integer, default: 1
property :config, Hash, default: {}
property :manage_local_database, [TrueClass, FalseClass], default: true
property :database_host, String, default: 'localhost'
property :database_port, Integer
property :database_user, String
property :database_password, String
property :database_schema, String
property :database_config, Hash, default: {}
property :environment_variable_prefix, String
property :manage_environment_file, [TrueClass, FalseClass], default: true
property :codeigniter_version, Integer, default: 3
property :file_owner, String
property :file_group, String

COOKBOOK_NAME = 'ama-codeigniter-project'

def compute_config()
  _config = AMA::CodeigniterProject::Configuration.new
  _config.id = id
  _config.domain = domain
  _config.root_directory = (root_directory or "/var/www/#{domain}")
  _config.document_root = "#{_config.root_directory}/current"
  _config.environment = environment
  _config.shared_files_directory = "#{_config.root_directory}/shared"
  _config.required_extensions = required_extensions
  _config.manage_environment_file = manage_environment_file
  _config.manage_local_database = manage_local_database
  _config.environment_variable_prefix = (environment_variable_prefix or _config.id.upcase.gsub(/[^A-Z_]+/, '_') + '_')
  _config.codeigniter_version = codeigniter_version

  _database_config = AMA::CodeigniterProject::DatabaseConfiguration.new
  _database_config.host = database_host
  _database_config.user = (database_user or "#{id}_#{environment}")
  # shameless stackoverflow ripoff
  # http://stackoverflow.com/a/88341/2908793
  _database_config.password = (database_password or (0...8).map { (65 + rand(26)).chr }.join)
  _database_config.schema = (database_schema or "#{id}_#{environment}")
  _database_config.extra_config = database_config
  _config.database_config = _database_config

  _application_config = AMA::CodeigniterProject::ApplicationConfiguration.new
  _application_config.base_url = 'http://' + domain + '/'
  _application_config.language = language if language
  _application_config.log_threshold = log_threshold if log_threshold
  _application_config.extra_config = config
  _config.application_config = _application_config
  _config
end

def run(action)
  _config = compute_config

  _config_directory = "#{_config.shared_files_directory}/application/config"
end

action :create do
  action = :create

  _config = compute_config

  _config_directory = "#{_config.shared_files_directory}/application/config"

  directory _config_directory do
    recursive true
  end

  template "#{_config_directory}/config.php" do
    source "config.php.erb"
    cookbook COOKBOOK_NAME
    variables _config.application_config.to_hash
    owner file_owner
    group file_group
    action action
  end

  template "#{_config_directory}/database.php" do
    source "codeigniter-#{_config.codeigniter_version}/database.php.erb"
    cookbook COOKBOOK_NAME
    variables _config.database_config.to_hash
    owner file_owner
    group file_group
    action action
  end

  template "#{_config_directory}/environment.php" do
    source 'environment.erb'
    cookbook COOKBOOK_NAME
    variables({
                  database_config: _config.database_config,
                  application_config: _config.database_config,
                  environemnt_variable_prefix: _config.environment_variable_prefix
              })
    owner file_owner
    group file_group
    action action
  end

  template "/etc/nginx/sites-available/#{_config.domain}" do
    source 'nginx-site.conf.erb'
    cookbook COOKBOOK_NAME
    variables({
        document_root: _config.document_root,
        domain: _config.domain
    })
  end

  link "/etc/nginx/sites-enabled/#{_config.domain}" do
    to "/etc/nginx/sites-available/#{_config.domain}"
  end

  if _config.manage_local_database
    mysql_connection = {
        host: _config.database_config.host,
        username: 'root',
        password: 'root'
    }

    mysql_database _config.database_config.schema do
      connection mysql_connection
    end

    mysql_database_user _config.database_config.user do
      connection mysql_connection
      password _config.database_config.password
      database_name _config.database_config.schema
    end
  end
end