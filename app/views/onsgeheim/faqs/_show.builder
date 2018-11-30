context.instance_eval do
  attributes_table do
    row :title
    row :published
    row :content do |faq_item|
      faq_item.content.html_safe
    end
  end
end