RSpec.describe 'Contractor Payout' do
  it 'accrues hours' do
    bob = ContractorPayout.new(accrued_earnings: 400, days_until_payout: 10)
    bob.nightly_process!(hours_today: 8)
    expect(bob.accrued_earnings).to eq(400 + 8 * 50)
  end

  it 'accrues hours for 9 business days' do
    bob = ContractorPayout.new(accrued_earnings: 400, days_until_payout: 14)

    5.times { bob.nightly_process!(hours_today: 8) }
    2.times { bob.nightly_process!(hours_today: 0) } # weekend
    4.times { bob.nightly_process!(hours_today: 8) }

    expect(bob.accrued_earnings).to eq(400 + (9 * 8) * 50)
    expect(bob.days_until_payout).to eq(3)
  end

  it 'calculates payout every two weeks' do
    bob = ContractorPayout.new(accrued_earnings: 80, days_until_payout: 1)
    bob.nightly_process!(hours_today: 8)
    expect(bob.payout).to eq(80 + 8 * 50)
    expect(bob.days_until_payout).to eq(14)
  end
end
