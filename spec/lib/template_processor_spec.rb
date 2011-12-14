require 'spec_helper'

describe Sprockets::Mustache::Template::Processor do

  let :scope do
    stub :logical_path => "templates/javascripts/backbone/templates/mustache/entryList"
  end

  let :processor do

    namespace = "my.Namespace"
    library = "Zepto"
    template_string = <<-HTML
<table class="ledger">
  <thead>
    <tr>
      <th class="date">Date</td>
      <th class="name">Name</td>
      <th class="category">Category</td>
      <th class="amount">Amount ($)</td>
    </tr>
  </thead>
  {{{rows}}}
</table>
    HTML

    described_class.default_namespace = namespace
    described_class.default_library = library

    described_class.new do
      template_string
    end
  end

  describe "#evaluate" do
    before do
      @js = processor.evaluate scope, {}
    end

    it "makes the named JS function as a string" do
      @js.should be_present
    end

    it "assigns the correct namespace" do
      @js.should match(/my\.Namespace\["javascripts\/backbone\/templates\/mustache\/entryList"\] =/)
    end

    it "assigns the correct library" do
      @js.should match(/\}\(Zepto\)/)
    end

    it "puts the template in the mustache object" do
      @js.should match(/<table class=\\"ledger\\">/)
    end

    it "has a render function that calls Mustache.to_html" do
      @js.should match(/Mustache\.to_html/)
    end

    it "passes partials to to_html" do
      @js.should match(/to_html.+, partials/)
    end

  end
end
