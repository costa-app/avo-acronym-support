# frozen_string_literal: true

puts "[avo-acronym-support] Loading Railtie from #{__FILE__}"

module Avo
  module Acronym
    module Support
      class Railtie < ::Rails::Railtie
        puts "[avo-acronym-support] Railtie class being defined"
        # Set up Zeitwerk callback to create alias immediately after URL helpers loads
        initializer "avo_acronym_support.setup_loader_hooks", before: :set_autoload_paths do
          puts "[avo-acronym-support] Initializer 'setup_loader_hooks' running (before: set_autoload_paths)"

          Rails.application.config.after_initialize do
            puts "[avo-acronym-support] Inside after_initialize callback"

            # Hook into all Zeitwerk loaders
            Rails.autoloaders.each_with_index do |loader, idx|
              puts "[avo-acronym-support] Setting up hooks on loader #{idx}: #{loader.class}"

              loader.on_load("Avo::UrlHelpers") do
                puts "[avo-acronym-support] on_load callback fired for Avo::UrlHelpers"
                unless ::Avo.const_defined?(:URLHelpers, false)
                  ::Avo.const_set(:URLHelpers, ::Avo::UrlHelpers)
                  puts "[avo-acronym-support] Created Avo::URLHelpers alias"
                else
                  puts "[avo-acronym-support] Avo::URLHelpers already exists"
                end
              end

              loader.on_load("Avo::URLHelpers") do
                puts "[avo-acronym-support] on_load callback fired for Avo::URLHelpers"
                unless ::Avo.const_defined?(:UrlHelpers, false)
                  ::Avo.const_set(:UrlHelpers, ::Avo::URLHelpers)
                  puts "[avo-acronym-support] Created Avo::UrlHelpers alias"
                else
                  puts "[avo-acronym-support] Avo::UrlHelpers already exists"
                end
              end
            end

            puts "[avo-acronym-support] Finished setting up loader hooks"
          end
        rescue StandardError => e
          puts "[avo-acronym-support] ERROR in setup_loader_hooks: #{e.class} - #{e.message}"
          puts e.backtrace.first(5).join("\n")
        end

        config.to_prepare do
          puts "[avo-acronym-support] to_prepare hook running"

          # Ensure both forms exist after files are loaded
          if defined?(::Avo)
            puts "[avo-acronym-support] Avo module is defined"
            puts "[avo-acronym-support]   UrlHelpers defined? #{::Avo.const_defined?(:UrlHelpers, false)}"
            puts "[avo-acronym-support]   URLHelpers defined? #{::Avo.const_defined?(:URLHelpers, false)}"

            if ::Avo.const_defined?(:UrlHelpers, false) && !::Avo.const_defined?(:URLHelpers, false)
              ::Avo.const_set(:URLHelpers, ::Avo::UrlHelpers)
              puts "[avo-acronym-support] Created Avo::URLHelpers -> UrlHelpers alias"
            elsif ::Avo.const_defined?(:URLHelpers, false) && !::Avo.const_defined?(:UrlHelpers, false)
              ::Avo.const_set(:UrlHelpers, ::Avo::URLHelpers)
              puts "[avo-acronym-support] Created Avo::UrlHelpers -> URLHelpers alias"
            else
              puts "[avo-acronym-support] Both constants already exist or neither exists"
            end
          else
            puts "[avo-acronym-support] Avo module not defined yet"
          end
        end
      end
    end
  end
end
