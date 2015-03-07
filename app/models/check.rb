class Check < ActiveRecord::Base
  belongs_to :resource

  after_create :check!

  before_save { self.data ||= {} }

  serialize :data, Hash

  def self.runner
    @runner ||= RSpec::Core::Runner.new(rspec_options)
  end

  def self.rspec_options
    @rspec_options ||= RSpec::Core::ConfigurationOptions.new([])
  end

  def runner err, out
    runner = Check.runner 
    runner.setup(err, out)
    runner
  end

  def groups
    [group]
  end

  def run
    err = StringIO.new
    out = StringIO.new

    result = runner(err, out).run_specs(groups)
    err.rewind
    out.rewind
    Struct.new(:status, :err, :out).new(result, err.read, out.read)
  end
  
  def out
    data[:out]
  end

  def check!
    results = run
    self.status = results.status
    self.data = {}
    self.data[:err] = results.err
    self.data[:out] = results.out
    save
  end

  def success?
    self.status == 0
  end
end
