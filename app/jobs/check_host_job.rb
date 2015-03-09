class CheckHostJob < ActiveJob::Base
  queue_as :default

  def perform host
    host.check!
  end
end