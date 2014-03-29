module CLIUtils
  #  ======================================================
  #  PrefManager Class
  #
  #  Engine to derive preferences from a YAML file, deliver
  #  those to a user via a prompt, and collect the results.
  #  ======================================================
  class Prefs
    include PrettyIO
    #  ====================================================
    #  Attributes
    #  ====================================================
    attr_reader :answers, :config_path, :prompts

    #  ====================================================
    #  Methods
    #  ====================================================
    #  ----------------------------------------------------
    #  initialize method
    #
    #  Reads prompt data from YAML file.
    #  @return Void
    #  ----------------------------------------------------
    def initialize(data)
      @answers = []
      @prompts = {}

      case data
      when String
        if File.exists?(data)
          @config_path = data

          prompts = YAML::load_file(data)
          @prompts.deep_merge!(prompts).deep_symbolize_keys!
        else
          fail "Invalid configuration file: #{ yaml_path }"
        end
      when Array
        @config_path = nil

        prompts = {:prompts => data}
        @prompts.deep_merge!(prompts).deep_symbolize_keys!
      else
        fail 'Invalid configuration data'
      end
    end

    #  ----------------------------------------------------
    #  ask method
    #
    #  Runs through all of the prompt questions and collects
    #  answers from the user. Note that all questions w/o
    #  requirements are examined first; once those are
    #  complete, questions w/ requirements are examined.
    #  @return Void
    #  ----------------------------------------------------
    def ask
      @prompts[:prompts].reject { |p| p[:requirements] }.each do |p|
        _deliver_prompt(p)
      end

      @prompts[:prompts].find_all { |p| p[:requirements] }.each do |p|
        _deliver_prompt(p) if _requirements_fulfilled?(p)
      end
    end

    private

    #  ----------------------------------------------------
    #  _deliver_prompt method
    #
    #  Utility method for prompting the user to answer the
    #  question (taking into account any options).
    #  @param p The prompt
    #  @return Void
    #  ----------------------------------------------------
    def _deliver_prompt(p)
      if p[:options].nil?
        pref = prompt(p[:prompt], p[:default])
      else
        valid_option_chosen = false
        until valid_option_chosen
          pref = prompt(p[:prompt], p[:default])
          if p[:options].include?(pref)
            valid_option_chosen = true
          else
            error("Invalid option chosen: #{ pref }")
          end
        end
      end

      p[:answer] = pref
      @answers << p
    end

    #  ----------------------------------------------------
    #  _requirements_fulfilled? method
    #
    #  Utility method for determining whether a prompt's
    #  requirements have already been fulfilled.
    #  @param p The prompt
    #  @return Void
    #  ----------------------------------------------------
    def _requirements_fulfilled?(p)
      ret = true
      p[:requirements].each do |req|
        a = @answers.detect do |answer|
          answer[:key] == req[:key] &&
          answer[:answer] == req[:value]
        end
        ret = false if a.nil?
      end
      ret
    end
  end
end