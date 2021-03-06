require 'fileutils'
require 'yaml'

module CLIUtils
  #  Configuration Class
  #  Manages any configuration values and the flat YAML file
  #  into which they get stored.
  class Configurator
    # Stores the Configurator key that refers
    # to the current configuration version.
    # @return [Symbol]
    attr_accessor :current_version

    # Stores the Configurator key that refers
    # to the value at which the app last changed
    # config versions.
    # @return [Symbol]
    attr_accessor :last_version

    # Stores the path to the configuration file.
    # @return [String]
    attr_reader :config_path

    # Stores the configuration data itself.
    # @return [Hash]
    attr_reader :data

    # Stores the section that contains the version
    # keys.
    # @return [Symbol]
    attr_accessor :version_section

    # Initializes configuration from a flat file.
    # @param [String] path The filepath to the config YAML
    # @return [void]
    def initialize(path)
      _path = File.expand_path(path)
      @config_path = _path
      @data = {}

      if File.file?(_path)
        data = YAML.load_file(_path)
        @data.deep_merge!(data).deep_symbolize_keys!
      end
    end

    # Adds a new section to the config file (if it doesn't
    # already exist).
    # @param [String] section_name The section to add
    # @return [void]
    def add_section(section_name)
      if !@data.key?(section_name)
        @data[section_name] = {}
      else
        fail "Section already exists: #{ section_name }"
      end
    end

    # Convenience method to backup the configuration file
    # in the same directory that the original inhabits.
    # @return [String] The backed-up filepath
    def backup
      backup_path = ''
      unless @config_path.nil? || @config_path.empty?
        backup_path = "#{ @config_path }-#{ Time.now.to_i }"
        FileUtils.cp(@config_path, backup_path)
      end
      backup_path
    end

    # Compares the current version (if it exists) to
    # the last version that needed a configuration
    # change (if it exists). Assuming they exist and
    # that the current version is behind the "last-config"
    # version, execute a passed block.
    # @return [void]
    def compare_version
      c_version = Gem::Version.new(@current_version)
      l_version = Gem::Version.new(@last_version)

      if @current_version.nil? || c_version < l_version
        yield @current_version, @last_version
      end
    end

    # Removes a section to the config file (if it exists).
    # @param [String] section_name The section to remove
    # @return [void]
    def delete_section(section_name)
      if @data.key?(section_name)
        @data.delete(section_name)
      else
        fail "Cannot delete nonexistent section: #{ section_name }"
      end
    end

    # Ingests a Prefs class and adds its answers to the
    # configuration data.
    # @param [Prefs] prefs The Prefs class to examine
    # @return [void]
    def ingest_prefs(prefs)
      fail 'Invaid Prefs class' unless prefs.kind_of?(Prefs)
      prefs.prompts.each do |p|
        section_sym = p.config_section.to_sym
        add_section(section_sym) unless @data.key?(section_sym)
        @data[section_sym].merge!(p.config_key.to_sym => p.answer)
      end
    end

    # Hook that fires when a non-existent method is called.
    # Allows this module to return data from the config
    # Hash when given a method name that matches a key.
    # @param [<String, Symbol>] name The name of the method
    # @param [Array] args The arguments
    # @yield if a block is passed
    # @return [Hash] The hash with the method's name as key
    def method_missing(name, *args, &block)
      if name[-1,1] == '='
        @data[name[0..-2].to_sym] = args[0]
      else
        @data[name.to_sym] ||= {}
      end
    end

    # Clears the configuration data.
    # @return [void]
    def reset
      @data = {}
    end

    # Saves the configuration data to the previously
    # stored flat file.
    # @return [void]
    def save
      File.open(@config_path, 'w') do |f|
        f.write(@data.deep_stringify_keys.to_yaml)
      end
    end
  end
end
