# spec for Layout Model
require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe Layout do   
  let(:user) { FactoryGirl.create(:user) }
  let(:site) { FactoryGirl.create(:site) }
  
  before(:each) do
    @layout = FactoryGirl.create(:layout, :site_id => site.id, :created_by_id => user.id, :updated_by_id => user.id)
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
    
    it "should not be valid without a site" do
      @layout.site_id = nil
      @layout.should_not be_valid
    end
    
    it "should not be valid without a layout name" do
     @layout.name = nil
     @layout.should_not be_valid
    end
    
    it "should not be valid without a unique layout name" do
      FactoryGirl.build(:layout, :name => "#{@layout.name}", :site => site, :created_by => user, :updated_by => user).should_not be_valid
    end     
    
    context "should be valid when the layout name is associated with a different site" do
      it "should be valid " do
        FactoryGirl.build(:layout, :name => "#{@layout.name}", :site => FactoryGirl.build(:site), :created_by => user, :updated_by => user).should be_valid
      end
    end
    
    it "should not be valid without content" do
      @layout.content = nil
      @layout.should_not be_valid
    end
    
    it "should not be valid without createb_by_id" do
      @layout.created_by_id = nil
      @layout.should_not be_valid
    end
    
    it "should not be valid without updated_by_id" do
      @layout.updated_by_id = nil
      @layout.should_not be_valid
    end  
    
    it "should not be valid without an associated site" do
      @layout.site_id = nil
      @layout.should_not be_valid
    end
  end
 
  # -- Associations ----------------------------------------------------
  context "associations" do
    it "should have_many pages" do
      @layout.should have_many(:pages)
    end

    it "should have_many article_collections" do
      @layout.should have_many(:article_collections)
    end

    it "should have_many articles" do
      @layout.should have_many(:articles)
    end
 
    it "should belong_to a site" do
      @layout.should belong_to(:site)
    end

    it "should belong_to a user with created_by" do
      @layout.should belong_to(:created_by).of_type(User)
    end
    
    it "should belong_to a user with updated_by" do
      @layout.should belong_to(:updated_by).of_type(User)
    end
  end
end
