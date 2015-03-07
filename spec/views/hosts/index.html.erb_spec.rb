require 'rails_helper'

RSpec.describe "hosts/index", type: :view do
  before(:each) do
    assign(:hosts, [
      Host.create!(
        :name => "Name",
        :description => "MyText"
      ),
      Host.create!(
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of hosts" do
    render
    assert_select "h2", text: "Name", count: 2
  end
end
