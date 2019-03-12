module ApplicationHelper
  include CacheHelper

  def create_user
    session = Session.new
    session.user.name = create_username
    session.conference.name = 'conference_' + session.user.name
    session
  end

  def create_username
    cache_incr('user_count')
    username = 'user' + cache_get('user_count')
  end

  def fetch_session(key)
    serialized_session = cache_get(key)
    YAML::load(serialized_session)
  end

  def store_session(key, session)
    cache_set(key, YAML::dump(session))
  end

  def fetch_client
    serialized_client = cache_get('client')
    YAML::load(serialized_client)
  end

  def store_client(client)
    cache_set('client', YAML::dump(client))
  end

  def fetch_url
    cache_get('url')
  end

  def store_url(url)
    cache_set('url', url)
  end

  def fetch_twilio_number
    cache_get('twilio_number')
  end

  def store_twilio_number(number)
    cache_set('twilio_number', number)
  end

  def store_ivr_session(session)
    cache_set('ivr', YAML::dump(session))
  end

  def fetch_ivr_session
    cache_get('ivr')
  end
end
