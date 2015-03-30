require 'http_logger'

class Check < ActiveRecord::Base
  belongs_to :resource

  after_create :check!

  before_save { self.data ||= {} }

  serialize :data, Hash

  def self.default_classes
    @default_classes ||= [Check::Parseable, Check::Cacheable, Check::ContentNegotiable]
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

    Struct.new(:status, :failures, :successes).new(result, reporter.failed_examples, reporter.examples.select { |x| x.metadata[:execution_result].status == :passed })
  end
  
  def failures
    data[:failures]
  end

  def successes
    data[:successes]
  end

  def stored_http_log
    data[:http_log]
  end

  def check!
    results = run
    self.status = results.status
    self.data = {}

    self.data[:failures] = results.failures.map do |x| 
      {
        description: x.full_description.gsub(/^#<[^>]+> /, "it "),
        exception: x.exception.to_s,
      }
    end
    
    self.data[:successes] = results.successes.map do |x| 
      {
        description: x.full_description.gsub(/^#<[^>]+> /, "it "),
      }
    end

    self.data[:http_log] = self.http_log.string
    save
  end

  def success?
    !data[:failures].present?
  end

  def http_log
    @http_log ||= StringIO.new
  end

  protected
  def describe_resource &block    
    HttpLogger.logger = Logger.new(http_log)
    HttpLogger.log_headers = true
    HttpLogger.colorize = false

    RSpec::Core::ExampleGroup.__send__("describe", resource) do
      before(:each) do |example|
        HttpLogger.logger.warn("#" * 40)
        HttpLogger.logger.warn(example.description)
        HttpLogger.logger.warn("-" * 40)
      end

      instance_eval(&block)
    end
  end
end
