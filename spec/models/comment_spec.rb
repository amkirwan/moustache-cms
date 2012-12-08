require 'spec_helper'

describe Comment do

  describe "associations" do
    it { should be_embedded_in(:article) }
  end

  describe "validations" do
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:author_email) }
    it { should validate_presence_of(:content) }
  end

end
