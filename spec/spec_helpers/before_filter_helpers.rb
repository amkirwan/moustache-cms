module BeforeFilterHelpers
  def current_site_faker(site=nil)
    site = mock_model("Site") unless !site.nil?
    controller.stub(:current_site).and_return(site)
  end
end