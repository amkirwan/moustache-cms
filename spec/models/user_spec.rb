require 'spec_helper'

describe User do   
  before(:each) do
    @user = Factory(:user, :puid => "foobar")
  end 
  
  # -- Mass Assignment -------------------------------------------
  context "mass assignment" do
    it "should protect against mass assignment of puid and role" do
      user = User.new(:puid => "ak730", :role => "admin")
      user.role.should be_nil
      user.puid.should be_nil
    end
    
    it "should not allow mass assignment of" do
      @user.should_not allow_mass_assignment_of(:puid => "baz", :puid => "baz", :role => "bar")
    end
    
    it "should allow mass assignment of" do
      @user.should allow_mass_assignment_of(:firstname => "x", :lastname => "x", :email => "foobar@example.com")
    end
  end
  
  context "before_validation set page filter if it isn't set" do
    it "should make page_ids array unique" do
      @user.page_ids = [ "4d7cd4617353202ab6000065", "5d7cd4617353202ab6000065", "4d7cd4617353202ab6000065", "4d7cd4617353202ab6000065"]
      @user.save
      @user.page_ids.count.should == 2
    end
  end
  
  # -- Validations -----------------------------------------------
  context "validations" do
    it "should create a valid user with valid attributes" do
      @user.should be_valid
    end
  
    it "should not be valid without a puid" do
     @user.puid = nil
     @user.should_not be_valid
    end  

    it "should not be valid without a firstname" do
      @user.firstname = nil
      @user.should_not be_valid
    end

    it "should not be valid without a lastname" do
      @user.lastname = nil
      @user.should_not be_valid
    end
  
    it "should not be valid without a email" do
      @user.email = nil
      @user.should_not be_valid
    end   
  
    it "should not be valid without a role" do
      @user.role = nil
      @user.should_not be_valid
    end 
    
    it "should not be valid without an associated site" do
      @user.site_id = nil
      @user.should_not be_valid
    end
  
    it "should not be valid with duplicate pid within the same site" do  
      #Factory(:user, :puid => @user.puid, :site_id => @user.site_id).should_not be_valid
      should validate_uniqueness_of(:puid).scoped_to(:site_id)
    end
    
    context "duplicate pid should be valid on a different site" do
      it "should be valid with duplicate pid on a different site" do  
        Factory.build(:user, :puid => "{@user.puid}", :site => Factory.build(:site)).should be_valid
      end     
    end
  
    it "should not be valid with duplicate email addresses within the same site" do
      #Factory.build(:user, :email => "#{@user.email}", :site_id => @user.site_id).should_not be_valid
      should validate_uniqueness_of(:email).scoped_to(:site_id)
    end      
    
    context "duplicate email should be valid on a different site" do
      it "should be valid with duplicate email on a different site" do  
        Factory.build(:user, :email => "#{@user.email}", :site => Factory.build(:site)).should be_valid
      end     
    end
  
    it "should not be valid without a correctly formated email address" do
      Factory.build(:user, :email => "abcdefg").should_not be_valid
    end
    
    it "should not be valid with a puid < 3" do
      Factory.build(:user, :puid => "ab").should_not be_valid
    end 
  end
  
  # -- Before Validation Callback -------------------------------------------
  context "callbacks" do
    context "before validation it should check that the page_ids are unique" do
      it "should do something" do
        @user.page_ids = [BSON::ObjectId('4d7fe2397353202ab60000e9'), BSON::ObjectId('4d7fe2397353202ab60000e9')]
        @user.save
        @user.page_ids.count.should == 1
      end
    end
    
    context "it should lower the fields before saving" do
      it "should make the puid downcase" do
        @user.puid = "FOOBAR"
        @user.save
        @user.puid.should == "foobar"
      end
    
      it "should make the email downcase" do
        @user.email = "FOOBAR@EXAMPLE.Com"
        @user.save
        @user.email.should == "foobar@example.com"
      end
    end
  
    context "after save set_puid" do
      it "should set the puid to the puid value" do
        @user.puid.should == @user.puid
      end
    end
  end
  
  # -- Before Destroy  ----------------------------------------------- 
  describe "before destroy callback" do
    describe "#delete_from_pages" do
      it "should remove the editor from the pages" do
        site = Factory(:site)
        layout = Factory(:layout, :site_id => site.id, :created_by => @user, :updated_by => @user)
        page = Factory(:page, :site_id => site.id, :layout => layout, :created_by => @user, :updated_by => @user, :editor_ids => [@user.id])
        u = User.criteria.for_ids(@user.id).first
        u.destroy
        Page.criteria.for_ids(page.id).first.editor_ids.should_not include(@user.id)
      end
    end  
  end
  
  # -- Associations ----------------------------------------------------
  context "associations" do
    it "should reference many layouts created" do
      @user.should have_many(:layouts_created).of_type(Layout)
    end
    
    it "should reference many layouts updated" do
      @user.should have_many(:layouts_updated).of_type(Layout)
    end
    
    it "should reference many pages created" do
      @user.should have_many(:pages_created).of_type(Page)
    end
    
    it "should reference many pages updated" do
      @user.should have_many(:pages_updated).of_type(Page)
    end

    it "should reference many theme_assets created" do
      @user.should have_many(:theme_assets_created).of_type(ThemeAsset)
    end
    
    it "should reference many theme_assets updated" do
      @user.should have_many(:theme_assets_updated).of_type(ThemeAsset)
    end        
    
    it "should reference many snippets crated" do
      @user.should have_many(:snippets_created).of_type(Snippet)
    end
    
     it "should reference many snippets crated" do
      @user.should have_many(:snippets_updated).of_type(Snippet)
    end 
   
    it "should have many editors" do
      @user.should have_and_belong_to_many(:pages)
    end        
    
    it "should belong to a site" do
      @user.should belong_to(:site)
    end        
  end
  
  # -- Class Methods -----------------------------------------------
  describe "Class Methods" do
    describe "User#find_by_name" do
      it "should return the user when they exist" do
        User.find_by_puid("foobar").should == @user
      end
    end
  end
  
  # -- Instance Methods -----------------------------------------------
  describe "Instance Methods" do

    describe "full_name" do
      it "should return the users first and lastname" do
        @user.full_name.should == "Foobar Baz"
      end
    end
    describe "#role?" do
      it "should return true when the user role equals the base role" do
        @user.role = "admin"
        @user.role?(:admin).should == true
      end 
    
      it "should return true when the user role is greater than the base role" do
        @user.role = "admin"
        @user.role?(:editor).should == true
      end    
    
      it "should return true when the user role is greater than or equal to the base role" do
       @user.role = "editor"
       @user.role?(:editor).should == true
      end 
      
      it "should return false when the user does not have a role defined" do
        @user.role = nil
        @user.role?(:admin).should == false
      end
    
      it "should return false when the user role is less than the base role" do
        @user.role = "editor"
        @user.role?(:admin).should == false
      end
    end
  end
end
