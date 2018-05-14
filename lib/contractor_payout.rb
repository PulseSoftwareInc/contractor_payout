require 'active_support/all'
require 'pry-byebug'

# Feature Request: A new "Team C"
#   Team C gets overtime at 2x salary
#   Team C has an hourly rate of $70
#   Team C pays out every week

class ContractorPayout
  attr_reader :payout, :accrued_earnings, :days_until_payout, :team

  def initialize(accrued_earnings: 0, days_until_payout:, team: 'N/A')
    @payout = 0
    @accrued_earnings = accrued_earnings
    @days_until_payout = days_until_payout
    @team = team
  end

  def nightly_process!(hours_today:)
    earnings_today = 0

    if @team == 'A Team'
      earnings_today += hours_today * 70
    else
      earnings_today += hours_today * 50

      if @team == 'B Team' && hours_today > 8
        earnings_today += (hours_today - 8) * 0.5
      end
    end

    @accrued_earnings += earnings_today
    @days_until_payout -= 1

    if @days_until_payout.zero?
      @payout = @accrued_earnings
      @accrued_earnings = 0
      @days_until_payout += 14
    end
  end
end
