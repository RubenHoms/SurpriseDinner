context.instance_eval do
  tabs do
    tab 'Overzicht' do
      panel 'Details' do
        attributes_table_for(restaurant) do
          row :name
          row :image do
            image_tag(restaurant.image.url(:medium))
          end
          row :full_address
          row :telephone
          row :email
          row :meeting_point
          row :created_at
          row :updated_at
        end
      end

      panel 'Bankgegevens' do
        attributes_table_for(restaurant) do
          row :iban
          row :bic
        end
      end

      panel 'Van meeting point (A) naar restaurant (B)' do
        div id: 'map', class: 'google_map' do
          render partial: 'map/directions', locals: {from: restaurant, to: restaurant.meeting_point }
        end
      end
    end

    tab 'Thema afspraken' do
      table_for restaurant.package_deals do |deal|
        column(:package) {|deal| deal.package.name }
        column :price
        column('Originele thema prijs') { |deal| deal.package.price}
      end
    end
  end

  active_admin_comments
end