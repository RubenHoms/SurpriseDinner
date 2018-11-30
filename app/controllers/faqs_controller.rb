# == Schema Information
#
# Table name: faqs
#
#  id         :integer          not null, primary key
#  title      :string
#  content    :text
#  published  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FaqsController < ApplicationController
  def index
    @faqs = Faq.published
  end
end
