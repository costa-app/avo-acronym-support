# frozen_string_literal: true

module Avo
  module Acronym
    module Support
      class Railtie < ::Rails::Railtie
        config.after_initialize do
          # Ensure both UrlHelpers and URLHelpers constants exist in Avo
          # This prevents Zeitwerk errors when host apps use inflect.acronym "URL"
          if defined?(::Avo)
            begin
              require "avo/helpers/url_helpers"
            rescue LoadError
              # avo gem may not be loaded or url_helpers doesn't exist
            end

            # Create the missing alias if needed
            if ::Avo.const_defined?(:UrlHelpers, false) && !::Avo.const_defined?(:URLHelpers, false)
              ::Avo.const_set(:URLHelpers, ::Avo::UrlHelpers)
            elsif ::Avo.const_defined?(:URLHelpers, false) && !::Avo.const_defined?(:UrlHelpers, false)
              ::Avo.const_set(:UrlHelpers, ::Avo::URLHelpers)
            end
          end
        end
      end
    end
  end
end
