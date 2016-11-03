module AMA
  module CodeigniterProject

    class ApplicationConfiguration

      attr_accessor :base_url
      attr_accessor :language
      attr_accessor :log_threshold
      attr_accessor :log_path
      attr_accessor :extra_config

      def to_hash
        {
            base_url: base_url,
            language: language,
            log_threshold: log_threshold,
            extra_config: extra_config
        }
      end

      def to_flatten_hash
        flatten_hash = (extra_config or {}).clone
        to_hash.each_pair do |key, value|
          unless key == :extra_config
            flatten_hash[key] = value
          end
        end
        flatten_hash
      end
    end

    class DatabaseConfiguration
      attr_accessor :host
      attr_accessor :schema
      attr_accessor :user
      attr_accessor :password
      attr_accessor :extra_config

      def to_hash
        {
            host: host,
            schema: schema,
            user: user,
            password: password,
            extra_config: extra_config
        }
      end

      def to_flatten_hash
        flatten_hash = (extra_config or {}).clone
        to_hash.each_pair do |key, value|
          unless key == :extra_config
            flatten_hash[key] = value
          end
        end
        flatten_hash
      end
    end

    class Configuration

      attr_accessor :id
      attr_accessor :domain
      attr_accessor :root_directory
      attr_accessor :document_root
      attr_accessor :shared_files_directory
      attr_accessor :environment
      attr_accessor :application_config
      attr_accessor :database_config
      attr_accessor :required_extensions
      attr_accessor :manage_environment_file
      attr_accessor :manage_local_database
      attr_accessor :environment_variable_prefix
      attr_accessor :codeigniter_version

    end
  end
end