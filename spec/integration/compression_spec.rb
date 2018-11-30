require 'rails_helper'

feature 'Compression', type: :request do
  scenario "a visitor has a browser that supports compression" do
    ['deflate','gzip', 'deflate,gzip','gzip,deflate'].each do|compression_method|
      get root_url, {}, {'HTTP_ACCEPT_ENCODING' => compression_method }
      expect(response.headers['Content-Encoding']).to be
    end
  end

  scenario "a visitor's browser does not support compression" do
    get root_url
    expect(response.headers['Content-Encoding']).to_not be
  end
end