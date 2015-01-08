class PayoutCalculator < Struct.new(:order_ids)

  def revenue
    orders.completed.joins(:price).sum("prices.price_in_cents").to_f / 100.0
  end

  def transaction_fee
    orders.completed.count * 0.3
  end

  def late_fee
    return 0.0 if orders.completed.late.count.zero?

    seconds_spent_delivering = DateTime.parse(orders.completed.late.sum("orders.delivered_at - orders.created_at").to_s) - DateTime.parse("00:00")
    
    # Allow 15 minutes (60 * 15) for each order
    seconds_spent_delivering_on_time = 60 * 15 * orders.completed.late.count
    
    minutes_late = (seconds_spent_delivering - seconds_spent_delivering_on_time) / 60.0

    # Late fee is $0.50/minute
    minutes_late * 0.5
  end

  def our_cut
    revenue * 0.15
  end

  def payout
    revenue - transaction_fee - late_fee - our_cut
  end

  def orders
    @orders ||= Order.where(id: order_ids)
  end

end