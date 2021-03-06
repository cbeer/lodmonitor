require 'rails_helper'

RSpec.describe "hosts/new", type: :view do
  before(:each) do
    assign(:host, Host.new(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new host form" do
    render

    assert_select "form[action=?][method=?]", hosts_path, "post" do

      assert_select "input#host_name[name=?]", "host[name]"

      assert_select "textarea#host_description[name=?]", "host[description]"
    end
  end
end
