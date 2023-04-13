# frozen_string_literal: true

class Summoners::HeaderComponent < ApplicationComponent
  def initialize(summoner:, alert: nil)
    @summoner = summoner
    @alert = alert
  end
end
