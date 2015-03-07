class Check < ActiveRecord::Base
  belongs_to :resource

  after_create :check!

  before_save { self.data ||= {} }

  serialize :data, Hash

  def self.default_classes
    @default_classes ||= [Check::Parseable]
  end

  def reporter_config
    @reporter_config ||= StubReporterConfig.new
  end

  class StubReporterConfig
    def start_time
      @start_time ||= Time.now
    end
    def seed; 0; end
    def seed_used?; false; end
    def profile_examples; []; end
    def profile_examples?; false; end
    def fail_fast?; false; end
  end

  def run
    reporter = RSpec::Core::Reporter.new reporter_config

    result = reporter.report(-1) do
      group.run(reporter)
    end

    Struct.new(:status, :failures).new(result, reporter.failed_examples)
  end
  
  def out
    data[:failures].join("\n")
  end

  def check!
    results = run
    self.status = results.status
    self.data = {}
    self.data[:failures] = results.failures.map { |x| x.full_description.gsub(/^#<[^>]+> /, "it ")}
    save
  end

  def success?
    !!self.status
  end

  protected
  def describe_resource &block
    RSpec::Core::ExampleGroup.__send__("describe", resource, &block)
  end
end
