module TimingScopes
  extend ActiveSupport::Concern

  included do

    scope :this_month, -> do
      this_month = Date.today.at_beginning_of_month
      where("created_at BETWEEN ? AND ?", this_month, 1.second.ago)
    end

    scope :this_week, -> do
      this_week = Date.today.at_beginning_of_week
      where("created_at BETWEEN ? AND ?", this_week, 1.second.ago)
    end

    scope :last_month, -> do
      last_month = Date.today.at_beginning_of_month.last_month
      this_month = Date.today.at_beginning_of_month.next_month
      where("created_at BETWEEN ? AND ?", last_month, this_month)
    end

    scope :last_week, -> do
      last_week = Date.today.at_beginning_of_month.last_week
      this_week = Date.today.at_beginning_of_month.next_week
      where("created_at BETWEEN ? AND ?", last_week, this_week)
    end

  end

end
