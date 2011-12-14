module Sprockets
  module Mustache
    module Template
      class Processor < Tilt::Template
        include ActionView::Helpers::JavaScriptHelper

        # Add class configurations
        class << self
          attr_accessor :default_namespace, :default_library
        end

        # Set defaults
        self.default_mime_type = 'application/javascript'

        self.default_namespace = "this.MustacheTemplates"

        self.default_library = "jQuery"

        attr_reader :namespace, :library

        def prepare
          @namespace = self.class.default_namespace
          @library = self.class.default_library
        end

        def evaluate(scope, locals, &block)
          js_function = <<-JS
(function($) {
  #{namespace} || (#{namespace} = {});

  #{namespace}[#{scope.logical_path.gsub(%r{\Atemplates/}, "").inspect}] = function(obj, partials) {
    return Mustache.to_html("#{escape_javascript data}", obj, partials);
  };
}(#{library}));
          JS
        end
      end
    end
  end

  register_engine '.mustache', ::Sprockets::Mustache::Template::Processor
end
