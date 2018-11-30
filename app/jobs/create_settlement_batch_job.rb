class CreateSettlementBatchJob
  include Sidekiq::Worker

  def perform
    @batch_for_date = DateTime.yesterday
    @bookings = bookings
    return unless @bookings.any?

    name = "Betalingsopdracht voor #{@batch_for_date.to_formatted_s(:short)}"
    settlements = @bookings.map{ |b| Settlement.from_booking(b) }
    SettlementBatch.create!(settlements: settlements, name: name).save_xml
  end

  def bookings
    Booking.joins(:code).on_date(@batch_for_date).where.not(codes: { activated_at: nil })
  end
end
