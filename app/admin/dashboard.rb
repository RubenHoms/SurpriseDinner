ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    render 'today'
    render 'financial'
    render 'city'
  end
end
