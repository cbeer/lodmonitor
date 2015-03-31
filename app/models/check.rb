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

  def http_requests_by_test
    @http_requests ||= begin
      tests = stored_http_log.split(/#{"#" * 40}\n/)
      tests.each_with_object({}) do |t, hash|
        lines = t.split("\n")
        test = lines.shift
        next if test.blank?
        _ = lines.shift
        request = lines.join("\n")
        hash[test] = munge_http_request(request)
      end
    end  
  end

  def munge_http_request request
    requests = Hash[*request.split(/(^HTTP GET \([^)]+\).*)/).reject(&:blank?)]

    requests.each do |k,v|
      lines = v.split("\n")
      h = { request: {}, response: {} }
      h[:request][:headers] = lines.select { |x| x =~ /^HTTP request header/}.join("\n").gsub(/HTTP request header\s+/, "")
      h[:response][:status] = lines.select { |x| x =~ /^Response status/}.join("\n").gsub(/Response status\s+/, "")
      h[:response][:headers] = lines.select { |x| x =~ /^HTTP response header/}.join("\n").gsub(/HTTP response header\s+/, "")
      h[:response][:body] = lines.drop_while { |x| x !~ /^Response body/ }.join("\n").gsub(/Response body\s+/, "")
      requests[k] = h
    end
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
    HttpLogger.logger.formatter = proc do |severity, datetime, progname, msg|
      "#{msg}\n"
    end
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
