context.instance_eval do
  attributes_table do
    row :name
    row :description
    row :full_address
  end

  panel 'Locatie' do
    div id: 'map', class: 'google_map' do
      render partial: 'map/marker_map', locals: { location: meeting_point }
    end
  end

  active_admin_comments
end