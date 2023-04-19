# frozen_string_literal: true

class BlobsController < ApplicationController
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  http_basic_authenticate_with name: Rails.configuration.file_api.basic_auth_username,
                               password: Rails.configuration.file_api.basic_auth_password

  def index
    file = File.read('received_files/data/description.json')
    data = JSON.parse(file)
    render json: data
  end

  def show
    file_path = "received_files/#{params[:blob][:id]}_edited.json"
    if File.exist?(file_path)
      file_contents = File.read(file_path)
      render json: JSON.parse(file_contents)
    else
      render json: { error: 'File not found' }, status: :not_found
    end
  end

  def create
    json = params['blob'].as_json
    uuid = SecureRandom.uuid
    filename = "#{uuid}.json"
    filepath = "received_files/#{filename}"

    if File.write(filepath, JSON.pretty_generate(json))
      file_content = File.read(filepath)
      updated_content = Blob.manipulate_file_content(file_content)
      Blob.create_description_file(uuid, updated_content)

      updated_filename = "#{uuid}_edited.json"
      updated_filepath = "received_files/#{updated_filename}"

      File.write(updated_filepath, JSON.pretty_generate(updated_content))
      json['document_id'] = uuid
      json['document_filename'] = filename
      json['edited_filename'] = updated_filename
      render json:, status: 201
    else
      render json: { error: 'unprocessible_entry' }, status: 422
    end
  end
end
