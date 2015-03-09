class Host < ActiveRecord::Base
  has_many :resources

  accepts_nested_attributes_for :resources

  def check!
    resources.each(&:check!)
  end
end
