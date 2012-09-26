require 'spec_helper'

describe User do   
  let(:site) { FactoryGirl.create(:site) }

  before(:each) do
    @user = FactoryGirl.create(:user, :username => "foobar", :site => site)
  end 
  
  # -- Validations -----------------------------------------------
  context "validations" do
    it "should create a valid user with valid attributes" do
      @user.should be_valid
    end
  
    it "should not be valid without a username" do
     @user.username = nil
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

    it "should not be valid without a time_zone " do
      @user.time_zone = nil
      @user.should_not be_valid
    end
  
    it "should not be valid with duplicate pid within the same site" do  
      should validate_uniqueness_of(:username).scoped_to(:site_id)
    end
    
    context "duplicate pid should be valid on a different site" do
      it "should be valid with duplicate pid on a different site" do  
        FactoryGirl.build(:user, :username => "{@user.username}", :site => FactoryGirl.build(:site)).should be_valid
      end     
    end
  
    it "should not be valid with duplicate email addresses within the same site" do
      should validate_uniqueness_of(:email).scoped_to(:site_id)
    end      
    
    context "duplicate email should be valid on a different site" do
      it "should be valid with duplicate email on a different site" do  
        FactoryGirl.build(:user, :email => "#{@user.email}", :site => FactoryGirl.build(:site)).should be_valid
      end     
    end
  
    it "should not be valid without a correctly formated email address" do
      FactoryGirl.build(:user, :email => "abcdefg").should_not be_valid
    end
    
    it "should not be valid with a username < 3 characters" do
      FactoryGirl.build(:user, :username => "ab").should_not be_valid
    end 
  end

  # -- Scopes ----
  context "Scopes" do
    describe "User#all_from_current_site" do
      it "should return all the users from the current_site" do
        User.all_from_current_site(site).count.should == 1
      end
    end
  end
  
  # -- Before Validation Callback -------------------------------------------
  context "callbacks" do
    context "before validation it should check that the page_ids are unique" do
      it "should do something" do
        @user.page_ids = [Moped::BSON::ObjectId('4d7fe2397353202ab60000e9'), Moped::BSON::ObjectId('4d7fe2397353202ab60000e9')]
        @user.save
        @user.page_ids.count.should == 1
      end
    end
    
    context "it should lower the fields before saving" do
      it "should make the username downcase" do
        @user.username = "foobar"
        @user.save
        @user.username.should == "foobar"
      end
    
      it "should make the email downcase" do
        @user.email = "foobar@example.com"
        @user.save
        @user.email.should == "foobar@example.com"
      end
    end
  
    context "after save set_username" do
      it "should set the username to the username value" do
        @user.username.should == @user.username
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
 
    it "should reference many snippets created" do
      @user.should have_many(:snippets_created).of_type(Snippet)
    end
    
    it "should reference many snippets updated" do
      @user.should have_many(:snippets_updated).of_type(Snippet)
    end 

    it "should have_many asset_collections created" do
      @user.should have_many(:asset_collections_created).of_type(AssetCollection)
    end
    
     it "should have_many asset_collections updated" do
      @user.should have_many(:asset_collections_updated).of_type(AssetCollection)
    end 

    it "should have_many theme_collections created" do
      @user.should have_many(:theme_collections_created).of_type(ThemeCollection)
    end
    
     it "should have_many theme_collections updated" do
      @user.should have_many(:theme_collections_updated).of_type(ThemeCollection)
    end 

    it "should have_many article_collections created" do
      @user.should have_many(:article_collections_created).of_type(ArticleCollection)
    end
    
     it "should have_many article_collections updated" do
      @user.should have_many(:article_collections_updated).of_type(ArticleCollection)
    end 

     it "should have_many authors created" do
      @user.should have_many(:authors_created).of_type(Author)
    end
    
     it "should have_many authors updated" do
      @user.should have_many(:authors_updated).of_type(Author)
    end 

     it "should have_many articles created" do
      @user.should have_many(:articles_created).of_type(Article)
    end
    
     it "should have_many articles updated" do
      @user.should have_many(:articles_updated).of_type(Article)
    end 
   
    it "should have_and_belong_to_many many pages" do
      @user.should have_and_belong_to_many(:pages)
    end        

    it "should have_and_belong_to_many article_collections" do
      @user.should have_and_belong_to_many(:article_collections)
    end

    it "should belong to a site" do
      @user.should belong_to(:site)
    end        
  end
  
  # -- Class Methods -----------------------------------------------
  describe "Class Methods" do
    describe "User#find_by_name" do
      it "should return the user when they exist" do
        User.find_by_username("foobar").should == @user
      end
    end
  end
  
  # -- Instance Methods -----------------------------------------------
  describe "Instance Methods" do

    describe "full_name" do
      it "should return the users first and lastname" do
        @user.full_name.should == "Foo Moustache"
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

    describe "#clone_and_add_to_site" do
      it "should add the current user as a user to a new site" do
        new_site = FactoryGirl.create(:site, :name => 'blog')
        @user.clone_and_add_to_site(new_site)        
        Site.where(:name => 'blog').first.users.count.should == 1
        #new_site.reload
        #new_site.users.count.should == 1
      end  
    end

  end
end
