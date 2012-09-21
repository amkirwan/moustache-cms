def ability_init
  @ability = Object.new
  @ability.extend(CanCan::Ability)
  @controller.stub(:current_ability) { @ability }
end