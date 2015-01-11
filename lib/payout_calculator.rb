class PayoutCalculator < Struct.new(:order_ids)
  OUR_CUT = 0.15.freeze unless defined?(OUR_CUT)
  TRANSACTION_FEE = 0.3.freeze unless defined?(TRANSACTION_FEE)
  LATE_FEE = 0.25.freeze unless defined?(LATE_FEE)

  def revenue
    orders.completed.joins(:price).sum("prices.price_in_cents").to_f / 100.0
  end

  def transaction_fee
    orders.completed.count * TRANSACTION_FEE
  end

  def late_fee
    return 0.0 if orders.completed.late.count.zero?

    seconds_spent_delivering = DateTime.parse(orders.completed.late.sum("orders.delivered_at - orders.created_at").to_s) - DateTime.parse("00:00")
    
    # Allow 15 minutes (60 * 15) for each order
    seconds_spent_delivering_on_time = 60 * 15 * orders.completed.late.count

    minutes_late = (seconds_spent_delivering - seconds_spent_delivering_on_time) / 60.0

    (minutes_late.floor * LATE_FEE).abs
  end

  def our_cut
    revenue * OUR_CUT
  end

  def payout
    revenue - transaction_fee - late_fee - our_cut
  end

  def orders
    @orders ||= Order.where(id: order_ids)
  end

end