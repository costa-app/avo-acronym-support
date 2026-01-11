# frozen_string_literal: true

require_relative "support/version"
require_relative "support/railtie" if defined?(Rails::Railtie)

module Avo
  module Acronym
    # Automatically fixes Zeitwerk URL inflection conflicts in Avo.
    #
    # When Rails apps configure `inflect.acronym "URL"`, Zeitwerk expects
    # `URLHelpers` instead of `UrlHelpers`, causing autoload failures.
    # This gem automatically ensures both constant names exist when loaded.
    #
    # Just add to your Gemfile - no configuration needed:
    #   gem "avo-acronym-support"
    module Support
      class Error < StandardError; end

      module_function

      # Applies acronym support to a target module by ensuring both
      # inflected and non-inflected constant names exist.
      #
      # This solves Zeitwerk autoloading failures when host applications
      # configure inflections like `inflect.acronym "URL"`, which causes
      # the inflector to expect `URLHelpers` instead of `UrlHelpers`.
      #
      # @param target_module [Module] The module to apply acronym support to
      # @param file_path [String] Relative path to the file to require
      # @param constant_base [String] Base name of the constant (e.g., "Helpers")
      # @param acronym [String] The acronym to handle (e.g., "URL")
      def apply!(target_module, file_path, constant_base, acronym)
        return unless defined?(Rails)

        require file_path

        inflected_name = "#{acronym}#{constant_base}" # e.g., "URLHelpers"
        standard_name = "#{acronym.capitalize}#{constant_base}" # e.g., "UrlHelpers"

        # If only the standard form exists, create the acronym form
        if target_module.const_defined?(standard_name.to_sym, false) &&
           !target_module.const_defined?(inflected_name.to_sym, false)
          target_module.const_set(inflected_name, target_module.const_get(standard_name))
        # If only the acronym form exists, create the standard form
        elsif target_module.const_defined?(inflected_name.to_sym, false) &&
              !target_module.const_defined?(standard_name.to_sym, false)
          target_module.const_set(standard_name, target_module.const_get(inflected_name))
        end
      end

      # Ensures both constant forms exist within the target file itself
      # This should be called at the end of the file that defines the constant
      #
      # @param target_module [Module] The module containing the constants
      # @param constant_base [String] Base name of the constant
      # @param acronym [String] The acronym to handle
      def ensure_both_forms!(target_module, constant_base, acronym)
        inflected_name = "#{acronym}#{constant_base}"
        standard_name = "#{acronym.capitalize}#{constant_base}"

        if target_module.const_defined?(standard_name.to_sym, false) &&
           !target_module.const_defined?(inflected_name.to_sym, false)
          target_module.const_set(inflected_name, target_module.const_get(standard_name))
        elsif target_module.const_defined?(inflected_name.to_sym, false) &&
              !target_module.const_defined?(standard_name.to_sym, false)
          target_module.const_set(standard_name, target_module.const_get(inflected_name))
        end
      end
    end
  end
end
