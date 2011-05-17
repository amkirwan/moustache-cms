require File.expand_path(File.dirname(__FILE__) + '../../spec_helper')  
require "cancan/matchers"

describe Ability do  
  let(:site) { Factory.build(:site) }
  let(:site2) { Factory.build(:site) }
  let(:admin) { Factory.build(:admin, :site => site) }
  let(:admin2) { Factory.build(:admin, :site => site2) }
  let(:editor) { Factory.build(:editor, :site => site) }
  let(:editor2) { Factory.build(:editor, :site => site2) }
  let(:layout) { Factory.build(:layout, :site => site) }
  let(:layout2) { Factory.build(:layout, :site => site2) }
  let(:page) { Factory.build(:page, :site => site, :editors => [ admin, editor ]) }
  let(:page2) { Factory.build(:page, :site => site2, :editors => [ admin2, editor2 ]) } 
  let(:media_file) { Factory.build(:media_file, :site => site, :created_by => editor) }
  let(:media_file2) { Factory.build(:media_file, :site => site2, :created_by => editor2) }
  let(:admin_ability) { Ability.new(admin) }
  let(:admin_ability2) { Ability.new(admin2) }
  let(:editor_ability) { Ability.new(editor) }
  let(:editor_ability2) { Ability.new(editor2) }
  let(:user) { Factory.build(:user, :site => site) } 
  
  before(:each) do
    site.users << admin
    site2.users << admin2
  end
  
  after(:each) do
    site.users = []
    site2.users = []
  end
  
  describe "Admin" do
    context "Admin Approved" do
      it "should allow the admin to manage all" do 
        admin_ability.should be_able_to(:manage, admin)
        admin_ability.should be_able_to(:manage, page)
        admin_ability.should be_able_to(:manage, layout)
        admin_ability.should be_able_to(:manage, site)
      end
    end
    
    context "Admin Not Approved" do
      describe "should not be able to manage any item that does not have an associated site as the admin" do
        it "should not allow the admin to manage sites they are not associatied with" do
          admin_ability.should_not be_able_to(:manage, admin2)
          admin_ability.should_not be_able_to(:manage, editor2)
          admin_ability.should_not be_able_to(:manage, page2)
          admin_ability.should_not be_able_to(:manage, layout2)
          admin_ability.should_not be_able_to(:manage, site2)
        end
      end      
    end
  end
  
  describe "Editor" do
    context "Editor Approved" do
        describe "User Model Approved" do
          it "should allow the user with a role of editor to list user records" do
            editor_ability.should be_able_to(:index, user)
          end

          it "should allow the user with a role of editor to edit their own record" do
            editor_ability.should be_able_to(:update, editor)
          end  

          it "should allow the user with a role of editor to show their own record" do
            editor_ability.should be_able_to(:show, editor)
          end
          
          it "should allow the user with a role of editor to delete their record" do
            editor_ability.should be_able_to(:destroy, editor)
          end
        end

        describe "Page Approved" do
          it "should allow the user with a role of editor to create pages" do
            editor_ability.should be_able_to(:create, page)
          end

          it "should allow the user with a role of editor to index action" do
            editor_ability.should be_able_to(:index, page)
          end

          it "should allow the user with a role of editor to show pages they are an editor for" do
            editor_ability.should be_able_to(:show, page)
          end

          it "should allow the user with a role of editor to update pages they have editor rights for" do
            editor_ability.should be_able_to(:update, page)
          end

          it "should allow the user with a role of editor to destroy pages they have editor rights for" do
            editor_ability.should be_able_to(:destroy, page)
          end      
        end

        describe "MediaFile Approved" do
          it "should allow the user with a role of editor to read(:index, :show) media_files" do
            editor_ability.should be_able_to(:read, media_file)
          end

          it "should allow the user with a role of editor to create media_files" do
            editor_ability.should be_able_to(:create, media_file)
          end

          it "should allow the user witha role of editor to update media_files they created" do
            editor_ability.should be_able_to(:update, media_file)
          end

          it "should do something" do
            editor_ability.should be_able_to(:destroy, media_file)
          end
        end
      end
    end
    
    context "Editor Not Approved Actions" do    
      describe "Site Model" do
        it "should not allow a the user as an editor to manage sites" do
          editor_ability.should_not be_able_to(:manage, site)
        end

        it "should not allow the editor to manage sites they are not associatied with" do
          editor_ability.should_not be_able_to(:manage, layout2)
        end
      end

      describe "User Model Not Approved" do
        it "should not allow the user with a role of editor to read other users records" do
          editor_ability.should_not be_able_to(:read, user)
        end

        it "should not allow the user with a role of editor to create a new user record" do
          editor_ability.should_not be_able_to(:new, Factory.build(:user))
        end

        it "should not allow the user with a role of editor to edit other user records" do
          editor_ability.should_not be_able_to(:update, user)
        end    

        it "should not allow the user to manage users on another site" do
          editor_ability.should_not be_able_to(:read, editor2)
          editor_ability.should_not be_able_to(:create, editor2)
          editor_ability.should_not be_able_to(:update, editor2)
          editor_ability.should_not be_able_to(:destroy, editor2)
        end
      end

      describe "Layout Model Not Approved" do
        it "should not allow the user to mange layouts" do
          editor_ability.should_not be_able_to(:read, layout)
          editor_ability.should_not be_able_to(:create, layout)
          editor_ability.should_not be_able_to(:update, layout)
          editor_ability.should_not be_able_to(:destroy, layout)
        end
      end

      describe "Page Model Not Approved" do
        it "should not allow the user with a role of editor to read a page they are not an editor for" do
          editor_ability.should_not be_able_to(:read, Factory.build(:page))
        end

        it "should not allow the user with a role of editor to update a page they are not an editor for" do
          editor_ability.should_not be_able_to(:update, Factory.build(:page))
        end

        it "should not allow the user with a role of editor to destroy pages they are not an editor for" do
          editor_ability.should_not be_able_to(:destroy, Factory.build(:page))
        end

        it "should not allow the user to manage pages on another site" do
          editor_ability.should_not be_able_to(:read, page2)
          editor_ability.should_not be_able_to(:create, page2)
          editor_ability.should_not be_able_to(:update, page2)
          editor_ability.should_not be_able_to(:destroy, page2)
        end
      end

      describe "MediaFile Model Not Approved" do
        it "should not allow the user to destroy media_files they didn't create" do
          editor_ability.should_not be_able_to(:destroy, Factory.build(:media_file, :created_by => admin, :site => site))
        end
        
        it "should not allow the user to manage media_files on another site" do
          editor_ability.should_not be_able_to(:read, media_file2)
          editor_ability.should_not be_able_to(:create, media_file2)
          editor_ability.should_not be_able_to(:update, media_file2)
          editor_ability.should_not be_able_to(:destroy, media_file2)
        end
      end
  end   
end