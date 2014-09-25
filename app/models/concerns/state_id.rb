module StateID

  def state_id
    self.class.states[self.state]
  end

end
