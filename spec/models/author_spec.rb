require 'spec_helper'

describe Author do
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }

  before(:each) do
    @author = Factory(:author, :site => site)
  end

  # -- Associations ---
  describe "Author Associations" do
    it "should belong to a site" do
      @author.should belong_to(:site)
    end

    it "should belong_to a user with created_by" do
      @author.should belong_to(:created_by).of_type(User)
    end
    
    it "should belong_to a user with updated_by" do
      @author.should belong_to(:updated_by).of_type(User)
    end
  end
end
