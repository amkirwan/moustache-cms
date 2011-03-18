require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')

describe Page do   
  before(:each) do
    @page = Page.make!
  end
  
  context "mass assignment" do
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
             :meta_title => "foobar",  
             :meta_keywords => "foobar", 
             :meta_description => "foobar",
             :layout_id => stub_model(Layout), 
             :filter => stub_model(Filter), 
             :current_state => stub_model(CurrentState))
       page.title.should_not == nil
       page.meta_title.should_not == nil
       page.meta_keywords.should_not == nil
       page.meta_description.should_not == nil
       page.layout_id.should_not == nil
       page.filter.should_not == nil
       page.current_state.should_not == nil
    end
  end
  
  context "before_validation set page filter if it isn't set" do
    it "should set the default filter to html before saving" do
      @page.filter = nil
      @page.save
      @page.filter.name.should == "html"
    end
    
    it "should remove any leading or trainling white space from the title" do
      @page.title = " Hello, World!  \n"
      @page.save
      @page.title.should == "Hello, World!"
    end
    
    it "should set the path_name to the page title when the path_name is nil" do
      @page.title = " Hello, World!    \n"
      @page.path_name = nil
      @page.save
      @page.path_name.should == "Hello, World!"
    end
    
    it "should remove any leading or trailing white space from the path_name" do
      @page.path_name = " Hello, World!  \n"
      @page.save
      @page.path_name.should == "Hello, World!"
    end
    
    it "should make editor_ids array unique" do
      @page.editor_ids = ["ak730", "cds27", "foobar", "ak730", "cds27"]
      @page.save
      @page.editor_ids.should == ["ak730", "cds27", "foobar"]
    end
  end
  
  context "after_validation set path_name if it isn't set" do
    it "should set the default path_name to the page name if it is nil" do
      @page.path_name = nil
      @page.save
      @page.path_name.should == @page.title
    end
    
    it "should set the user#pages with after_save filter for manually bug in mongoid rc7 habtm to habtm" do
      @page.save
      @page.editors.each { |editor| editor.pages.count == 1 }
    end
  end
  
  context "validations" do
    it "should not be valid without a title" do
      @page.title = nil 
      @page.should_not be_valid
    end
    
    it "should not be valid without a unique title" do
      Page.make(:title => @page.title).should_not be_valid
    end
    
    it "should not be valid without a unique meta_title" do
      Page.make(:meta_title => @page.meta_title).should_not be_valid
    end
    
    it "should not be valid without a filter" do
      @page.stub(:set_filter).and_return(nil)
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
  end
  
  context "associations" do
    it "should embed one current state" do
      @page.should embed_one :current_state
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
  end
  
  context "nested attributes" do
    it "should accept nested attributes for current_state" do
      @page.respond_to?(:build_current_state).should == true
    end
    
    it "should accept nested attributes for editors" do
      @page.editors = []
      @page.editors.build
      @page.editors.should_not == nil
    end
  end

end

















