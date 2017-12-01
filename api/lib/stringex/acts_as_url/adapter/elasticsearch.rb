# frozen_string_literal: true

module Stringex
  module ActsAsUrl
    module Adapter
      class Elasticsearch < Base
        def self.load
          ensure_loadable
          orm_class.send :include, Stringex::ActsAsUrl::ActsAsUrlInstanceMethods
          orm_class.send :extend, Stringex::ActsAsUrl::ActsAsUrlClassMethods
        end

        def self.orm_class
          ::ElasticsearchRecord
        end

        def read_attribute(instance, name)
          instance.instance_variable_get("@#{name}")
        end

        def write_attribute(instance, name, value)
          instance[name.to_sym] = value
        end

        def url_owners
          url_owners_class.refresh_index!
          url_owners_class.search(query: { wildcard: { settings.url_attribute => "#{base_url}*" } })
        end

        def primary_key
          'id'
        end

        def klass_non_sync_url_callback_method
          return :before_create if configuration.settings.callback_method == :before_save
          configuration.settings.callback_method
        end
      end
    end
  end
end
