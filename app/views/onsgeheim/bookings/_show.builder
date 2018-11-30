context.instance_eval do
  tabs do
    tab 'Overzicht' do
      attributes_table do
        row :name
        row :date
        row :time
        row :persons
        row :telephone
        row :email
        row :city
        row :notes
        row :personal_message
        row :package
        row :notified_at
      end

      panel 'Code' do
        render 'onsgeheim/code/show', code: booking.code, context: self
      end

      active_admin_comments
    end

    tab "Vorige boekingen (#{booking.previous_bookings.count})" do
      table_for booking.previous_bookings do |booking|
        column(:restaurant) { |booking| booking.restaurant.try(:name) }
        column(:thema) { |booking| booking.package.name }
        column(:personen) { |booking| booking.persons }
        column(:stad) { |booking| booking.city.name }
        column(:wanneer) { |booking| booking.at }
      end
    end

    tab 'Restaurant' do
      render 'onsgeheim/restaurants/show', restaurant: booking.restaurant, context: self
    end unless booking.restaurant.nil?

    tab 'Thema' do
      render 'onsgeheim/packages/show', package: booking.package, context: self
    end unless booking.package.nil?

    tab 'Betalingsgegevens' do
      render 'onsgeheim/payments/show', payments: booking.payments, booking: booking, context: self
    end

    tab 'Ingeplande opdrachten' do
      render 'onsgeheim/scheduled_jobs/show', scheduled_jobs: booking.scheduled_jobs, context: self
    end
  end

end