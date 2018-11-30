context.instance_eval do
  attributes_table_for(package) do
    row :name
    row :price
    row :featured
    row :description do |package|
      truncate(package.description, seperator: ' ', escape: false)
    end
  end

  panel 'Thema kenmerken' do
    table_for package.selling_points do
      column { |p| p}
    end
  end

  panel 'Image' do
    div do
      render partial: 'onsgeheim/packages/image', locals: { image_url: package.image(:normal) }
    end
  end

  active_admin_comments
end