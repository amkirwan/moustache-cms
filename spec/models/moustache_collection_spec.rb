require 'spec_helper'

describe MoustacheCollection do

  # -- Associations --- 
  describe "associations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:site_id) }
  end
  
end
