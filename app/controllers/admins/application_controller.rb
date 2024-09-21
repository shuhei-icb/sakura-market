class Admins::ApplicationController < ApplicationController
  layout 'layouts/admins/application'
  before_action :authenticate_admin!
end
