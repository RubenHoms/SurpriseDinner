module FormErrorHelper
  def errors_for(object)
    return unless object.errors.full_messages.any?
    content_tag(:div, class: 'alert alert-danger') do
      content_tag(
        :strong, 'Controleer de verplicht velden:', class: 'margin-bottom'
      ) + content_tag(:div, object.errors.full_messages.to_sentence)
    end
  end
end
