require 'spec_helper'

describe Leaf do

  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }
  let(:layout) { Factory(:layout, :site_id => site.id, :created_by_id => user.id, :updated_by_id => user.id) }

  before(:each) do
    @leaf = Factory(:leaf, :site_id => site.id, :layout_id => layout.id, :created_by_id => user.id, :updated_by_id => user.id)
  end


  # --  Association --------------------
  describe "Association" do

    it "should embed_many meta_tags" do 
      @leaf.should embed_many :meta_tags
    end 

    it "should embed one current state" do
      @leaf.should embed_one :current_state
    end

    it "should reference a site" do
      @leaf.should belong_to(:site)
    end

    it "should reference a layout" do
      @leaf.should belong_to(:layout)
    end

    it "should reference a user with created_by" do
      @leaf.should belong_to(:created_by).of_type(User)
    end
    
    it "should reference a user with updated_by" do
      @leaf.should belong_to(:updated_by).of_type(User)
    end
  end 


  # -- Validations  -----------------------------------------------
  describe "validations" do
    it "should be valid" do
      @leaf.should be_valid
    end
    
    it "should not be valid without a site" do
      @leaf.site_id = nil
      @leaf.should_not be_valid
    end
    
    it "should not be valid without a title" do
      @leaf.title = nil 
      @leaf.should_not be_valid
    end

    it "should not be valid without a unique title" do
      Factory.build(:leaf, 
                    :title => @leaf.title,
                    :site_id => site.id, 
                    :layout => layout, 
                    :created_by => user, 
                    :updated_by => user).should_not be_valid
    end

    
    it "should not be valid without a slug" do
      @leaf.stub(:slug_set).and_return(nil)
      @leaf.slug = nil
      @leaf.should_not be_valid
    end
   
    it "should not be valid without a full_path" do
      @leaf.stub(:full_path_set).and_return(nil)
      @leaf.full_path = nil
      @leaf.should_not be_valid
    end
    
    it "should not be valid without a unique full_path" do
      Factory.build(:leaf, 
                    :title => @leaf.title,
                    :full_path => @leaf.full_path,
                    :site_id => site.id, 
                    :layout => layout, 
                    :created_by => user, 
                    :updated_by => user).should_not be_valid
    end
    


    it "should not be valid without a current state" do
      @leaf.current_state = nil
      @leaf.should_not be_valid
    end
    
    it "should not be valid without a layout" do
      @leaf.layout_id = nil
      @leaf.should_not be_valid
    end
    
    it "should not be valid without a created_by" do
      @leaf.created_by_id = nil
      @leaf.should_not be_valid
    end
    
    it "should not be valid without a updated_by" do
      @leaf.updated_by_id = nil
      @leaf.should_not be_valid
    end
  
  end

  # -- Before Validation Callback -------------------------------------------  
  describe "before_validation callback" do
    describe "#format_title" do
      it "should remove any leading or trainling white space from the title" do
        @leaf.title = " Hello, World!  \n"
        @leaf.save
        @leaf.title.should == "Hello, World!"
      end
    end

    describe "#slug_set" do
      it "should set the slug to the name slug name given" do
        @leaf.slug = "setting the slug"
        @leaf.save
        @leaf.slug.should == "setting the slug"
      end

      it "should set the slug to the title if the slug is nil" do
        @leaf.slug = nil
        @leaf.save
        @leaf.slug.should == @leaf.title
      end
    end
    
    describe "#assign_full_path" do
      it "should set the full path of the page to the parent plus page slug" do
        @leaf.full_path.should == @leaf.slug
      end
    end
  end

  # -- Before Update Callback -------------------------------------------
  describe "before_update callback" do 
    describe "#update_current_state_time" do
      it "should set the current_state.published_at to the current DateTime when the current_state is published" do
        @leaf.current_state.name = "published"
        @leaf.save
        @leaf.current_state.time.should_not == nil
      end

      it "should not set the current_state.published_at to the current DateTime when the current_state is not published" do
        @leaf.current_state.name = "draft"
        @leaf.save
        @leaf.current_state.time.should_not == nil
      end
    end
  end
  
  
  # --  Scopes --------------------
  describe "Scopes" do
    describe "Leaf#published" do
      it "should return the published items as a mongoid criteria" do
        Leaf.published.should be_an_instance_of(Mongoid::Criteria)
      end
      
      it "should return all the items that have a current_state set to published" do
        Leaf.published.count.should be >= 1
      end
    end

    describe "Leaf#all_from_current_site" do
      it "should return all the pages from the current_site" do
        Leaf.all_from_current_site(site).count.should == 1
      end
    end
  end


  # -- Class Methods -----------------------------------------------
  describe "Class Methods" do
    describe "Leaf#find_by_full_path" do
      it "should return the page with the full_path" do 
        Leaf.find_by_full_path(@leaf.full_path).should == @leaf
      end
    end
    
    describe "Page#find_by_id" do
      it "should return the page when searching by id" do
        Leaf.find_by_id(@leaf.id).should == @leaf
      end            
    end  
    
    describe "Page#find_by_title" do
      it "should return the page by the title" do
        Leaf.find_by_title(@leaf.title).should == @leaf
      end
    end
  end

  # -- Instance Methods -----------------
  describe "Instance Methods" do
    describe "current_state_attributes=(attributes)" do
      it "should assign the current state from a nested attributes" do
        @leaf.current_state_attributes = {:name => 'published'}
        @leaf.save
        @leaf.current_state.name.should == 'published'
      end
    end

    describe "#published?" do
      it "should return true when the page's current state is published" do
        @leaf.published?.should be_true
      end
    
      it "should return false when the page's current state is not published" do
        @leaf.current_state.name = "draft"
        @leaf.published?.should be_false
      end
    end
  
    describe "#draft?" do
      it "should return true when the page's current state is draft" do
        @leaf.current_state.name = "draft"
        @leaf.draft?.should be_true
      end
    
      it "should return false when the page's current state is not draft" do
        @leaf.draft?.should be_false
      end
    end
    
    describe "#published_on" do
      it "shortcut to the current_state published_at property" do
        @leaf.published_on.should == @leaf.current_state.published_on
      end
    end
    


    describe "#status" do
      it "should return the pages current state" do
        @leaf.current_state.name = "published"
        @leaf.save
        @leaf.status.should == "published"
      end
    end
  end

end
