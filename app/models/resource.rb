class Resource < ActiveRecord::Base
  belongs_to :host
  has_many :checks

  after_create do
    Check::Parseable.create resource: self
  end

  def check!
    self.checks.each { |c| c.check! }
  end
end
