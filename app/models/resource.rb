class Resource < ActiveRecord::Base
  belongs_to :host
  has_many :checks

  validates_presence_of :url

  after_create do
    Check::Parseable.create resource: self
  end

  def check!
    (Check.default_classes - self.checks.map(&:class)).each do |c|
      c.create(resource: self)
    end

    self.checks.each { |c| c.check! }
  end
end
