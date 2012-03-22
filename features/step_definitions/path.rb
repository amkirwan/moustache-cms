module Path
  def path_should_be(path)
    current_path.should == path
  end
end

World(Path)
