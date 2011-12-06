module Sprockets
  module Mustache
    module Template
      class Processor < Tilt::Template
        include ActionView::Helpers::JavaScriptHelper

        def self.default_mime_type
          'application/javascript'
        end

        def self.default_namespace
          "this.MustacheTemplates"
        end

        def self.default_library
          "jQuery"
        end

        attr_reader :namespace, :library

        def prepare
          @namespace = self.class.default_namespace
          @library = self.class.default_library
        end

        def evaluate(scope, locals, &block)
          Generator.new(namespace, scope.logical_path, escape_javascript(data), library).generate


          js_function = <<-JS
(function($) {
  #{namespace} || (#{namespace} = {});

  #{namespace}[#{scope.logical_path.inspect}] = function(obj, partials) {
    return Mustache.to_html("#{escape_javascript template_string}", obj, partials);
  };
}(#{library}));
          JS
        end
      end
    end
  end

  register_engine '.mustache', ::Sprockets::Mustache::Template::Processor
end
