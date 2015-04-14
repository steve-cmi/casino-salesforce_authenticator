require 'active_record'
require 'unix_crypt'
require 'bcrypt'
require 'phpass'

class CASino::SalesforceAuthenticator
  attr_accessor :error, :options, :client, :model, :token if Rails.env.development?

  # @param [Hash] options
  def initialize(options)
    if !options.respond_to?(:deep_symbolize_keys)
      raise ArgumentError, "When assigning attributes, you must pass a hash as an argument."
    end
    @options = options.deep_symbolize_keys
    raise ArgumentError, "Connection info is missing" unless @options[:connection]
    @client = Databasedotcom::Client.new(
      :host => @options[:connection][:host],
      :client_id => @options[:connection][:client_id],
      :client_secret => @options[:connection][:client_secret],
      :verify_client => OpenSSL::SSL::VERIFY_NONE)
    @token = @client.authenticate(
      :username => @options[:connection][:username],
      :password => @options[:connection][:password])
    @model = @client.materialize(@options[:sobject] || 'Contact')
  rescue Databasedotcom::SalesForceError => sf_error
    @error = sf_error
  end

  def error
    @error
  end

  def validate(username, password)
    user = @model.send("find_by_#{@options[:username_column]}", username)
    password_from_database = user.send(@options[:password_column])

    if valid_password?(password, password_from_database)
      user_data(user)
    else
      false
    end
  rescue Databasedotcom::SalesForceError => sf_error
    @error = sf_error
    false
  end

  def load_user_data(username)
    user = @model.send("find_by_#{@options[:username_column]}", username)
    user_data(user)
  rescue Databasedotcom::SalesForceError => sf_error
    @error = sf_error
    nil
  end

  private
  def user_data(user)
    { username: user.send(@options[:username_column]), extra_attributes: extra_attributes(user) }
  end

  def valid_password?(password, password_from_database)
    password == password_from_database
    # return false if password_from_database.blank?
    # magic = password_from_database.split('$')[1]
    # case magic
    # when /\A2a?\z/
    #   valid_password_with_bcrypt?(password, password_from_database)
    # when /\AH\z/, /\AP\z/
    #   valid_password_with_phpass?(password, password_from_database)
    # else
    #   valid_password_with_unix_crypt?(password, password_from_database)
    # end
  end

  def valid_password_with_bcrypt?(password, password_from_database)
    password_with_pepper = password + @options[:pepper].to_s
    BCrypt::Password.new(password_from_database) == password_with_pepper
  end

  def valid_password_with_unix_crypt?(password, password_from_database)
    UnixCrypt.valid?(password, password_from_database)
  end

  def valid_password_with_phpass?(password, password_from_database)
    Phpass.new().check(password, password_from_database)
  end

  def extra_attributes(user)
    attributes = {}
    extra_attributes_option.each do |attribute_name, database_column|
      attributes[attribute_name] = user.send(database_column)
    end
    attributes
  end

  def extra_attributes_option
    @options[:extra_attributes] || {}
  end
end
