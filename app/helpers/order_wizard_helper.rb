module OrderWizardHelper
  def wizard_navigation
    content_tag(:ul, class: 'nav nav-pills nav-order-wizard') do
      wizard_steps.collect do |wizard_step|
        step_class = 'disabled' if future_step?(wizard_step)
        step_class = 'active' if step == wizard_step

        content_tag(:li, class: step_class) do
          if future_step?(wizard_step)
            concat link_to wizard_step.to_s.humanize, '#'
          else
            concat link_to wizard_step.to_s.humanize, wizard_path(wizard_step)
          end
          concat content_tag(:div, nil, class: 'nav-arrow')
        end
      end.join.html_safe
    end
  end
end
