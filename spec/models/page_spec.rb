require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe Page do   
  before(:each) do                 
    @page = Factory(:page)
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
      page = Page.new(:title => "foobar",
             :parent_id => BSON::ObjectId('5d7fe2397353202ab60000e9'),
             :slug => "foobar",
             :full_path => "full_path",
             :breadcrumb => "foobar",
             :meta_title => "foobar",  
             :meta_keywords => "foobar", 
             :meta_description => "foobar",
             :layout_id => BSON::ObjectId('4d7fe2397353202ab60000e9'), 
             :filter => stub_model(Filter), 
             :current_state => stub_model(CurrentState),
             :page_parts => [stub_model(PagePart)],
             :type => "foobar")
       page.parent_id.should == BSON::ObjectId('5d7fe2397353202ab60000e9')
       page.title.should == "foobar"
       page.slug.should == "foobar"
       page.full_path.should == "full_path"
       page.breadcrumb.should == "foobar"
       page.meta_title.should == "foobar"
       page.meta_keywords.should == "foobar"
       page.meta_description.should == "foobar"
       page.layout_id.should == BSON::ObjectId('4d7fe2397353202ab60000e9')
       page.filter.should_not == nil
       page.current_state.should_not == nil
       page.page_parts.should_not == nil
       page.type.should == "foobar"      
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
    end
    
    describe "#assign_slug" do
      it "should set the page path to index when there the root node is not set, when there is one page document" do
        @page.parent.slug.should == "/"
      end
      
      it "should set the slug to the page title when the slug is blank and when the root.node exists" do
        page2 = Factory(:page, :parent_id => @page.id, :slug => nil)
        page2.slug.should == page2.title.downcase
        page2 = nil
      end
      
      it "should remove any leading or trailing white space from the slug" do
        @page.slug = " Hello, World!  \n"
        @page.save
        @page.slug.should == "hello,-world!"
      end 
    end  
    
    describe "#assign_filter" do
      it "should set the default filter to html before saving" do
        @page.filter = nil
        @page.save
        @page.filter.name.should == "html"
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
    
    describe "#page_site" do
      it "should assign the site to the page before saving" do
        @page.site.should == Site.first
      end
    end
  end
  
  # -- Before Save Callback -------------------------------------------  
  describe "before_save callback" do
    describe "#uniq_editor_ids" do
      it "should make editor_ids array unique" do
        @page.editor_ids = ["ak730", "cds27", "foobar", "ak730", "cds27"]
        @page.save
        @page.editor_ids.should == ["ak730", "cds27", "foobar"]
      end
    end
    
    describe "#published_at" do
      it "should set the current_state.published_at to the current DateTime when the current_state is published" do
        @page.current_state.name = "published"
        @page.save
        @page.current_state.published_at.should_not == nil
      end

      it "should not set the current_state.published_at to the current DateTime when the current_state is not published" do
        @page.current_state.name = "draft"
        @page.current_state.published_at = nil
        @page.save
        @page.current_state.published_at.should == nil
      end

      it "should not set the current_state.published_at to the current DateTime when it is already set and the date is published" do
        date = DateTime.now
        @page.current_state.published_at = date
        sleep(1)
        @page.save
        @page.current_state.published_at.to_s.should == date.to_s
      end
    end
  end
  
  # -- After Save Callback -------------------------------------------      
  describe "after_save callback" do
    describe "#update_user_pages" do
      it "should add the page association to the users who are editors" do
        u = Factory(:user)
        @page.editors << u
        @page.save
        u.pages.should include(@page)
      end
    end
  end

  # -- Before Destroy  ----------------------------------------------- 
  describe "before destroy callback" do
    describe "#delete_from_editors" do
      it "should remove the page from the users editor_ids" do
        u = Factory(:user)
        @page.editors << u
        @page.save
        @page.destroy
        u.page_ids.should_not include(@page.id)
      end
    end  
  end

  # -- Validations  -----------------------------------------------
  describe "validations" do
    it "should be valid" do
      @page.should be_valid
    end
    
    it "should not be valid without a site_id" do
      @page.stub(:assign_site).and_return(nil)
      @page.site_id = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a page_type" do
      @page.page_type = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a title" do
      @page.title = nil 
      @page.should_not be_valid
    end
    
    it "should not be valid without a unique title" do
      Factory.build(:page, :parent_id => @page.parent_id, :title => @page.title).should_not be_valid
    end
    
    it "should not be valid without a slug" do
      @page.stub(:assign_slug).and_return(nil)
      @page.slug = nil
      @page.should_not be_valid
    end
   
    it "should not be valid without a full_path" do
      @page.stub(:assign_full_path).and_return(nil)
      @page.full_path = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a unique full_path" do
      page2 = Factory(:page, :parent_id => @page.parent_id)
      page2.stub(:assign_full_path)
      page2.full_path = @page.full_path
      page2.should_not be_valid
    end
    
    it "should not be valid without a breadcrumb" do
      @page.stub(:assign_breadcrumb).and_return(nil)
      @page.breadcrumb = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a unique meta_title" do
      Factory.build(:page, :parent_id => @page.parent_id, :meta_title => @page.meta_title).should_not be_valid
    end
    
    it "should not be valid without a filter" do
      @page.stub(:assign_filter).and_return(nil)
      @page.filter = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a current state" do
      @page.current_state = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a layout" do
      @page.layout = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a created_by" do
      @page.created_by = nil
      @page.should_not be_valid
    end
    
    it "should not be valid without a updated_by" do
      @page.updated_by = nil
      @page.should_not be_valid
    end
  
    it "should not be valid if the page_part name already exists" do
      @page.page_parts.create(:name => @page.page_parts.first.name).should_not be_valid
    end
  end
  
  # --  Associations -----------------------------------------------
  describe "associations" do
    it "should embed one current state" do
      @page.should embed_one :current_state
    end
    
    it "should reference a site" do
      @page.should be_referenced_in(:site)
    end
    
    it "should reference a layout" do
      @page.should be_referenced_in(:layout)
    end
    
    it "should reference a user with created_by" do
      @page.should be_referenced_in(:created_by).of_type(User)
    end
    
    it "should reference a user with updated_by" do
      @page.should be_referenced_in(:updated_by).of_type(User)
    end
    
    it "should have many editors" do
      @page.should reference_and_be_referenced_in_many(:editors).of_type(User)
    end
    
    it "should embedd many page_parts" do
      @page.should embed_many :page_parts
    end
  end
  
  # -- Class Methods -----------------------------------------------
  describe "Class Methods" do
    describe "Page#find_by_full_path" do
      it "should return the page with the full_path" do
        Page.find_by_full_path(@page.site, @page.full_path).should == @page
      end
    end
    
  end
  
  # -- Instance Methods -----------------------------------------------
  describe "Instance Methods" do
    describe "#permalink" do  
      it "should return the permalink" do
        year = @page.published_date.year.to_s
        month = @page.published_date.month.to_s
        day = @page.published_date.day.to_s
        @page.permalink.should == year + "/" + month + "/" + day + "/" + @page.slug
      end
    end
    
    describe "#published_at" do
      it "shortcut to the current_state published_at property" do
        @page.published_date.should == @page.current_state.published_at
      end
    end
  
    describe "#status" do
      it "should return the pages current state" do
        @page.current_state.name = "published"
        @page.save
        @page.status.should == "published"
      end
    end
  end
end




