require 'rails_helper'

describe "Integration tests" do
  it "should create a new host" do
    visit root_path
    click_on "Hosts"
    click_on "+ Add Host"
    fill_in :host_name, with: "This is a test host"
    click_on "Create Host"
    expect(page).to have_content "This is a test host"
  end
  
  it "should create a new host with resources", js: true do
    visit root_path
    click_on "Hosts"
    click_on "+ Add Host"
    fill_in :host_name, with: "This is a test host"
    click_on "+ Add"
    expect(page).to have_selector ".resources .form-group"
    fill_in :host_resources_attributes_1_url, with: "http://example.com/"
    click_on "Create Host"
    expect(page).to have_content "This is a test host"
  end
end