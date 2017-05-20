module Api
  class PagesController < ApplicationController

    def index
      render layout: 'basic'
    end
  end
end
