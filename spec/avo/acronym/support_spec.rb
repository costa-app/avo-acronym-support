# frozen_string_literal: true

RSpec.describe Avo::Acronym::Support do
  it "has a version number" do
    expect(Avo::Acronym::Support::VERSION).not_to be nil
  end

  describe ".ensure_both_forms!" do
    module TestNamespace; end

    after do
      TestNamespace.send(:remove_const, :UrlHelpers) if TestNamespace.const_defined?(:UrlHelpers, false)
      TestNamespace.send(:remove_const, :URLHelpers) if TestNamespace.const_defined?(:URLHelpers, false)
    end

    it "defines URLHelpers when only UrlHelpers exists" do
      TestNamespace.const_set(:UrlHelpers, Module.new)

      described_class.ensure_both_forms!(TestNamespace, "Helpers", "URL")

      expect(TestNamespace.const_defined?(:URLHelpers, false)).to be(true)
      expect(TestNamespace::URLHelpers).to eq(TestNamespace::UrlHelpers)
    end

    it "defines UrlHelpers when only URLHelpers exists" do
      TestNamespace.const_set(:URLHelpers, Module.new)

      described_class.ensure_both_forms!(TestNamespace, "Helpers", "URL")

      expect(TestNamespace.const_defined?(:UrlHelpers, false)).to be(true)
      expect(TestNamespace::UrlHelpers).to eq(TestNamespace::URLHelpers)
    end

    it "does nothing when both forms exist" do
      mod = Module.new
      TestNamespace.const_set(:UrlHelpers, mod)
      TestNamespace.const_set(:URLHelpers, mod)

      described_class.ensure_both_forms!(TestNamespace, "Helpers", "URL")

      expect(TestNamespace::UrlHelpers).to eq(mod)
      expect(TestNamespace::URLHelpers).to eq(mod)
    end
  end
end
