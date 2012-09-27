require 'spec_helper'

describe MoustacheCms::DefaultMetaTags do
  class DefaultMetaTagsDummy
    include Mongoid::Document 
    include MoustacheCms::DefaultMetaTags
  end

  before(:each) do
    @dummy_class = DefaultMetaTagsDummy.new
  end
  # -- After Initialze ----------------
  context "after initialize callback" do
    describe "#default_meta_tags" do
      subject { @dummy_class }

      it { should have(3).meta_tags }

      it "should have a meta tag with a title" do
        @dummy_class.meta_tags.where(name: 'title').should be_true  
      end

      it "should have a meta tag with a keyword" do
        @dummy_class.meta_tags.where(name: 'keyword').should be_true  
      end

      it "should have a meta tag with a description" do
        @dummy_class.meta_tags.where(name: 'description').should be_true  
      end
    end
  end

end 
