require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe Page do   
  let(:user) { Factory(:user) }
  let(:site) { Factory(:site) }
  let(:layout) { Factory(:layout, :site_id => site.id, :created_by_id => user.id, :updated_by_id => user.id) }
  let(:parent) { Factory(:page, :site_id => site.id, :layout_id => layout.id, :created_by_id => user.id, :updated_by_id => user.id, :editor_ids => [user.id], :post_container => true) }
  before(:each) do                 
    @page = Factory(:page, :site_id => site.id, :parent => parent , :layout_id => layout.id, :created_by_id => user.id, :updated_by_id => user.id, :editor_ids => [user.id])
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
    
    it "should allow mass assignment of" do
      page = Page.new(:name => "foobar",
             :title => "foobar",
             :parent => parent,
             :slug => "foobar",
             :full_path => "full_path",
             :breadcrumb => "foobar",
             :layout_id => BSON::ObjectId('4d7fe2397353202ab60000e9'), 
             :current_state => stub_model(CurrentState),
             :page_parts => [stub_model(PagePart)],
             :meta_data => { "title" => "foobar"},
             :post_container => true,
             :tags => "taggable")
       page.name.should == "foobar"
       page.parent.should == parent
       page.title.should == "foobar"
       page.slug.should == "foobar"
       page.full_path.should == "full_path"
       page.breadcrumb.should == "foobar"
       page.layout_id.should == BSON::ObjectId('4d7fe2397353202ab60000e9')
       page.current_state.should_not == nil
       page.page_parts.should_not == nil  
       page.meta_data.should_not == nil    
       page.post_container.should == true
       page.tags.should == "taggable"
    end
  end
  
  # -- Before Validation Callback -------------------------------------------  
  describe "before_validation callback" do
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
        page2 = Factory(:page, :title => "404", :site => site, :layout => layout, :created_by => user, :updated_by => user)
        page2.full_path.should == "404"
      end
    end
    
    describe "#slug_set" do
      it "should set the page path to index when there the root node is not set, when there is one page document" do
        @page.parent.slug.should == "/"
      end
      
      it "should set the slug to the page title when the slug is blank and when the root.node exists" do
        page2 = Factory(:page, :slug => nil, :parent => parent, :site => site, :layout => layout, :created_by => user, :updated_by => user)
        page2.slug.should == page2.title.downcase.gsub(/[\s_]/, '-')
        page2 = nil
      end
      
      it "should remove any leading or trailing white space from the slug" do
        @page.slug = " Hello, World!  \n"
        @page.save
        @page.slug.should == "hello,-world!"
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
  
  # -- Before Create Callback -------------------------------------------      
  describe "before_create callback" do
    describe "#permalink_set" do
      it "it should set the permalink in the format http://example.com/year/month/day/post-title" do
        time = DateTime.now
        year = time.year.to_s
        month = time.month.to_s
        day = time.day.to_s
        @page.permalink.should == "http://#{@page.site.full_subdomain}/#{year}/#{month}/#{day}/#{@page.slug}"
      end
    end
  end
  
  # -- Before Save Callback -------------------------------------------  
  describe "before_save callback" do
    describe "#uniq_editor_ids" do
      it "should make editor_ids array unique" do
        @page.editor_ids = [user.id, user.id]
        @page.save
        @page.editor_ids.should == [user.id]
      end
    end
  end
  
  # -- Before Update Callback -------------------------------------------
  describe "before_update callback" do 
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
  describe "after_save callback" do
    describe "#update_user_pages" do
      it "should add the page association to the users who are editors" do
        @page.editors << user
        @page.save
        user.pages.should include(@page)
      end
    end
  end

  # -- Before Destroy  ----------------------------------------------- 
  describe "before destroy callback" do
    describe "#delete_from_editors" do
      it "should remove the page from the users editor_ids" do
        @page.editors << user
        @page.destroy
        user.reload
        user.page_ids.should_not include(@page.id)
      end
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
    
    it "should not be valid without a unique name" do           
      Factory.build(:page, :name => @page.name, :parent => @page, :site_id => site.id, :layout => layout, :created_by => user, :updated_by => user).should_not be_valid
    end
    
    it "should not be valid without a title" do
      @page.title = nil 
      @page.should_not be_valid
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
      Factory.build(:page, 
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
  
  # --  Scopes -----------------------------------------------------
  describe "Scopes" do
    describe "Page#published" do
      it "should return the published items as a mongoid criteria" do
        Page.published.should be_an_instance_of(Mongoid::Criteria)
      end
      
      it "should return all the items that have a current_state set to published" do
        Page.published.count.should be >= 1
      end
    end
  end
  
  # --  Associations -----------------------------------------------
  describe "Associations" do
    it "should embed one current state" do
      @page.should embed_one :current_state
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
  
  # -- Class Methods -----------------------------------------------
  describe "Class Methods" do
    describe "Page#find_by_full_path" do
      it "should return the page with the full_path" do 
        Page.find_by_full_path(@page.full_path).should == @page
      end
    end
    
    describe "Page#find_by_id" do
      it "should return the page when searching by id" do
        Page.find_by_id(@page.id).should == @page
      end            
    end  
    
    describe "Page#find_by_title" do
      it "should return the page by the title" do
        Page.find_by_title(@page.title).should == @page
      end
    end
    
    describe "Page#name" do
      it "should return the page byt the name" do
        Page.find_by_name(@page.name).should == @page
      end
    end
  end
  
  # -- Instance Methods -----------------------------------------------
  describe "Instance Methods" do
    describe "#permalink" do  
      it "should return the permalink in the format http://example.com/year/month/day/post-title" do
        time = DateTime.now
        year = time.year.to_s
        month = time.month.to_s
        day = time.day.to_s
        @page.permalink.should == "http://#{@page.site.full_subdomain}/#{year}/#{month}/#{day}/#{@page.slug}"
      end
    end
    
    describe "#published?" do
      it "should return true when the page's current state is published" do
        @page.published?.should be_true
      end
    
      it "should return false when the page's current state is not published" do
        @page.current_state.name = "draft"
        @page.published?.should be_false
      end
    end
  
    describe "#draft?" do
      it "should return true when the page's current state is draft" do
        @page.current_state.name = "draft"
        @page.draft?.should be_true
      end
    
      it "should return false when the page's current state is not draft" do
        @page.draft?.should be_false
      end
    end
    
    describe "#published_at" do
      it "shortcut to the current_state published_at property" do
        @page.published_at.should == @page.current_state.published_at
      end
    end
    
    describe "#delete_editor" do
      it "should remove the editor from the editor_ids and editor fields" do
        user = Factory(:user)
        @page.editors << @user
        @page.save
        @page.delete_association_of_editor_id(user.id)
        @page.save
        @page.editor_ids.should_not include(user.id)
      end
    end

    describe "#status" do
      it "should return the pages current state" do
        @page.current_state.name = "published"
        @page.save
        @page.status.should == "published"
      end
    end
    
    describe "#post_container?" do
      it "should return true when the current page is a container" do
        @page.post_container = false
        @page.post_container?.should == false
      end
    end

  end
end




