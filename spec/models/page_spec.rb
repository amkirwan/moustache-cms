require 'spec_helper'

describe Page do   
  let(:site) { Factory(:site) }
  let(:user) { Factory(:user, :site => site) }
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
    
  end

  # -- After Save Callback --------------
  describe "after_save callback" do
    describe "#update_user_pages" do
      it "should add the page association to the users who are editors" do
        @page.editors << user
        @page.save
        user.pages.should include(@page)
      end
    end
  end
  
  # -- Validations  ---------------------
  describe "validations" do
    it "should be valid" do
      @page.should be_valid
    end

    it "should not be valid if the page_part name already exists" do
      @page.page_parts.create(:name => @page.page_parts.first.name).should_not be_valid
    end
  end

  # -- Before Validations ----------------
   describe "before_validations" do
    describe "slug_set" do
      it "should set the slug to empyt when the site_id is nil" do
        @page.site_id = nil
        @page.save
        @page.slug.should == ""
      end

      it "should set the slug to 404 when the title is 404" do
        @page.title = "404"
        @page.save
        @page.slug.should == "404"
      end

      it "should set the slug to '/' when it is the root page" do
        @page.stub(:root?).and_return(true)
        @page.save
        @page.slug.should == "/"
      end

      it "should set the slug to the title when the slug is blank" do
        @page.slug = "" 
        @page.save
        @page.slug.should == @page.title.downcase.gsub(/[\s_]/, '-')
      end

      it "should set the slug to the slug when set" do
        @page.slug = "foobar"
        @page.save
        @page.slug == "foobar"
      end
    end
  end
  
  # --  Scopes -------------------------
  describe "Scopes" do
    describe "Page#published" do
      it "should return the published items as a mongoid criteria" do
        Page.published.should be_an_instance_of(Mongoid::Criteria)
      end
      
      it "should return all the items that have a current_state set to published" do
        Page.published.count.should be >= 1
      end
    end

    describe "Page#all_from_current_site" do
      it "should return all the pages from the current_site" do
        Page.all_from_current_site(site).count.should == 2
      end
    end
  end
  
  # --  Associations -----------------------------------------------
  describe "Associations" do

    it "should embed many page_parts" do
      @page.should embed_many :page_parts
    end

    it "should have many editors" do
      @page.should have_and_belong_to_many(:editors).of_type(User)
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
  end
  
  # -- Instance Methods -----------------------------------------------
  describe "Instance Methods" do
    describe "sort_children" do
      it "should update the pages in the array postion property to match their postion in the given array" do
        page0 = Factory(:page, :site => site, :parent => @page)
        page1 = Factory(:page, :site => site, :parent => @page)
        page0.reload.position.should == 0 
        page1.reload.position.should == 1 
        @page.sort_children([page1.id.to_s, page0.id.to_s])
        page0.reload.position.should == 1 
        page1.reload.position.should == 0 
      end
    end

    describe "#home_page?" do
      it "should return true when the page is the home page for the site" do
        parent.home_page?.should be_true
      end

      it "should return false when the page is not the home page" do
        @page.home_page?.should be_false
      end
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

end




