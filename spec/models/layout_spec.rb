# spec for Layout Model
require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe Layout do   
  let(:user) { Factory(:user) }
  let(:site) { Factory(:site) }
  
  before(:each) do
    @layout = Factory(:layout, :site => site, :created_by => user, :updated_by => user)
  end

  # -- Assignment -------------------------------------------------------------- 
  describe "mass assignment" do
    it "should protect against mass assignment of created_by_id and updated_by_id" do
      layout = Layout.new(:updated_by_id => mock_model("User").id, :created_by_id => mock_model("User").id)
      layout.created_by_id.should be_nil
      layout.updated_by_id.should be_nil
    end
    
    it "should not allow mass assignment of" do
      @layout.should_not allow_mass_assignment_of(:created_by_id => mock_model("User").id, :updated_by_id => mock_model("User").id)
    end
    
    it "should allow mass assignment of" do
      @layout.should allow_mass_assignment_of(:name => "foobar", :content => "Hello,World!")
    end
  end
  
  # -- Before Validation Callback  -----------------------------------------------
  describe "before_validation callback" do    
    describe "#page_site" do
      it "should assign the site to the page before saving" do
        @layout.site.should == Site.first
      end
    end
  end
  
    # -- Before Save Callback -----------------------------------------------------
  describe "before_save" do
    describe "#format_content" do
      it "should remove any leading or trailing whitespace from the content" do
        @layout.content = " Hello, World! "
        @layout.save
        @layout.content.should == "Hello, World!"
      end
    end
  end
  
  # -- Validations --------------------------------------------------------------
  describe "validations" do
    it "should create a valid user with valid attributes" do
      @layout.should be_valid
    end
    
    it "should not be valid without a site_id" do
      @layout.stub(:site_set).and_return(nil)
      @layout.site_id = nil
      @layout.should_not be_valid
    end
    
    it "should not be valid without a layout name" do
     @layout.name = nil
     @layout.should_not be_valid
    end
    
    it "should not be valid without a unique layout name" do
      Factory.build(:layout, :name => "#{@layout.name}", :created_by => @user, :updated_by => @user).should_not be_valid
    end
    
    it "should not be valid without content" do
      @layout.content = nil
      @layout.should_not be_valid
    end
    
    it "should not be valid without createb_by_id" do
      @layout.created_by_id = nil
      @layout.should_not be_valid
    end
    
    it "should validate associated user instance in created_by" do
      @layout.created_by_id = nil
      @layout.should_not be_valid
    end
    
    it "should not be valid without updated_by_id" do
      @layout.updated_by_id = nil
      @layout.should_not be_valid
    end
    
    it "should validate associated user instance in updated_by" do
      @layout.updated_by_id = nil
      @layout.should_not be_valid
    end   
  end
  
  # -- Associations ----------------------------------------------------
  context "associations" do
    it "should reference many pages" do
      @layout.should reference_many(:pages)
    end
    
    it "should reference a layout" do
      @layout.should be_referenced_in(:site)
    end
    
    it "should reference a user with created_by" do
      @layout.should be_referenced_in(:created_by).of_type(User)
    end
    
    it "should reference a user with updated_by" do
      @layout.should be_referenced_in(:updated_by).of_type(User)
    end
  end
end