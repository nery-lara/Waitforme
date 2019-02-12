module ApplicationHelper
  include CacheHelper

  def create_username
    cache_incr('user_count')
    username = 'user' + cache_get('user_count')
  end

  def add_user_key(user, value)
    cache_set_add(user, value)
  end
  def get_user_key(value)
    #look for value in cache_set
    #
  end
  def fetch_session(key)
    session_json = cache_get(key)
    session_parsed = JSON.parse(session_json)
    session = Session.new
    session.user.number = session_parsed['user']['number']
    session.user.sid = session_parsed['user']['sid']
    session.user.name = session_parsed['user']['name']
    session.business.number = session_parsed['business']['number']
    session.business.sid = session_parsed['business']['sid']
    session.conference.sid = session_parsed['conference']['sid']
    session.conference.name = session_parsed['conference']['name']
    session
  end

  def store_session(key, session)
    cache_set(key, session.to_json)
  end
end
