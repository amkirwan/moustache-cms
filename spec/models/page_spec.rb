require 'spec_helper'

describe Page do   
  let(:site) { FactoryGirl.create(:site) }
  let(:user) { FactoryGirl.create(:user, :site => site) }
  let(:layout) { FactoryGirl.create(:layout, :site_id => site.id, :created_by_id => user.id, :updated_by_id => user.id) }
  let(:parent) { FactoryGirl.create(:page, :site_id => site.id, :layout_id => layout.id, :created_by_id => user.id, :updated_by_id => user.id, :editor_ids => [user.id]) }
  before(:each) do                 
    @page = FactoryGirl.create(:page, :site_id => site.id, :parent => parent , :layout_id => layout.id, :created_by_id => user.id, :updated_by_id => user.id, :editor_ids => [user.id])
  end
  
  # -- Assignment -------------------------------------------
  describe "mass assignment" do
    it "should protect against mass assignment of created_by and updated_by" do
      page = Page.new(:updated_by_id => mock_model("User").id, :created_by_id => mock_model("User").id)
      page.created_by_id.should be_nil
      page.updated_by_id.should be_nil
    end
    
    it "should not allow mass assignment of" do
      @page.should_not allow_mass_assignment_of(:created_by_id => mock_model("User").id, :updated_by_id => mock_model("User").id)
    end
    
  end

  # --  Associations -----------------------------------------------
  describe "Associations" do
    
    it "should embed one current state" do
      @page.should embed_one :current_state
    end

    it "should embed_many meta_tags" do 
      @page.should embed_many :meta_tags
    end 

    it "should embed many custom fields" do
      @page.should embed_many :custom_fields
    end

    it "should embed many page_parts" do
      @page.should embed_many :page_parts
    end

    it "should reference a site" do
      @page.should belong_to(:site)
    end
    
    it "should reference a layout" do
      @page.should belong_to(:layout)
    end
    
    it "should reference a user with created_by" do
      @page.should belong_to(:created_by).of_type(User)
    end
    
    it "should reference a user with updated_by" do
      @page.should belong_to(:updated_by).of_type(User)
    end
    
    it "should have many editors" do
      @page.should have_and_belong_to_many(:editors).of_type(User)
    end

  end

  
  # -- Validations  -----------------------------------------------
  describe "validations" do
    it "should be valid" do
      @page.should be_valid
    end
    
    it "should not be valid without a site" do
      @page.site_id = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a title" do
      @page.title = nil 
      @page.should_not be_valid
    end

    it "should not be valid without a unique title" do
      FactoryGirl.build(:page, 
                    :title => @page.title,
                    :site_id => site.id, 
                    :layout => layout, 
                    :created_by => user, 
                    :updated_by => user).should_not be_valid
    end

    
    it "should not be valid without a slug" do
      @page.stub(:slug_set).and_return(nil)
      @page.slug = nil
      @page.should_not be_valid
    end
   
    it "should not be valid without a full_path" do
      @page.stub(:full_path_set).and_return(nil)
      @page.full_path = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a unique full_path" do
      FactoryGirl.build(:page, 
                    :full_path => @page.full_path,
                    :site_id => site.id, 
                    :layout => layout, 
                    :created_by => user, 
                    :updated_by => user).should_not be_valid
    end
    
    it "should not be valid without a breadcrumb" do
      @page.stub(:breadcrumb_set).and_return(nil)
      @page.breadcrumb = nil
      @page.should_not be_valid
    end

    it "should not be valid without a current state" do
      @page.current_state = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a layout" do
      @page.layout_id = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a created_by" do
      @page.created_by_id = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a updated_by" do
      @page.updated_by_id = nil
      @page.should_not be_valid
    end
  
    it "should not be valid if the page_part name already exists" do
      @page.page_parts.create(:name => @page.page_parts.first.name).should_not be_valid
    end
  end


  # -- After Initialze ----------------
  context "after initialize callback" do
    describe "#default_meta_tags" do
      it "should assign the default meta tags" do
        @page.meta_tags.count.should == 3
        @page.meta_tags[0].name.should == 'title'
        @page.meta_tags[1].name.should == 'keywords'
        @page.meta_tags[2].name.should == 'description'
      end
    end
  end
  

  # -- Before Validation Callback -------------------------------------------  
  context "before_validation callback" do
    describe "#format_title" do
      it "should remove any leading or trainling white space from the title" do
        @page.title = " Hello, World!  \n"
        @page.save
        @page.title.should == "Hello, World!"
      end
    end
    
    describe "#assign_full_path" do
      it "should set the full path of the page to the parent plus page slug" do
        @page.full_path.should == "#{@page.parent.full_path}/#{@page.slug}".squeeze("/")
      end
      
      it "should set the full path to '/' when it is the root page" do
        @page.parent.full_path.should == "/"
      end
      
      it "should set the full path to '404' when the page title is '404" do
        page2 = FactoryGirl.create(:page, :title => "404", :site => site, :layout => layout, :created_by => user, :updated_by => user)
        page2.full_path.should == "404"
      end
    end
    
    describe "#slug_set" do
      it "should set the page path to index when there the root node is not set, when there is one page document" do
        @page.parent.slug.should == "/"
      end
      
      it "should set the slug to the page title when the slug is blank and when the root.node exists" do
        page2 = FactoryGirl.create(:page, :slug => nil, :parent => parent, :site => site, :layout => layout, :created_by => user, :updated_by => user)
        page2.slug.should == page2.title.downcase.gsub(/[\s_]/, '-')
        page2 = nil
      end
      
      it "should remove any leading or trailing white space from the slug" do
        @page.slug = " Hello, World!  \n"
        @page.save
        @page.slug.should == "hello-world"
      end 
    end  
    
    describe "#assign_breadcrumb" do
      it "should set the breadcrumb to the page title when the slug is nil" do
        @page.breadcrumb = nil
        @page.save
        @page.breadcrumb.should == @page.title.downcase
      end

      it "should remove any leading or trailing white space from the breadcrumb" do
        @page.breadcrumb = " Hello, World!  \n"
        @page.save
        @page.breadcrumb.should == "hello, world!"
      end
    end
  end
  
  # -- Before Save Callback -------------------------------------------  
  context "before_save callback" do
    describe "#uniq_editor_ids" do
      it "should make editor_ids array unique" do
        @page.editor_ids = [user.id, user.id]
        @page.save
        @page.editor_ids.should == [user.id]
      end
    end
  end
  
  # -- After Update Callback -------------------------------------------
  context "after_update callback" do 
    describe "#update_current_state_time" do
      it "should set the current_state.published_at to the current DateTime when the current_state is published" do
        @page.current_state.name = "published"
        @page.save
        @page.current_state.time.should_not == nil
      end

      it "should not set the current_state.published_at to the current DateTime when the current_state is not published" do
        @page.current_state.name = "draft"
        @page.save
        @page.current_state.time.should_not == nil
      end
    end
  end
  
  # -- After Save Callback -------------------------------------------      
  context "after_save callback" do
    describe "#update_user_pages" do
      it "should add the page association to the users who are editors" do
        @page.editors << user
        @page.save
        user.pages.should include(@page)
      end
    end
  end

  # --  Scopes -----------------------------------------------------
  context "Scopes" do
    describe "Page#all_from_current_site" do
      it "should return all the pages from the current_site" do
        Page.all_from_current_site(site).count.should == 2
      end
    end
  end
  
  # -- Class Methods -----------------------------------------------
  context "Class Methods" do
    describe "Page#find_by_id" do
      it "should return the page when searching by id" do
        Page.find_by_id(@page.id).should == @page
      end            
    end  

    describe "Page#find_by_full_path" do
      it "should return the page with the full_path" do 
        Page.find_by_full_path(@page.full_path).should == @page
      end
    end
    
    describe "Page#find_by_title" do
      it "should return the page by the title" do
        Page.find_by_title(@page.title).should == @page
      end
    end

    describe "Page#find_by_slug" do
      it "should find the pae by the slug" do
        Page.find_by_slug(@page.slug).should == @page
      end
    end
  end
  
  # -- Instance Methods -----------------------------------------------
  context "Instance Methods" do
    describe "home_page?" do
      it "should return true if the page is the home page" do
        parent.home_page?.should be_true
      end

      it "should return false if the page is not the home page" do
        @page.home_page?.should be_false
      end
    end

    describe "#delete_association_of_editor_id" do
      it "should remove the editor from the editor_ids and editor fields" do
        user = FactoryGirl.create(:user)
        @page.editors << @user
        @page.save
        @page.delete_association_of_editor_id(user.id)
        @page.save
        @page.editor_ids.should_not include(user.id)
      end
    end

    describe "sort_children" do
      it "should update the pages in the array postion property to match their postion in the given array" do
        page0 = FactoryGirl.create(:page, :site => site, :parent => @page)
        page1 = FactoryGirl.create(:page, :site => site, :parent => @page)
        page0.reload.position.should == 0 
        page1.reload.position.should == 1 
        @page.sort_children([page1.id.to_s, page0.id.to_s])
        page0.reload.position.should == 1 
        page1.reload.position.should == 0 
      end
    end
    
    # -- MoustacheCms::Published ----
    describe "#published_on" do
      it "shortcut to the current_state published_at property" do
        @page.published_on.should == @page.current_state.published_on
      end
    end
    

    describe "#status" do
      it "should return the pages current state" do
        @page.current_state.name = "published"
        @page.save
        @page.status.should == "published"
      end
    end

    describe "#full_path_with_params" do
      it "should return the pages full_path wth the params" do
        @page.full_path_with_param(:preview => true).should == @page.full_path + '?preview=true'
      end
    end
    
  end
end
