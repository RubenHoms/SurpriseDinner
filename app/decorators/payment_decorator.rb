class PaymentDecorator < Draper::Decorator
  decorates :payment
  delegate_all

  # This method uses the authResult param returned from Adyen to display
  # the result of the payment.
  def auth_result
    case object.auth_result
      when "AUTHORISED"
        "The payment authorisation was successfully completed"
      when "REFUSED"
        "The payment was refused. Payment authorisation was unsuccessful."
      when "CANCELED"
        "The payment was cancelled by the shopper before completion, or the shopper returned to the merchant's site before completing the transaction."
      when "PENDING"
        "It is not possible to obtain the final status of the payment."
      when "ERROR"
        "An error occurred during the payment processing."
    end
  end

  def success?
    false if Payment::ERROR_CASES.include? object.auth_result
    true if Payment::SUCCESS_CASES.include? object.auth_result
  end

end
