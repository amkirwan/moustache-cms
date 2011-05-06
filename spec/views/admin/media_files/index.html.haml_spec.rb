# admin::media_files index spec
require 'spec_helper'

describe "admin_media_files/index.html.haml" do
  let(:media_files) { [stub_model(MediaFile, :name => "foobar"), stub_model(MediaFile, :name => "foo")] }
  before(:each) do
    assign(:media_files, media_files)
  end

  it "renders a list of admin_media_files" do
    render
    media_files.each do |media|
      rendered.should have_selector("li##{media.name}")
    end
  end
end
