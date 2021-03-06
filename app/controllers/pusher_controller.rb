# frozen_string_literal: true

class PusherController < ApplicationController
  # stop rails CSRF protection for this action
  protect_from_forgery except: :auth

  # POST /pusher/auth
  # @argument channel_name [String] The name of the pusher channel.
  # @argument socket_id [String] The id of the pusher socket.
  #
  # Returns an auth token from Pusher that looks like this
  # {"auth": "some-auth-key"}
  #
  # If there is an error, the response will look like this
  # {"channel_name":["can't be blank"],"socket_id":["can't be blank"]}
  def auth
    errors = {}
    message = [I18n.t('errors.empty_params')]
    errors[:channel_name] = message if params[:channel_name].blank?
    errors[:socket_id] = message if params[:socket_id].blank?

    if errors.empty?
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id])
      render json: response
    else
      render json: errors, status: :bad_request
    end
  end
end
