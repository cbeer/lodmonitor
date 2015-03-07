require 'rails_helper'

RSpec.describe "hosts/show", type: :view do
  before(:each) do
    @host = assign(:host, Host.create!(
      :name => "Name",
      :description => "MyText",
      :url => "Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Url/)
  end
end
